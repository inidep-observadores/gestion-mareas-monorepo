import { Injectable, Logger } from '@nestjs/common';
import { FisheryClient, TimeWindow } from '../interfaces/fishery-client.interface';
import { VesselOfficialData, OfficialMovement, SatellitePosition } from '../interfaces/fishery-client-response.interface';
import * as fs from 'fs';
import * as path from 'path';
import { XMLParser } from 'fast-xml-parser';

@Injectable()
export class FisheryMockAdapter extends FisheryClient {
    private readonly logger = new Logger(FisheryMockAdapter.name);
    private readonly parser = new XMLParser({
        ignoreAttributes: false,
        attributeNamePrefix: '',
    });

    private readonly dataPath = path.join(process.cwd(), 'old_data');

    async getVesselDetails(idMbpc: string): Promise<VesselOfficialData | null> {
        this.logger.log(`[Mock] Buscando detalles para buque id_mbpc: ${idMbpc}`);
        const vessels = await this.loadVesselsFromXml();
        return vessels.find(v => v.id_mbpc === idMbpc) || null;
    }

    async getVesselByName(nombre: string): Promise<VesselOfficialData | null> {
        const vessels = await this.loadVesselsFromXml();
        const normalizedSearch = nombre.toLowerCase().trim();
        return vessels.find((v) => v.nombre.toLowerCase().includes(normalizedSearch)) || null;
    }

    async getVesselByMmsi(mmsi: string): Promise<VesselOfficialData | null> {
        const vessels = await this.loadVesselsFromXml();
        return vessels.find((v) => v.mmsi === mmsi) || null;
    }

    async getVesselByMatricula(matricula: string): Promise<VesselOfficialData | null> {
        this.logger.log(`[Mock] Buscando detalles para buque matrícula: ${matricula}`);
        const vessels = await this.loadVesselsFromXml();
        // Normalizar matrículas para el match
        return vessels.find(v => this.normalizeMatricula(v.matricula) === this.normalizeMatricula(matricula)) || null;
    }

    async getRecentMovements(since: Date, idMbpc?: string): Promise<OfficialMovement[]> {
        this.logger.log(`[Mock] Buscando movimientos desde ${since.toISOString()}`);
        const movements = await this.loadMovementsFromXml();

        return movements.filter(m => {
            const dateMatch = new Date(m.fecha) >= since;
            const vesselMatch = idMbpc ? m.id_buque_mbpc === idMbpc : true;
            return dateMatch && vesselMatch;
        });
    }

    async getSatelliteTracking(idMbpc: string, window: TimeWindow): Promise<SatellitePosition[]> {
        this.logger.log(`[Mock] Buscando posiciones para ${idMbpc} entre ${window.start.toISOString()} y ${window.end.toISOString()}`);
        // Implementación simplificada para el mock: podría leer historico_posiciones.asmx
        return [];
    }

    // Helpers privados

    private async loadVesselsFromXml(): Promise<VesselOfficialData[]> {
        try {
            const filePath = path.join(this.dataPath, 'maestros_buques.asmx');
            const xmlContent = fs.readFileSync(filePath, 'utf-8');
            const jsonObj = this.parser.parse(xmlContent);

            const barcos = jsonObj['soap:Envelope']['soap:Body'].GetBuquesResponse.GetBuquesResult.BarcosMBPC.BarcoMBPC;
            const items = Array.isArray(barcos) ? barcos : [barcos];

            return items.map(item => ({
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
                fecha_mod: item.fecha_mod ? new Date(item.fecha_mod) : undefined,
                estado_reg: item.estado_reg,
                observaciones: item.observaciones,
            }));
        } catch (error) {
            this.logger.error(`Error cargando buques del mock: ${error.message}`);
            return [];
        }
    }

    private async loadMovementsFromXml(): Promise<OfficialMovement[]> {
        try {
            const filePath = path.join(this.dataPath, 'zarpadas_y_arribos.asmx');
            const xmlContent = fs.readFileSync(filePath, 'utf-8');
            const jsonObj = this.parser.parse(xmlContent);

            const reportes = jsonObj['soap:Envelope']['soap:Body'].GetArribosYZarpadasV2Response.GetArribosYZarpadasV2Result.ReportesCosteras.ReporteCostera;
            const items = Array.isArray(reportes) ? reportes : [reportes];

            return items.map(item => ({
                id_buque_mbpc: String(item.id_buque_mbpc),
                matricula: String(item.matricula),
                nombre_buque: item.nombre,
                estado: item.estado,
                fecha: new Date(item.fecha),
                puerto_nombre: item.nombre_costera,
                id_costera: item.id_costera,
                latitud: item.latitud ? parseFloat(item.latitud) : undefined,
                longitud: item.longitud ? parseFloat(item.longitud) : undefined,
                cantidad_tripulantes: item.cantidad_tripulantes ? parseInt(item.cantidad_tripulantes) : undefined,
                observaciones: item.observaciones,
            }));
        } catch (error) {
            this.logger.error(`Error cargando movimientos del mock: ${error.message}`);
            return [];
        }
    }

    private normalizeMatricula(m: string): string {
        return m.replace(/^0+/, '').trim();
    }
}
