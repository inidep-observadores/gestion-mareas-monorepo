import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { FisheryClient } from '../../common/fishery-client/interfaces/fishery-client.interface';
import { VesselOfficialData } from '../../common/fishery-client/interfaces/fishery-client-response.interface';

@Injectable()
export class VesselSyncService {
    private readonly logger = new Logger(VesselSyncService.name);
    private readonly SYNC_THRESHOLD_DAYS = 7;

    constructor(
        private readonly prisma: PrismaService,
        private readonly fisheryClient: FisheryClient,
    ) { }

    /**
     * Sincroniza los datos de un buque si ha pasado suficiente tiempo desde la última actualización.
     * La búsqueda se realiza prioritariamente por matrícula, luego por nombre.
     */
    async syncVesselIfNeeded(params: { matricula?: string; nombre?: string }): Promise<void> {
        const { matricula, nombre } = params;

        // 1. Buscar buque localmente
        const localVessel = await this.prisma.buque.findFirst({
            where: {
                OR: [
                    matricula ? { matricula } : undefined,
                    nombre ? { nombreBuque: { contains: nombre, mode: 'insensitive' } } : undefined,
                ].filter(Boolean) as any,
            },
        });

        // 2. Omisión silenciosa si no existe
        if (!localVessel) {
            return;
        }

        // 3. Verificar si necesita actualización
        if (this.isDataFresh(localVessel.fechaUltimaActApi)) {
            return;
        }

        // 4. Obtener datos oficiales (JSON)
        let officialData: VesselOfficialData | null = null;

        if (matricula) {
            officialData = await this.fisheryClient.getVesselByMatricula(matricula);
        }

        if (!officialData && localVessel.idMbpc) {
            officialData = await this.fisheryClient.getVesselDetails(localVessel.idMbpc);
        }

        if (!officialData) {
            return; // Omisión silenciosa
        }

        // 5. Update local record
        await this.updateVessel(localVessel.id, officialData);
        this.logger.log(`Sincronizado buque: ${officialData.nombre} (${officialData.matricula})`);
    }

    private isDataFresh(lastUpdate: Date | null): boolean {
        if (!lastUpdate) return false;
        const diff = (new Date().getTime() - lastUpdate.getTime()) / (1000 * 3600 * 24);
        return diff < this.SYNC_THRESHOLD_DAYS;
    }

    private async updateVessel(id: string, data: VesselOfficialData): Promise<void> {
        await this.prisma.buque.update({
            where: { id },
            data: {
                idMbpc: data.id_mbpc,
                matricula: data.matricula, // Corregir si hubiera discrepancia
                bandera: data.bandera,
                anioConstruccion: data.anio_construccion,
                mmsi: data.mmsi,
                tipoBuque: data.tipo_buque,
                senalDistintiva: data.senal_distintiva,
                velocidad: data.velocidad,
                esloraMbpc: data.eslora_mbpc,
                manga: data.manga,
                puntal: data.puntal,
                arqueoTotal: data.arqueo_total,
                caladoMax: data.calado_max,
                puertoAsiento: data.puerto_asiento,
                arqueoNeto: data.arqueo_neto,
                dotacionMinima: data.dotacion_minima,
                tipo: data.tipo,
                estadoReg: data.estado_reg,
                observaciones: data.observaciones ? data.observaciones : undefined,
                fechaUltimaActApi: new Date(), // Marcamos como actualizado ahora
            },
        });
    }
}
