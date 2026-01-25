import { PrismaService } from '../prisma/prisma.service';
import { AlertsService } from '../alerts/alerts.service';
import { AccessReaderService, ExternalRecord } from './access-reader.service';
import { ErrorLogsService } from '../common/error-logs/error-logs.service';
export interface ProcessingSummary {
    total: number;
    nuevos: number;
    actualizados: number;
    sinCambios: number;
    alertasGeneradas: number;
}
export declare class AccessImportService {
    private prisma;
    private alertsService;
    private readerService;
    private errorLogsService;
    private readonly logger;
    constructor(prisma: PrismaService, alertsService: AlertsService, readerService: AccessReaderService, errorLogsService: ErrorLogsService);
    processFile(buffer: Buffer): Promise<ProcessingSummary>;
    processRecords(records: ExternalRecord[]): Promise<ProcessingSummary>;
    private processSingleRecord;
    private parseMareaIdentifier;
    private findLocalEntities;
    private datesMatch;
    private toLocalDateString;
    private createAlertFromHallazgo;
}
