import { Injectable, Logger, HttpException, HttpStatus } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { FisheryClient } from '../interfaces/fishery-client.interface';
import { VesselOfficialData } from '../interfaces/fishery-client-response.interface';
import { XMLParser } from 'fast-xml-parser';
import axios, { AxiosInstance } from 'axios';

/**
 * Adaptador real para la API SOAP de Prefectura Naval Argentina.
 * Consume el servicio web WsPescaExternos para obtener datos oficiales de buques.
 */
@Injectable()
export class FisheryApiAdapter implements FisheryClient {
    private readonly logger = new Logger(FisheryApiAdapter.name);
    private readonly apiUrl: string;
    private readonly user: string;
    private readonly password: string;
    private readonly timeout: number;
    private readonly httpClient: AxiosInstance;
    private readonly parser: XMLParser;

    constructor(private readonly configService: ConfigService) {
        this.apiUrl = this.configService.get<string>('PNA_API_ENDPOINT');
        this.user = this.configService.get<string>('PNA_API_USER');
        this.password = this.configService.get<string>('PNA_API_PASSWORD');
        this.timeout = parseInt(this.configService.get<string>('PNA_API_TIMEOUT') || '10000', 10);

        if (!this.apiUrl || !this.user || !this.password) {
            throw new Error('PNA_API_ENDPOINT, PNA_API_USER y PNA_API_PASSWORD son requeridos');
        }

        this.httpClient = axios.create({
            timeout: this.timeout,
            headers: {
                'Content-Type': 'application/soap+xml; charset=utf-8',
            },
        });

        this.parser = new XMLParser({
            ignoreAttributes: false,
            attributeNamePrefix: '',
        });

        this.logger.log('FisheryApiAdapter inicializado (API real de PNA)');
    }

    /**
     * Busca un buque por matrícula.
     * Nota: Actualmente no implementado, se usa búsqueda por nombre.
     */
    async getVesselByMatricula(matricula: string): Promise<VesselOfficialData | null> {
        this.logger.warn('Búsqueda por matrícula no implementada, usar getVesselByName');
        return null;
    }

    /**
     * Busca un buque por su ID MBPC.
     */
    async getVesselDetails(idMbpc: string): Promise<VesselOfficialData | null> {
        try {
            const envelope = this.buildSoapEnvelope({ id: idMbpc });
            const xmlResponse = await this.callSoapApi(envelope);
            const vessels = this.parseVesselsFromXml(xmlResponse);

            if (vessels.length === 0) {
                this.logger.debug(`No se encontró buque con ID MBPC: ${idMbpc}`);
                return null;
            }

            return vessels[0];
        } catch (error) {
            this.logger.error(`Error al obtener detalles del buque ${idMbpc}: ${error.message}`);
            throw error;
        }
    }

    /**
     * Busca un buque por nombre.
     * Este es el método principal de búsqueda.
     */
    async getVesselByName(nombre: string): Promise<VesselOfficialData | null> {
        try {
            const envelope = this.buildSoapEnvelope({ nombre });
            const xmlResponse = await this.callSoapApi(envelope);
            const vessels = this.parseVesselsFromXml(xmlResponse);

            if (vessels.length === 0) {
                this.logger.debug(`No se encontró buque con nombre: ${nombre}`);
                return null;
            }

            // Si hay múltiples resultados, tomar el primero
            if (vessels.length > 1) {
                this.logger.warn(`Se encontraron ${vessels.length} buques con nombre similar a "${nombre}". Usando el primero.`);
            }

            return vessels[0];
        } catch (error) {
            this.logger.error(`Error al buscar buque por nombre "${nombre}": ${error.message}`);
            throw error;
        }
    }

    /**
     * Obtiene movimientos recientes.
     * Nota: No implementado en la API SOAP de PNA.
     */
    async getRecentMovements(): Promise<any[]> {
        this.logger.warn('getRecentMovements no implementado en API SOAP de PNA');
        return [];
    }

    /**
     * Obtiene trazas satelitales.
     * Nota: No implementado en la API SOAP de PNA.
     */
    async getSatelliteTracking(): Promise<any[]> {
        this.logger.warn('getSatelliteTracking no implementado en API SOAP de PNA');
        return [];
    }

    /**
     * Construye el envelope SOAP para la petición GetBuques.
     */
    private buildSoapEnvelope(params: { id?: string; nombre?: string; mmsi?: string }): string {
        const { id = '', nombre = '', mmsi = '' } = params;

        // Validar que al menos un parámetro esté presente
        if (!id && !nombre && !mmsi) {
            throw new Error('Se requiere al menos uno de los siguientes parámetros: id, nombre, mmsi');
        }

        return `<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <GetBuques xmlns="http://200.41.238.203/">
      <user>${this.escapeXml(this.user)}</user>
      <password>${this.escapeXml(this.password)}</password>
      <id>${this.escapeXml(id)}</id>
      <nombre>${this.escapeXml(nombre)}</nombre>
      <mmsi>${this.escapeXml(mmsi)}</mmsi>
    </GetBuques>
  </soap12:Body>
</soap12:Envelope>`;
    }

    /**
     * Realiza la llamada SOAP a la API de PNA.
     */
    private async callSoapApi(envelope: string): Promise<string> {
        try {
            const response = await this.httpClient.post(this.apiUrl, envelope);
            return response.data;
        } catch (error) {
            if (axios.isAxiosError(error)) {
                const status = error.response?.status || 500;
                const message = error.response?.data || error.message;
                this.logger.error(`Error HTTP ${status} al llamar a API PNA: ${message}`);
                throw new HttpException(
                    'Error al obtener datos externos de buques',
                    status >= 500 ? HttpStatus.BAD_GATEWAY : HttpStatus.BAD_REQUEST,
                );
            }
            throw error;
        }
    }

    /**
     * Parsea la respuesta XML y extrae los datos de buques.
     * Reutiliza la lógica del mock adapter.
     */
    private parseVesselsFromXml(xmlContent: string): VesselOfficialData[] {
        try {
            const jsonObj = this.parser.parse(xmlContent);

            // Navegar por la estructura SOAP
            const soapBody =
                jsonObj['soap12:Envelope']?.[' soap12:Body'] ||
                jsonObj['soap:Envelope']?.['soap:Body'];

            if (!soapBody) {
                throw new Error('Respuesta SOAP inválida: no se encontró soap:Body');
            }

            const getBuquesResult = soapBody.GetBuquesResponse?.GetBuquesResult;

            if (!getBuquesResult) {
                throw new Error('Respuesta SOAP inválida: no se encontró GetBuquesResult');
            }

            // Verificar errores en la respuesta
            const errorNode = getBuquesResult.Error;
            if (errorNode?.error === 'true') {
                const errorMessage = errorNode.mensaje || 'Error desconocido';
                this.logger.error(`Error en respuesta SOAP: ${errorMessage}`);
                throw new HttpException(
                    `Error al obtener datos externos: ${errorMessage}`,
                    HttpStatus.BAD_REQUEST,
                );
            }

            // Extraer buques
            const barcosMBPC = getBuquesResult.BarcosMBPC;
            if (!barcosMBPC || !barcosMBPC.BarcoMBPC) {
                return [];
            }

            const barcos = barcosMBPC.BarcoMBPC;
            const items = Array.isArray(barcos) ? barcos : [barcos];

            return items.map((item) => ({
                id_mbpc: String(item.id_mbpc),
                matricula: String(item.matricula),
                nro_omi: item.nro_omi,
                nombre: item.nombre,
                bandera: item.bandera,
                anio_construccion: item.anio_construccion ? parseInt(item.anio_construccion) : undefined,
                mmsi: item.mmsi,
                astill_partic: item.astill_partic,
                registro: item.registro,
                tipo_buque: item.tipo_buque,
                senal_distintiva: item.sdist,
                velocidad: item.velocidad ? parseFloat(item.velocidad) : undefined,
                eslora_mbpc: item.eslora_mbpc ? parseFloat(item.eslora_mbpc.replace(',', '.')) : undefined,
                manga: item.manga ? parseFloat(item.manga.replace(',', '.')) : undefined,
                puntal: item.puntal ? parseFloat(item.puntal.replace(',', '.')) : undefined,
                arqueo_total: item.arqueo_total ? parseFloat(item.arqueo_total) : undefined,
                calado_max: item.calado_max ? parseFloat(item.calado_max.replace(',', '.')) : undefined,
                puerto_asiento: item.puerto_asiento,
                material: item.material,
                sociedadclasif: item.sociedadclasif,
                arqueo_neto: item.arqueo_neto ? parseFloat(item.arqueo_neto) : undefined,
                dotacion_minima: item.dotacion_minima ? parseInt(item.dotacion_minima) : undefined,
                tipo: item.tipo,
                estado_reg: item.estado_reg,
            }));
        } catch (error) {
            this.logger.error(`Error al parsear respuesta XML: ${error.message}`);
            throw new HttpException(
                'Error al procesar respuesta de datos externos',
                HttpStatus.INTERNAL_SERVER_ERROR,
            );
        }
    }

    /**
     * Escapa caracteres especiales XML.
     */
    private escapeXml(unsafe: string): string {
        if (!unsafe) return '';
        return unsafe
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&apos;');
    }
}
