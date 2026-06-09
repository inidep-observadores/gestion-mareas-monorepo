import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../prisma/prisma.service';
import { FisheryClient } from '../../common/fishery-client/interfaces/fishery-client.interface';
import { VesselOfficialData } from '../../common/fishery-client/interfaces/fishery-client-response.interface';

@Injectable()
export class VesselSyncService {
    private readonly logger = new Logger(VesselSyncService.name);
    private readonly syncThresholdDays: number;

    constructor(
        private readonly prisma: PrismaService,
        private readonly fisheryClient: FisheryClient,
        private readonly configService: ConfigService,
    ) {
        this.syncThresholdDays = this.configService.get<number>('VESSEL_SYNC_THRESHOLD_DAYS', 7);
    }

    /**
     * Sincroniza los datos de un buque si ha pasado suficiente tiempo desde la última actualización.
     * La búsqueda se realiza por nombre, matrícula o ID MBPC.
     * IMPORTANTE: Este método encola el trabajo en JobQueue en lugar de ejecutarlo síncronamente.
     */
    async syncVesselIfNeeded(params: { nombre?: string; matricula?: string; idMbpc?: string }): Promise<void> {
        const { nombre, matricula, idMbpc } = params;

        // 1. Buscar buque localmente
        const localVessel = await this.prisma.buque.findFirst({
            where: {
                OR: [
                    nombre ? { nombreBuque: { contains: nombre, mode: 'insensitive' } } : undefined,
                    matricula ? { matricula } : undefined,
                    idMbpc ? { idMbpc } : undefined,
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

        // 4. Encolar trabajo de sincronización (no bloqueante)
        await this.syncVessel(localVessel.id);
        this.logger.log(`Trabajo de sincronización encolado para: ${localVessel.nombreBuque} (Matrícula: ${localVessel.matricula || 'N/A'})`);
    }

    async syncVessel(id: string): Promise<void> {
        const buque = await this.prisma.buque.findUnique({
            where: { id },
        });

        if (!buque) return;

        // En lugar de sincronizar aquí, encolamos el trabajo
        await this.prisma.jobQueue.create({
            data: {
                type: 'VESSEL_SYNC',
                payload: {
                    id: buque.id,
                    nombreBuque: buque.nombreBuque,  // IMPORTANTE: necesario para búsqueda por nombre
                    idMbpc: buque.idMbpc,  // Opcional: para búsqueda por ID si está disponible
                    matricula: buque.matricula  // IMPORTANTE: necesario para búsqueda por Matrícula
                },
                priority: 10,
            },
        });

        this.logger.log(`Trabajo encolado para sincronización de buque: ${buque.nombreBuque} (Matrícula: ${buque.matricula || 'N/A'})`);
    }

    /**
     * Ejecuta la sincronización real (llamado por el JobProcessor)
     * Orden de búsqueda: ID MBPC → Matrícula → Nombre
     */
    async executeVesselSync(id: string): Promise<void> {
        const localVessel = await this.prisma.buque.findUnique({ where: { id } });
        if (!localVessel) return;

        let officialData: VesselOfficialData | null = null;

        // 1. Búsqueda por ID MBPC (más preciso)
        if (!officialData && localVessel.idMbpc) {
            this.logger.debug(`Buscando buque por ID MBPC: ${localVessel.idMbpc}`);
            officialData = await this.fisheryClient.getVesselDetails(localVessel.idMbpc);
        }

        // 2. Fallback: búsqueda por Matrícula
        if (!officialData && localVessel.matricula) {
            this.logger.debug(`Buscando buque por Matrícula: ${localVessel.matricula}`);
            officialData = await this.fisheryClient.getVesselByMatricula(localVessel.matricula);
        }

        // 3. Fallback final: búsqueda por nombre
        if (!officialData && localVessel.nombreBuque) {
            this.logger.debug(`Buscando buque por nombre: ${localVessel.nombreBuque}`);
            officialData = await this.fisheryClient.getVesselByName(localVessel.nombreBuque);
        }

        // 4. Actualizar si se encontraron datos
        if (officialData) {
            await this.updateVessel(localVessel.id, officialData);
            this.logger.log(`✓ Sincronización ejecutada para buque: ${officialData.nombre} (ID MBPC: ${officialData.id_mbpc})`);
        } else {
            this.logger.warn(`No se encontraron datos oficiales para: ${localVessel.nombreBuque} (ID: ${localVessel.idMbpc || 'N/A'}, Matrícula: ${localVessel.matricula || 'N/A'})`);
        }
    }

    private isDataFresh(lastUpdate: Date | null): boolean {
        if (!lastUpdate) return false;
        const diff = (new Date().getTime() - lastUpdate.getTime()) / (1000 * 3600 * 24);
        return diff < this.syncThresholdDays;
    }

    private async updateVessel(id: string, data: VesselOfficialData): Promise<void> {
        // Verificar si la matrícula que viene de la API ya existe en otro buque
        if (data.matricula) {
            const existingVessel = await this.prisma.buque.findFirst({
                where: {
                    matricula: data.matricula,
                    NOT: { id }  // Excluir el buque actual
                }
            });

            if (existingVessel) {
                this.logger.warn(
                    `Conflicto de matrícula detectado: "${data.matricula}" ya existe en buque "${existingVessel.nombreBuque}" (ID: ${existingVessel.id}). ` +
                    `No se actualizará la matrícula del buque "${data.nombre}" (ID: ${id}).`
                );
                // Actualizar sin modificar la matrícula
                await this.prisma.buque.update({
                    where: { id },
                    data: {
                        idMbpc: data.id_mbpc,
                        // matricula: OMITIDA por conflicto
                        bandera: data.bandera,
                        anioConstruccion: data.anio_construccion,
                        // mmsi: OMITIDO (no es confiable desde la API externa)
                        tipoBuque: data.tipo_buque,
                        senalDistintiva: data.senal_distintiva,
                        velocidad: data.velocidad,
                        esloraM: data.eslora_mbpc,
                        puntal: data.puntal,
                        arqueoTotal: data.arqueo_total,
                        caladoMax: data.calado_max,
                        puertoAsiento: data.puerto_asiento,
                        arqueoNeto: data.arqueo_neto,
                        dotacionMinima: data.dotacion_minima,
                        tipo: data.tipo,
                        estadoReg: data.estado_reg,
                        observaciones: data.observaciones || undefined,
                        fechaUltimaActApi: new Date(),
                    },
                });
                return;
            }
        }

        // No hay conflicto, actualizar normalmente
        await this.prisma.buque.update({
            where: { id },
            data: {
                idMbpc: data.id_mbpc,
                matricula: data.matricula,
                bandera: data.bandera,
                anioConstruccion: data.anio_construccion,
                // mmsi: OMITIDO (no es confiable desde la API externa)
                tipoBuque: data.tipo_buque,
                senalDistintiva: data.senal_distintiva,
                velocidad: data.velocidad,
                esloraM: data.eslora_mbpc,
                puntal: data.puntal,
                arqueoTotal: data.arqueo_total,
                caladoMax: data.calado_max,
                puertoAsiento: data.puerto_asiento,
                arqueoNeto: data.arqueo_neto,
                dotacionMinima: data.dotacion_minima,
                tipo: data.tipo,
                estadoReg: data.estado_reg,
                observaciones: data.observaciones || undefined,
                fechaUltimaActApi: new Date(),
            },
        });
    }
}
