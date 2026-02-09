import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';
import { PrismaService } from '../prisma/prisma.service';
import { AlertsService } from '../alerts/alerts.service';
import { PnaApiParser } from './pna-api.parser';
import { PnaReporteCostera } from './pna-api.interfaces';
import { DateTime } from 'luxon';
import { readFileSync } from 'fs';
import { join } from 'path';
import { AlertaPrioridad, AlertaEstado } from '../alerts/alerts.enums';
import { AlertMetadata } from '../alerts/interfaces/alert-metadata.interface';
import { EventCorrelationService, EventDecisionAction } from '../common/services/event-correlation.service';

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
        private configService: ConfigService,
    ) { }

    /**
    * Main processing method - reads mock file and processes reports
    * @param fromDate Optional start date. If not provided, uses LAST_PNA_SYNC from system_status
    * @param toDate Optional end date. Defaults to now.
    */
    async processMovements(fromDate?: Date, toDate?: Date): Promise<ProcessingSummary> {
        const summary: ProcessingSummary = {
            total: 0,
            processed: 0,
            skipped: 0,
            alertsCreated: 0,
            alertsValidated: 0,
            errors: 0,
        };

        try {
            // 1. Determinar rango de fechas
            // 1. Determinar rango de fechas
            const now = DateTime.now().toUTC();
            const effectiveToDate = toDate ? DateTime.fromJSDate(toDate).toUTC() : now;

            let effectiveFromDate: DateTime;
            if (fromDate) {
                effectiveFromDate = DateTime.fromJSDate(fromDate).toUTC();
            } else {
                const lastSync = await this.getLastSuccessfulSyncDate();
                // Si no hay última sincro, usamos una ventana por defecto de 48hs
                effectiveFromDate = lastSync
                    ? DateTime.fromJSDate(lastSync).toUTC()
                    : now.minus({ days: 2 });
            }

            // REGLA: Iniciamos siempre a las 00:00:00 de la fecha "desde" para solapar datos
            const startRange = effectiveFromDate.startOf('day');
            const endRange = effectiveToDate.endOf('day');

            this.logger.log(`Iniciando sincronización PNA: ${startRange.toFormat('yyyy-MM-dd HH:mm:ss')} -> ${endRange.toFormat('yyyy-MM-dd HH:mm:ss')}`);

            let xmlContent: string;
            const useMock = this.configService.get<string>('USE_MOCK_FISHERY_API') !== 'false';

            if (useMock) {
                this.logger.log('Modo Mock activado: Leyendo archivo local');
                const mockPath = join(process.cwd(), 'old_data', 'zarpadas_y_arribos.asmx');
                xmlContent = readFileSync(mockPath, 'utf-8');
            } else {
                this.logger.log('Modo API Real activado: Consultando servicio web PNA');
                xmlContent = await this.fetchFromApi(startRange.toJSDate(), endRange.toJSDate());
            }

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

                    // 2. Filtrado por rango de fechas
                    const fechaReporteUtc = DateTime.fromFormat(reporte.fecha, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' });
                    const fechaReporteLocal = fechaReporteUtc.setZone(this.TIMEZONE);

                    if (fechaReporteLocal < startRange || fechaReporteLocal > endRange) {
                        this.logger.debug(`Saltando reporte fuera de rango: ${reporte.fecha} (Rango: ${startRange.toISODate()} - ${endRange.toISODate()})`);
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
     * Realiza la llamada SOAP a la API de PNA.
     */
    private async fetchFromApi(desde: Date, hasta: Date): Promise<string> {
        const endpoint = this.configService.get<string>('PNA_API_ENDPOINT');
        const user = this.configService.get<string>('PNA_API_USER');
        const password = this.configService.get<string>('PNA_API_PASSWORD');
        const timeout = parseInt(this.configService.get<string>('PNA_API_TIMEOUT') || '30000', 10);

        if (!endpoint || !user || !password) {
            throw new Error('Configuración incompleta para API PNA (ENDPOINT, USER, PASSWORD)');
        }

        // Formato fechas: yyyy-MM-dd HH:mm:ss
        // Formato fechas: yyyy-MM-dd HH:mm:ss
        const desdeStr = DateTime.fromJSDate(desde).toUTC().toFormat('yyyy-MM-dd HH:mm:ss');
        const hastaStr = DateTime.fromJSDate(hasta).toUTC().toFormat('yyyy-MM-dd HH:mm:ss');

        const envelope = `<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <GetArribosYZarpadas xmlns="http://200.41.238.203/">
      <user>${user}</user>
      <password>${password}</password>
      <desde>${desdeStr}</desde>
      <hasta>${hastaStr}</hasta>
    </GetArribosYZarpadas>
  </soap12:Body>
</soap12:Envelope>`;

        try {
            this.logger.log(`Calling PNA API: ${endpoint} (Range: ${desdeStr} - ${hastaStr})`);
            const response = await axios.post(endpoint, envelope, {
                timeout,
                headers: {
                    'Content-Type': 'application/soap+xml; charset=utf-8',
                },
            });

            return response.data;
        } catch (error) {
            if (axios.isAxiosError(error)) {
                this.logger.error(`Error HTTP ${error.response?.status} calling PNA API: ${error.message}`);
                throw new Error(`Error de comunicación con PNA API: ${error.message}`);
            }
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

        // 1. Evaluar contexto del evento usando el servicio centralizado (Reglas unificadas)
        const allPorts = await this.prisma.puerto.findMany({ where: { activo: true } });
        const decision = await this.correlationService.evaluateEventContext(
            buque.id,
            reporte.estado,
            fechaLocal.toJSDate(),
            puerto?.id,
            reporte.nombre_costera,
            allPorts
        );

        let alertResult: { alertId?: string, created: boolean, validated: boolean } = { created: false, validated: false };

        switch (decision.action) {
            case EventDecisionAction.VALIDATE_ALERT:
                this.logger.log(`Validating existing alert ${decision.existingAlert.id} with PNA API source`);
                await this.alertsService.addValidationSource(
                    decision.existingAlert.id,
                    'API_PNA',
                    {
                        fecha: fechaLocal.toISO(),
                        id_costera: reporte.id_costera,
                        nombre_costera: reporte.nombre_costera,
                        source: 'API_PNA',
                    },
                );
                alertResult = { alertId: decision.existingAlert.id, created: false, validated: true };
                break;

            case EventDecisionAction.DISCREPANCY_PORT:
                const discPort = await this.createDiscrepancyAlert(buque, reporte.estado, puerto || { nombre: reporte.nombre_costera }, fechaLocal, decision.marea, decision.stageMatch, allPorts, reporte);
                alertResult = { alertId: discPort.id, created: true, validated: false };
                break;

            case EventDecisionAction.DISCREPANCY_DATE:
                const discDate = await this.createDateInconsistencyAlert(buque, reporte.estado, puerto || { nombre: reporte.nombre_costera }, fechaLocal, decision.marea, decision.stageMatch, reporte);
                alertResult = { alertId: discDate.id, created: true, validated: false };
                break;

            case EventDecisionAction.RECOMMEND_FIN_MAREA:
                const recFin = await this.createRecommendationFinMarea(buque, puerto || { nombre: reporte.nombre_costera }, fechaLocal, decision.marea, decision.mareaSiguiente, reporte);
                alertResult = { alertId: recFin.id, created: true, validated: false };
                break;

            case EventDecisionAction.CREATE_ALERT:
                alertResult = await this.handleAlert(buque, reporte.estado, fechaLocal, puerto, reporte, decision.marea);
                break;

            case EventDecisionAction.IGNORE_OLD:
                this.logger.debug(`Skipping PNA alert for ${buque.nombreBuque}: Older than registered stages`);
                return { processed: true, alertCreated: false, alertValidated: false };

            case EventDecisionAction.NO_MATCH:
            default:
                this.logger.debug(`Skipping alert for ${buque.nombreBuque}: Event already registered or no matchable tide`);
                return { processed: true, alertCreated: false, alertValidated: false };
        }

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
        const existingAlert = await this.correlationService.findExistingAlert(buque.id, estado, fechaLocal.toJSDate(), marea.id);

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

        const sufijo = estado === 'ARRIBO' ? 'detectado' : 'detectada';
        const titulo = `${buque.nombreBuque}: ${estado} ${sufijo} en ${portName} el ${dateStr} (PNA)`;
        const descripcion = `Se detectó un evento de ${estado.toLowerCase()} informado por Prefectura Naval Argentina.\n\n` +
            `Buque: ${buque.nombreBuque}\n` +
            `Puerto: ${portName}\n` +
            `Fecha: ${fechaLocal.toFormat('dd/MM/yyyy HH:mm')}\n` +
            `Marea: ${mareaLabel}\n\n` +
            `Origen: Reporte oficial API PNA.`;

        const metadata: AlertMetadata = {
            // Metadata Estandarizada
            type: estado,
            subTipo: estado,
            source: 'API_PNA',
            buqueId: buque.id,
            mareaId: marea.id,
            mareaCode: mareaLabel,
            vesselName: buque.nombreBuque,
            observerName: marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'Sin Observador',
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
                detectedAt: fechaLocal.toISO()!,
                data: {
                    id_costera: reporte.id_costera,
                    puerto: portName
                }
            }]
        };

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
            metadata: metadata as any
        });

        return { alertId: newAlert.id, created: true, validated: false };
    }

    private async createDiscrepancyAlert(buque: any, type: 'ZARPADA' | 'ARRIBO', port: any, fechaLocal: DateTime, marea: any, stageMatch: any, allPorts: any[], reporte: PnaReporteCostera) {
        const dateStr = fechaLocal.toFormat('dd/MM HH:mm');
        const yearSuffix = String(marea.anioMarea).slice(-2);
        const mareaLabel = marea.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${marea.nroMarea}-${yearSuffix}`;

        const matchedPortId = type === 'ZARPADA' ? stageMatch.puertoZarpadaId : stageMatch.puertoArriboId;
        const puertoLocal = allPorts.find(p => p.id === matchedPortId)?.nombre || 'N/D';
        const tipoMov = type === 'ZARPADA' ? 'zarpada' : 'arribo';
        const alertTitle = `${buque.nombreBuque}: Discrepancia en puerto de ${tipoMov} el ${dateStr} (PNA)`;

        const metadata: AlertMetadata = {
            mareaId: marea.id,
            mareaCode: mareaLabel,
            vesselName: buque.nombreBuque,
            observerName: marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'Sin Observador',
            portId: port?.id || null,
            portName: port?.nombre,
            eventDate: fechaLocal.toJSDate(),
            type,
            subTipo: 'EDITAR_ETAPA',
            nroEtapa: stageMatch.nroEtapa,
            source: 'API_PNA',
            externalData: {
                id_costera: reporte.id_costera,
                matricula: reporte.matricula,
                [type === 'ZARPADA' ? 'fechaZarpada' : 'fechaArribo']: fechaLocal.toJSDate(),
                [type === 'ZARPADA' ? 'puertoZarpadaId' : 'puertoArriboId']: port?.id || null,
            },
            localData: {
                fecha: type === 'ZARPADA' ? stageMatch.fechaZarpada : stageMatch.fechaArribo,
                puerto: puertoLocal
            },
            sources: [{
                name: 'API_PNA',
                detectedAt: fechaLocal.toISO()!,
                data: { info: 'Discrepancia detectada' }
            }]
        };

        const descripcion = `${alertTitle}\n\nDetectado puerto ${port?.nombre} (PNA) vs registrado ${puertoLocal}.\n\nSe sugiere revisar la etapa para corregir el puerto oficial.`;

        return await this.alertsService.create({
            codigoUnico: `PNA_DISC_PORT_${buque.id}_${fechaLocal.toFormat('yyyyMMdd_HHmm')}`,
            tipo: 'ERROR_REGISTRO_PUERTO',
            titulo: alertTitle,
            descripcion,
            estado: AlertaEstado.PENDIENTE,
            prioridad: AlertaPrioridad.MEDIA,
            fechaDetectada: fechaLocal.toJSDate(),
            referenciaId: marea.id,
            referenciaTipo: 'MAREA',
            metadata: metadata as any
        });
    }

    private async createDateInconsistencyAlert(buque: any, type: 'ZARPADA' | 'ARRIBO', port: any, fechaLocal: DateTime, marea: any, stageMatch: any, reporte: PnaReporteCostera) {
        const registeredDate = type === 'ZARPADA' ? stageMatch.fechaZarpada : stageMatch.fechaArribo;
        const regStr = DateTime.fromJSDate(registeredDate).setZone(this.TIMEZONE).toFormat('dd/MM HH:mm');
        const detStr = fechaLocal.toFormat('dd/MM HH:mm');

        const alertTitle = `${buque.nombreBuque}: Incongruencia de FECHA en ${type.toLowerCase()} (PNA)`;
        const yearSuffix = String(marea.anioMarea).slice(-2);
        const mareaLabel = marea.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${marea.nroMarea}-${yearSuffix}`;

        const metadata: AlertMetadata = {
            mareaId: marea.id,
            mareaCode: mareaLabel,
            vesselName: buque.nombreBuque,
            observerName: marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'Sin Observador',
            portId: port?.id || null,
            portName: port?.nombre,
            type,
            subTipo: 'EDITAR_ETAPA',
            nroEtapa: stageMatch.nroEtapa,
            source: 'API_PNA',
            externalData: { date: fechaLocal.toJSDate(), id_costera: reporte.id_costera },
            localData: { date: registeredDate },
            sources: [{
                name: 'API_PNA',
                detectedAt: fechaLocal.toISO()!,
                data: { info: 'Incongruencia de fecha' }
            }]
        };

        const descripcion = `${alertTitle}\n\nDetectado (PNA): ${detStr}\nRegistrado: ${regStr}\n\nSe recomienda revisar la etapa para corregir la fecha oficial basada en el reporte de PNA.`;

        return await this.alertsService.create({
            codigoUnico: `PNA_DISC_DATE_${buque.id}_${fechaLocal.toFormat('yyyyMMdd_HHmm')}`,
            tipo: 'ERROR_FECHA_MOVIMIENTO',
            titulo: alertTitle,
            descripcion,
            estado: AlertaEstado.PENDIENTE,
            prioridad: AlertaPrioridad.MEDIA,
            fechaDetectada: fechaLocal.toJSDate(),
            referenciaId: marea.id,
            referenciaTipo: 'MAREA',
            metadata: metadata as any
        });
    }

    private async createRecommendationFinMarea(buque: any, port: any, fechaLocal: DateTime, mareaActual: any, mareaSiguiente: any, reporte: PnaReporteCostera) {
        const dateStr = fechaLocal.toFormat('dd/MM HH:mm');
        const alertTitle = `${buque.nombreBuque}: Recomendación FINALIZAR MAREA. Arribo detectado (PNA) el ${dateStr}`;

        const yearSuffix = String(mareaActual.anioMarea).slice(-2);
        const mareaLabel = mareaActual.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${mareaActual.nroMarea}-${yearSuffix}`;
        const lastStage = [...mareaActual.etapas].sort((a, b) => b.nroEtapa - a.nroEtapa)[0];

        const metadata: AlertMetadata = {
            mareaId: mareaActual.id,
            mareaCode: mareaLabel,
            mareaSiguienteId: mareaSiguiente.id,
            vesselName: buque.nombreBuque,
            observerName: mareaActual.observadorPrincipal ? `${mareaActual.observadorPrincipal.nombre} ${mareaActual.observadorPrincipal.apellido}` : 'Sin Observador',
            portId: port?.id || null,
            portName: port?.nombre,
            eventDate: fechaLocal.toJSDate(),
            type: 'ARRIBO',
            subTipo: 'FIN_MAREA',
            nroEtapa: lastStage?.nroEtapa,
            source: 'API_PNA',
            sources: [{
                name: 'API_PNA',
                detectedAt: fechaLocal.toISO()!,
                data: { info: 'Sugerencia de fin de marea' }
            }]
        };

        const descripcion = `${alertTitle}\n\nHay una marea DESIGNADA esperando (${mareaSiguiente.nroMarea}/${mareaSiguiente.anioMarea}). Se sugiere finalizar la marea actual (${mareaLabel}) en lugar de registrar un arribo intermedio.`;

        return await this.alertsService.create({
            codigoUnico: `PNA_REC_FIN_${buque.id}_${fechaLocal.toFormat('yyyyMMdd_HHmm')}`,
            tipo: 'RECOMENDACION_FIN_MAREA',
            titulo: alertTitle,
            descripcion,
            estado: AlertaEstado.PENDIENTE,
            prioridad: AlertaPrioridad.MEDIA,
            fechaDetectada: fechaLocal.toJSDate(),
            referenciaId: mareaActual.id,
            referenciaTipo: 'MAREA',
            metadata: metadata as any
        });
    }

    /**
     * Recupera la fecha de la última sincronización exitosa de system_status
     */
    async getLastSuccessfulSyncDate(): Promise<Date | null> {
        const status = await this.prisma.systemStatus.findUnique({
            where: { key: 'LAST_PNA_SYNC' }
        });
        return status?.value ? new Date(status.value) : null;
    }

    /**
     * Actualiza la fecha de la última sincronización exitosa en system_status
     */
    async updateLastSuccessfulSyncDate(date: Date): Promise<void> {
        await this.prisma.systemStatus.upsert({
            where: { key: 'LAST_PNA_SYNC' },
            create: {
                key: 'LAST_PNA_SYNC',
                value: date.toISOString()
            },
            update: {
                value: date.toISOString()
            }
        });
        this.logger.log(`Actualizado LAST_PNA_SYNC en system_status: ${date.toISOString()}`);
    }
}
