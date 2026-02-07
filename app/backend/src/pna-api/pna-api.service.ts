import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AlertsService } from '../alerts/alerts.service';
import { PnaApiParser } from './pna-api.parser';
import { PnaReporteCostera } from './pna-api.interfaces';
import { DateTime } from 'luxon';
import { readFileSync } from 'fs';
import { join } from 'path';
import { AlertaPrioridad, AlertaEstado } from '../alerts/alerts.enums';

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
        const existing = await this.prisma.pnaApiSnapshot.findUnique({
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

        // Check if vessel has an active tide (DESIGNADA or EN_EJECUCION)
        const activeTide = await this.prisma.marea.findFirst({
            where: {
                buqueId: buque.id,
                estadoActual: {
                    codigo: { in: ['DESIGNADA', 'EN_EJECUCION'] }
                }
            },
            include: {
                etapas: true,
                estadoActual: true
            }
        });

        // Create snapshot (always created for audit)
        const snapshot = await this.createSnapshot(reporte, comboId, fechaLocal.toJSDate(), null);

        if (!activeTide) {
            this.logger.debug(`Skipping alert for ${buque.nombreBuque}: No active tide found`);
            return { processed: true, alertCreated: false, alertValidated: false };
        }

        // 1. Check if event matches an existing registered stage
        const stageMatch = await this.findMatchingStage(activeTide, reporte.estado, fechaLocal, puerto?.id);
        if (stageMatch) {
            this.logger.log(`Report matches registered stage in marea ${activeTide.nroMarea}/${activeTide.anioMarea}. No alert needed.`);
            return { processed: true, alertCreated: false, alertValidated: false };
        }

        // 2. Alert logic: search for existing or create new
        const alertResult = await this.handleAlert(buque.id, reporte.estado, fechaLocal, puerto?.id, reporte, activeTide.id);

        // Update snapshot with alert link
        if (alertResult.alertId) {
            await this.prisma.pnaApiSnapshot.update({
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
     * Check if the event matches a registered stage (+/- 24h, same port)
     */
    private async findMatchingStage(marea: any, estado: 'ZARPADA' | 'ARRIBO', fechaLocal: DateTime, puertoId?: string) {
        for (const etapa of marea.etapas) {
            const fechaEtapaRaw = estado === 'ZARPADA' ? etapa.fechaZarpada : etapa.fechaArribo;
            if (!fechaEtapaRaw) continue;

            const fechaEtapa = DateTime.fromJSDate(fechaEtapaRaw).setZone(this.TIMEZONE);

            // Match criteria: same day (+/- 24h window)
            const diffDays = Math.abs(fechaLocal.startOf('day').diff(fechaEtapa.startOf('day'), 'days').days);

            if (diffDays <= 1) {
                // Port validation: if we have puertoId, it should match
                const etapaPuertoId = estado === 'ZARPADA' ? etapa.puertoZarpadaId : etapa.puertoArriboId;
                if (!puertoId || !etapaPuertoId || puertoId === etapaPuertoId) {
                    return etapa;
                }
            }
        }
        return null;
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
        return this.prisma.pnaApiSnapshot.create({
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
        buqueId: string,
        estado: 'ZARPADA' | 'ARRIBO',
        fechaLocal: DateTime,
        puertoId: string | null,
        reporte: PnaReporteCostera,
        mareaId: string,
    ) {
        // Search for existing alert in time window
        const windowStart = fechaLocal.minus({ hours: this.ALERT_WINDOW_HOURS }).toJSDate();
        const windowEnd = fechaLocal.plus({ hours: this.ALERT_WINDOW_HOURS }).toJSDate();

        const existingAlert = await this.prisma.alerta.findFirst({
            where: {
                tipo: estado,
                estado: { in: [AlertaEstado.PENDIENTE, AlertaEstado.SEGUIMIENTO] },
                fechaDetectada: {
                    gte: windowStart,
                    lte: windowEnd,
                },
                metadata: {
                    path: ['buqueId'],
                    equals: buqueId,
                },
            },
        });

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
                },
            );
            return { alertId: existingAlert.id, created: false, validated: true };
        }

        // Create new alert linked to marea
        this.logger.log(`Creating new alert for ${estado} detected by PNA API`);
        const newAlert = await this.alertsService.create({
            codigoUnico: `PNA_${estado}_${buqueId}_${fechaLocal.toFormat('yyyyMMdd_HHmmss')}`,
            tipo: estado,
            titulo: `${estado} detectada - ${reporte.nombre}`,
            descripcion: `${estado} en ${reporte.nombre_costera} el ${fechaLocal.toFormat('dd/MM/yyyy HH:mm')}`,
            estado: AlertaEstado.PENDIENTE,
            prioridad: AlertaPrioridad.MEDIA,
            referenciaId: mareaId,
            referenciaTipo: 'MAREA',
            metadata: {
                buqueId,
                puertoId,
                fecha: fechaLocal.toISO(),
                source: 'API_PNA',
                sources: [{
                    name: 'API_PNA',
                    detectedAt: fechaLocal.toISO(),
                    data: {
                        id_costera: reporte.id_costera,
                        nombre_costera: reporte.nombre_costera,
                    },
                }],
            },
        });

        return { alertId: newAlert.id, created: true, validated: false };
    }
}
