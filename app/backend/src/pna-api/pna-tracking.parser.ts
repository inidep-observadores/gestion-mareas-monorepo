import { Injectable, Logger } from '@nestjs/common';
import { XMLParser } from 'fast-xml-parser';
import { PnaTrackingResponse, PnaTrackingReporte } from './pna-api.interfaces';

@Injectable()
export class PnaTrackingParser {
    private readonly logger = new Logger(PnaTrackingParser.name);
    private readonly parser: XMLParser;

    constructor() {
        this.parser = new XMLParser({
            ignoreAttributes: false,
            attributeNamePrefix: '',
            trimValues: true,
        });
    }

    /**
     * Parse XML/SOAP response from PNA Posiciones Historicas using fast-xml-parser
     */
    async parseXml(xmlContent: string): Promise<PnaTrackingResponse> {
        try {
            const jsonObj = this.parser.parse(xmlContent);

            const envelope = jsonObj['soap:Envelope'] || jsonObj['soap12:Envelope'] || jsonObj['Envelope'];
            const body = envelope?.['soap:Body'] || envelope?.['Body'];
            const response = body?.['GetPosicionesHistoricasResponse'];
            const apiResult = response?.['GetPosicionesHistoricasResult'];

            if (!apiResult) {
                this.logger.error('Invalid XML structure: GetPosicionesHistoricasResult not found');
                throw new Error('GetPosicionesHistoricasResult not found in XML');
            }

            // Extract error info
            const errorInfo = apiResult['Error'];
            const error = errorInfo?.error === 'true';
            const mensaje = errorInfo?.mensaje || '';

            // Extract reports
            const reportesNode = apiResult['Reportes'];
            let reportes: PnaTrackingReporte[] = [];

            if (reportesNode && reportesNode['Reporte']) {
                const rawReportes = reportesNode['Reporte'];
                const reportesArray = Array.isArray(rawReportes) ? rawReportes : [rawReportes];

                reportes = reportesArray.map(r => ({
                    matricula: String(r.matricula || ''),
                    mmsi: String(r.mmsi || ''),
                    nombre: String(r.nombre || ''),
                    latitud: String(r.latitud || ''),
                    longitud: String(r.longitud || ''),
                    fecha: String(r.fecha || ''),
                    rumbo: String(r.rumbo || '0'),
                    velocidad: String(r.velocidad || '0'),
                    eslora: String(r.eslora || ''),
                }));
            }

            this.logger.log(`Parsed ${reportes.length} tracking reportes from XML`);
            return { reportes, error, mensaje };
        } catch (error) {
            this.logger.error('Error parsing Tracking XML with fast-xml-parser:', error);
            throw new Error(`Failed to parse PNA Tracking XML: ${error.message}`);
        }
    }
}
