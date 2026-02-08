import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AlertsService } from '../alerts/alerts.service';
import { PnaApiParser } from './pna-api.parser';
import { PnaReporteCostera } from './pna-api.interfaces';
import { DateTime } from 'luxon';
import { readFileSync } from 'fs';
import { join } from 'path';
import { AlertaPrioridad, AlertaEstado } from '../alerts/alerts.enums';
import { EventCorrelationService } from '../common/services/event-correlation.service';

interface ProcessingSummary {
    total: number;
    processed: number;
    skipped: number;
    alertsCreated: number;
    alertsValidated: number;
    errors: number;
}

@Injectable()
export class PnaApiService {
    private readonly logger = new Logger(PnaApiService.name);
    private readonly ALERT_WINDOW_HOURS = 24; // Ventana de búsqueda de alertas existentes
    private readonly TIMEZONE = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';

    constructor(
        private prisma: PrismaService,
        private alertsService: AlertsService,
        private parser: PnaApiParser,
        private correlationService: EventCorrelationService,
    ) { }

    /**
     * Main processing method - reads mock file and processes reports
     */
    async processMovements(): Promise<ProcessingSummary> {
        const summary: ProcessingSummary = {
            total: 0,
            processed: 0,
            skipped: 0,
            alertsCreated: 0,
            alertsValidated: 0,
            errors: 0,
        };

        try {
            // Read mock XML file
            const mockPath = join(process.cwd(), 'old_data', 'zarpadas_y_arribos.asmx');
            const xmlContent = readFileSync(mockPath, 'utf-8');

            // Parse XML
            const apiResponse = await this.parser.parseXml(xmlContent);

            if (apiResponse.error) {
                this.logger.error(`API returned error: ${apiResponse.mensaje}`);
                return summary;
            }

            summary.total = apiResponse.reportes.length;
            this.logger.log(`Processing ${summary.total} reportes from PNA API`);

            // Process each report
            for (const reporte of apiResponse.reportes) {
                try {
                    // Skip deleted reports
                    if (reporte.borrado === 'True') {
                        summary.skipped++;
                        continue;
                    }

                    const result = await this.processSingleReport(reporte);

                    if (result.processed) {
                        summary.processed++;
                        if (result.alertCreated) summary.alertsCreated++;
                        if (result.alertValidated) summary.alertsValidated++;
                    } else {
                        summary.skipped++;
                    }
                } catch (error) {
                    this.logger.error(`Error processing reporte ${reporte.id_buque_mbpc}:`, error);
                    summary.errors++;
                }
            }

            this.logger.log(`Processing complete: ${JSON.stringify(summary)}`);
            return summary;
        } catch (error) {
            this.logger.error('Error in processMovements:', error);
            throw error;
        }
    }

    /**
     * Process a single report
     */
    private async processSingleReport(reporte: PnaReporteCostera) {
        const comboId = this.parser.generateComboId(reporte);

        // Check if already processed
        const existing = await (this.prisma as any).pnaApiSnapshot.findUnique({
            where: { externalComboId: comboId },
        });

        if (existing) {
            this.logger.debug(`Reporte ${comboId} already processed, skipping`);
            return { processed: false, alertCreated: false, alertValidated: false };
        }

        // Parse fecha (UTC) to local timezone
        const fechaUtc = DateTime.fromFormat(reporte.fecha, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' });
        const fechaLocal = fechaUtc.setZone(this.TIMEZONE);

        // Find vessel
        const buque = await this.findVessel(reporte);
        if (!buque) {
            this.logger.warn(`Vessel not found for reporte: ${reporte.nombre} (MBPC: ${reporte.id_buque_mbpc})`);
            // Still save snapshot for audit
            await this.createSnapshot(reporte, comboId, fechaLocal.toJSDate(), null);
            return { processed: true, alertCreated: false, alertValidated: false };
        }

        // Find puerto
        const puerto = await this.findPuerto(reporte.id_costera);

        // Create snapshot (always created for audit)
        const snapshot = await this.createSnapshot(reporte, comboId, fechaLocal.toJSDate(), null);

        // 1. Encontrar la mejor marea para este evento usando el servicio centralizado
        const activeTide = await this.correlationService.findBestMareaMatch(buque.id, reporte.estado);

        if (!activeTide) {
            this.logger.debug(`Skipping alert for ${buque.nombreBuque}: No matchable tide found`);
            return { processed: true, alertCreated: false, alertValidated: false };
        }

        // 2. Verificar si el evento coincide con una etapa ya registrada
        const stageMatch = this.correlationService.findMatchingStage(activeTide, reporte.estado, fechaLocal.toJSDate(), puerto?.id, reporte.nombre_costera);
        if (stageMatch) {
            this.logger.log(`Report matches registered stage in marea ${activeTide.nroMarea}/${activeTide.anioMarea}. No alert needed.`);
            return { processed: true, alertCreated: false, alertValidated: false };
        }

        // 3. Lógica de alertas: buscar existentes (deduplicación) o crear nueva
        const alertResult = await this.handleAlert(buque, reporte.estado, fechaLocal, puerto, reporte, activeTide);

        // Update snapshot with alert link
        if (alertResult.alertId) {
            await (this.prisma as any).pnaApiSnapshot.update({
                where: { id: snapshot.id },
                data: { alertId: alertResult.alertId },
            });
        }

        return {
            processed: true,
            alertCreated: alertResult.created,
            alertValidated: alertResult.validated,
        };
    }


    /**
     * Find vessel by priority: MBPC > Señal Distintiva > Matrícula > Nombre
     */
    private async findVessel(reporte: PnaReporteCostera) {
        // Priority 1: ID MBPC
        if (reporte.id_buque_mbpc) {
            const byMbpc = await this.prisma.buque.findFirst({
                where: { idMbpc: reporte.id_buque_mbpc },
            });
            if (byMbpc) return byMbpc;
        }

        // Priority 2: Señal Distintiva
        if (reporte.sdist) {
            const bySdist = await this.prisma.buque.findFirst({
                where: { senalDistintiva: reporte.sdist },
            });
            if (bySdist) return bySdist;
        }

        // Priority 3: Matrícula (fallback)
        if (reporte.matricula && reporte.matricula !== '0') {
            const byMatricula = await this.prisma.buque.findFirst({
                where: { matricula: reporte.matricula },
            });
            if (byMatricula) return byMatricula;
        }

        // Priority 4: Nombre (last resort)
        if (reporte.nombre) {
            const byNombre = await this.prisma.buque.findFirst({
                where: { nombreBuque: { equals: reporte.nombre, mode: 'insensitive' } },
            });
            if (byNombre) return byNombre;
        }

        return null;
    }

    /**
     * Find puerto by codigo_externo
     */
    private async findPuerto(idCostera: string) {
        return this.prisma.puerto.findFirst({
            where: { codigoExterno: idCostera },
        });
    }

    /**
     * Create snapshot record
     */
    private async createSnapshot(
        reporte: PnaReporteCostera,
        comboId: string,
        fecha: Date,
        alertId: string | null,
    ) {
        return (this.prisma as any).pnaApiSnapshot.create({
            data: {
                idCostera: reporte.id_costera,
                externalComboId: comboId,
                payload: reporte as any,
                buqueIdMbpc: reporte.id_buque_mbpc,
                buqueNombre: reporte.nombre,
                estado: reporte.estado,
                fecha,
                alertId,
            },
        });
    }

    /**
     * Handle alert creation or validation
     * Returns: { alertId, created, validated }
     */
    private async handleAlert(
        buque: any,
        estado: 'ZARPADA' | 'ARRIBO',
        fechaLocal: DateTime,
        puerto: any | null,
        reporte: PnaReporteCostera,
        marea: any,
    ) {
        // Search for existing alert in time window using centralized correlation service
        const existingAlert = await this.correlationService.findExistingAlert(buque.id, estado, fechaLocal.toJSDate());

        if (existingAlert) {
            // Validate existing alert
            this.logger.log(`Validating existing alert ${existingAlert.id} with PNA API source`);
            await this.alertsService.addValidationSource(
                existingAlert.id,
                'API_PNA',
                {
                    fecha: fechaLocal.toISO(),
                    id_costera: reporte.id_costera,
                    nombre_costera: reporte.nombre_costera,
                    source: 'API_PNA',
                },
            );
            return { alertId: existingAlert.id, created: false, validated: true };
        }

        // Create new alert linked to marea
        this.logger.log(`Creating new alert for ${estado} detected by PNA API`);

        const yearSuffix = String(marea.anioMarea).slice(-2);
        const mareaLabel = marea.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${marea.nroMarea}-${yearSuffix}`;
        const dateStr = fechaLocal.toFormat('dd/MM HH:mm');
        const portName = puerto?.nombre || reporte.nombre_costera || 'Puerto Desconocido';

        const titulo = `${buque.nombreBuque}: ${estado} detectada en ${portName} el ${dateStr} (PNA)`;
        const descripcion = `Se detectó un evento de ${estado.toLowerCase()} informado por Prefectura Naval Argentina.\n\n` +
            `🚢 Buque: ${buque.nombreBuque}\n` +
            `📍 Puerto: ${portName}\n` +
            `📅 Fecha: ${fechaLocal.toFormat('dd/MM/yyyy HH:mm')}\n` +
            `🌊 Marea: ${mareaLabel}\n\n` +
            `Origen: Reporte oficial API PNA (ID: ${reporte.id_costera}).`;

        const newAlert = await this.alertsService.create({
            codigoUnico: `PNA_${estado}_${buque.id}_${fechaLocal.toFormat('yyyyMMdd_HHmmss')}`,
            tipo: estado,
            titulo: titulo,
            descripcion: descripcion,
            estado: AlertaEstado.PENDIENTE,
            prioridad: AlertaPrioridad.MEDIA,
            fechaDetectada: fechaLocal.toJSDate(),
            referenciaId: marea.id,
            referenciaTipo: 'MAREA',
            metadata: {
                // Metadata Estandarizada
                type: estado,
                subTipo: estado,
                source: 'API_PNA',
                buqueId: buque.id,
                mareaId: marea.id,
                mareaCode: mareaLabel,
                vesselName: buque.nombreBuque,
                portId: puerto?.id || null,
                portName: portName,
                eventDate: fechaLocal.toJSDate(),

                // Datos específicos de PNA
                externalData: {
                    id_costera: reporte.id_costera,
                    nombre_costera: reporte.nombre_costera,
                    id_buque_mbpc: reporte.id_buque_mbpc,
                    senial: reporte.sdist,
                    matricula: reporte.matricula,
                    [estado === 'ZARPADA' ? 'fechaZarpada' : 'fechaArribo']: fechaLocal.toJSDate(),
                    [estado === 'ZARPADA' ? 'puertoZarpadaId' : 'puertoArriboId']: puerto?.id || null,
                },

                // Compatibilidad con Source Stacking
                sources: [{
                    name: 'API_PNA',
                    detectedAt: fechaLocal.toISO(),
                    data: {
                        id_costera: reporte.id_costera,
                        nombre_costera: reporte.nombre_costera,
                    },
                }],
            } as any, // Cast to any because source 'API_PNA' was just added and might not be in all relevant types yet if they are cached
        });

        return { alertId: newAlert.id, created: true, validated: false };
    }
}
