import { Injectable, Logger } from '@nestjs/common';
import { XMLParser } from 'fast-xml-parser';
import { PnaApiResponse, PnaReporteCostera } from './pna-api.interfaces';

@Injectable()
export class PnaApiParser {
    private readonly logger = new Logger(PnaApiParser.name);
    private readonly parser: XMLParser;

    constructor() {
        this.parser = new XMLParser({
            ignoreAttributes: false,
            attributeNamePrefix: '',
            trimValues: true,
        });
    }

    /**
     * Parse XML/SOAP response from PNA API using fast-xml-parser
     */
    async parseXml(xmlContent: string): Promise<PnaApiResponse> {
        try {
            const jsonObj = this.parser.parse(xmlContent);

            // Navigate SOAP structure
            // fast-xml-parser converts namespaces like 'soap:Body' into a standard key if initialized carefully,
            // or keeps them as is. Let's handle common SOAP patterns.
            const envelope = jsonObj['soap:Envelope'] || jsonObj['soap12:Envelope'] || jsonObj['Envelope'];
            const body = envelope?.['soap:Body'] || envelope?.['soap12:Body'] || envelope?.['Body'];
            const response = body?.['GetArribosYZarpadasResponse'];
            const apiResult = response?.['GetArribosYZarpadasResult'];

            if (!apiResult) {
                this.logger.error('Invalid XML structure: GetArribosYZarpadasResult not found');
                throw new Error('GetArribosYZarpadasResult not found in XML');
            }

            // Extract error info
            const errorInfo = apiResult['Error'];
            const error = errorInfo?.error === 'true';
            const mensaje = errorInfo?.mensaje || '';

            // Extract reports
            const reportesCosteras = apiResult['ReportesCosteras'];
            let reportes: PnaReporteCostera[] = [];

            if (reportesCosteras && reportesCosteras['ReporteCostera']) {
                const rawReportes = reportesCosteras['ReporteCostera'];
                // Ensure array
                const reportesArray = Array.isArray(rawReportes) ? rawReportes : [rawReportes];

                reportes = reportesArray.map(r => ({
                    id_costera: String(r.id_costera || ''),
                    nombre_costera: r.nombre_costera || '',
                    id_buque_mbpc: String(r.id_buque_mbpc || ''),
                    matricula: String(r.matricula || ''),
                    sdist: r.sdist || '',
                    nombre: r.nombre || '',
                    latitud: String(r.latitud || ''),
                    longitud: String(r.longitud || ''),
                    estado: r.estado as 'ZARPADA' | 'ARRIBO',
                    fecha: r.fecha || '',
                    fecha_modificacion: r.fecha_modificacion || '',
                    cantidad_tripulantes: String(r.cantidad_tripulantes || ''),
                    observaciones: r.observaciones || '',
                    borrado: String(r.borrado || 'False'),
                }));
            }

            this.logger.log(`Parsed ${reportes.length} reportes from XML`);
            return { reportes, error, mensaje };
        } catch (error) {
            this.logger.error('Error parsing XML with fast-xml-parser:', error);
            throw new Error(`Failed to parse PNA API XML: ${error.message}`);
        }
    }

    /**
     * Generate unique combo ID for deduplication
     */
    generateComboId(reporte: PnaReporteCostera): string {
        return `${reporte.id_costera}_${reporte.id_buque_mbpc}_${reporte.fecha}_${reporte.estado}`;
    }
}
