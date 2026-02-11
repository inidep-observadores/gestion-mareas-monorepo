import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { TrackingService, VesselTrackingBatch } from '../mareas/tracking.service';
import { JobQueueService } from '../jobs/job-queue.service';
import { PnaTrackingParser } from './pna-tracking.parser';
import { DateTime } from 'luxon';
import { readFileSync } from 'fs';
import { join } from 'path';
import axios from 'axios';

@Injectable()
export class PnaTrackingService {
    private readonly logger = new Logger(PnaTrackingService.name);
    private readonly TIMEZONE = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';

    constructor(
        private prisma: PrismaService,
        private trackingService: TrackingService,
        private parser: PnaTrackingParser,
        private configService: ConfigService,
        private jobQueueService: JobQueueService,
    ) { }

    /**
     * Orquestador que decide el rango y encola las tareas fragmentadas.
     */
    async scheduleSynchronization() {
        try {
            const lastSync = await this.getLastSuccessfulSyncDate();
            const now = DateTime.now().toUTC();

            // Rango "desde": LAST_PNA_TRACKING_SYNC o últimas 8 horas UTC
            let fromDate = lastSync
                ? DateTime.fromJSDate(lastSync).toUTC()
                : now.minus({ hours: 8 });

            const toDate = now;

            if (fromDate >= toDate) {
                this.logger.log('Sincronización ya está al día.');
                return { success: true, queuedJobs: 0 };
            }

            const maxBlockHours = 3;
            const rateLimitMs = parseInt(this.configService.get<string>('TRACKING_SYNC_RATE_LIMIT_MS') || '10000', 10);

            let currentFrom = fromDate;
            let delayCounter = 0;
            let queuedJobs = 0;

            this.logger.log(`Programando sincronización de Tracking PNA desde ${fromDate.toISO()} hasta ${toDate.toISO()}`);

            while (currentFrom < toDate) {
                let nextTo = currentFrom.plus({ hours: maxBlockHours });
                if (nextTo > toDate) nextTo = toDate;

                const payload = {
                    fromDate: currentFrom.toJSDate().toISOString(),
                    toDate: nextTo.toJSDate().toISOString(),
                    // El último fragmento marcará la fecha de éxito definitiva
                    isLastBlock: nextTo >= toDate
                };

                const nextRunAt = new Date(Date.now() + (delayCounter * rateLimitMs));

                await this.jobQueueService.addJob(
                    'PNA_TRACKING_SYNC' as any,
                    payload,
                    20,
                    nextRunAt
                );

                currentFrom = nextTo;
                delayCounter++;
                queuedJobs++;
            }

            this.logger.log(`Se han encolado ${queuedJobs} tareas de sincronización de tracking.`);
            return { success: true, queuedJobs };
        } catch (error) {
            this.logger.error('Error al programar sincronización de tracking:', error);
            throw error;
        }
    }

    /**
     * Sincroniza posiciones históricas desde PNA para un rango específico.
     */
    async syncTrackingData(fromDate: Date, toDate: Date) {
        try {
            const startRange = DateTime.fromJSDate(fromDate).toUTC();
            const endRange = DateTime.fromJSDate(toDate).toUTC();

            this.logger.log(`Ejecutando fragmento de Tracking PNA: ${startRange.toISO()} -> ${endRange.toISO()}`);

            let xmlContent: string;
            const useMock = this.configService.get<string>('USE_MOCK_FISHERY_API') !== 'false';

            if (useMock) {
                const mockPath = join(process.cwd(), 'old_data', 'historico_posiciones.asmx');
                xmlContent = readFileSync(mockPath, 'utf-8');
            } else {
                xmlContent = await this.fetchFromApi(startRange.toJSDate(), endRange.toJSDate());
            }

            const apiResponse = await this.parser.parseXml(xmlContent);

            if (apiResponse.error) {
                this.logger.error(`PNA Tracking API returnó error: ${apiResponse.mensaje}`);
                return { success: false, error: apiResponse.mensaje };
            }

            const reportes = apiResponse.reportes;
            if (reportes.length === 0) {
                this.logger.log('No se encontraron nuevos puntos de tracking en el rango.');
                return { success: true, processed: 0 };
            }

            // Agrupar por buque (usando el nombre como clave primaria de Batch por compatibilidad con processVesselBatch)
            const groups = new Map<string, any[]>();
            for (const r of reportes) {
                if (!groups.has(r.nombre)) groups.set(r.nombre, []);
                groups.get(r.nombre)!.push(r);
            }

            let totalInserted = 0;
            let totalAlerts = 0;

            for (const [vesselName, points] of groups.entries()) {
                const batch: VesselTrackingBatch = {
                    vesselInfo: {
                        nombre: vesselName,
                        matricula: points[0].matricula,
                        mmsi: points[0].mmsi
                    },
                    points: points.map(p => ({
                        timestamp: DateTime.fromFormat(p.fecha, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' }).isValid ? DateTime.fromFormat(p.fecha, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' }).toJSDate() : DateTime.fromISO(p.fecha, { zone: 'utc' }).toJSDate(),
                        lat: parseFloat(p.latitud),
                        lon: parseFloat(p.longitud),
                        velocidad: parseFloat(p.velocidad),
                        rumbo: parseInt(p.rumbo, 10)
                    }))
                };

                const result = await this.trackingService.processVesselBatch(batch);
                totalInserted += result.inserted;
                totalAlerts += result.alerts;
            }

            // Actualizar fecha de última sincronización al máximo timestamp encontrado
            const maxTimestamp = reportes.reduce((max, r) => {
                const dt = DateTime.fromFormat(r.fecha, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' });
                return dt > max ? dt : max;
            }, startRange);

            await this.updateLastSuccessfulSyncDate(maxTimestamp.toJSDate());
            await this.trackingService.updateLastTrackingStatus();

            this.logger.log(`Sincronización finalizada: ${totalInserted} puntos insertados, ${totalAlerts} alertas/eventos detectados.`);
            return { success: true, inserted: totalInserted, alerts: totalAlerts };

        } catch (error) {
            this.logger.error('Error en syncTrackingData:', error);
            throw error;
        }
    }

    private async fetchFromApi(desde: Date, hasta: Date): Promise<string> {
        const endpoint = this.configService.get<string>('PNA_API_ENDPOINT');
        const user = this.configService.get<string>('PNA_API_USER');
        const password = this.configService.get<string>('PNA_API_PASSWORD');
        const timeout = parseInt(this.configService.get<string>('PNA_API_TIMEOUT') || '60000', 10);

        const desdeStr = DateTime.fromJSDate(desde).toUTC().toFormat('yyyy-MM-dd HH:mm:ss');
        const hastaStr = DateTime.fromJSDate(hasta).toUTC().toFormat('yyyy-MM-dd HH:mm:ss');

        const envelope = `<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <GetPosicionesHistoricas xmlns="http://200.41.238.203/">
      <user>${user}</user>
      <password>${password}</password>
      <desde>${desdeStr}</desde>
      <hasta>${hastaStr}</hasta>
    </GetPosicionesHistoricas>
  </soap12:Body>
</soap12:Envelope>`;

        const response = await axios.post(endpoint!, envelope, {
            timeout,
            headers: { 'Content-Type': 'application/soap+xml; charset=utf-8' },
        });

        return response.data;
    }

    private async getLastSuccessfulSyncDate(): Promise<Date | null> {
        const status = await this.prisma.systemStatus.findUnique({
            where: { key: 'LAST_PNA_TRACKING_SYNC' }
        });
        return status?.value ? new Date(status.value) : null;
    }

    private async updateLastSuccessfulSyncDate(date: Date): Promise<void> {
        const current = await this.getLastSuccessfulSyncDate();
        if (current && date <= current) return;

        await this.prisma.systemStatus.upsert({
            where: { key: 'LAST_PNA_TRACKING_SYNC' },
            create: { key: 'LAST_PNA_TRACKING_SYNC', value: date.toISOString() },
            update: { value: date.toISOString() }
        });
    }
}
