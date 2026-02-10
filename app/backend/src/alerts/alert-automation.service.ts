import { Injectable, Logger } from '@nestjs/common';
import { ModuleRef } from '@nestjs/core';
import { PrismaService } from '../prisma/prisma.service';
import { Alerta, User } from '@prisma/client';

@Injectable()
export class AlertAutomationService {
    private readonly logger = new Logger(AlertAutomationService.name);

    constructor(
        private prisma: PrismaService,
        private moduleRef: ModuleRef,
    ) { }

    /**
     * Evalúa si una alerta califica para auto-confirmación basado en sus fuentes.
     */
    async processAlertAutomation(alertId: string) {
        const alert = await this.prisma.alerta.findUnique({
            where: { id: alertId }
        });

        if (!alert || alert.estado !== 'PENDIENTE') return;

        // Buscar la marea asociada manualmente ya que no hay relación directa en el esquema
        let marea = null;
        if (alert.referenciaId && alert.referenciaTipo === 'MAREA') {
            marea = await this.prisma.marea.findUnique({
                where: { id: alert.referenciaId },
                include: { estadoActual: true, etapas: { orderBy: { nroEtapa: 'asc' } } }
            });
        }

        if (!marea) return;

        const metadata = (alert.metadata as any) || {};
        const sources = metadata.sources || [];

        // Criterio básico: Al menos 2 fuentes distintas (ej. PNA + Tracking)
        if (sources.length < 2) {
            return;
        }

        this.logger.log(`Iniciando auto-confirmación para alerta ${alertId} (Tipo: ${alert.tipo})`);

        // Obtener MareasService de forma perezosa para evitar dependencias circulares
        const mareasService = this.moduleRef.get('MareasService', { strict: false });
        if (!mareasService) {
            this.logger.error('No se pudo obtener MareasService para la automatización');
            return;
        }

        // Obtener un usuario administrador para registrar el movimiento
        const systemUser = await this.getSystemUser();
        if (!systemUser) {
            this.logger.error('No se encontró un usuario administrador para registrar la acción automática');
            return;
        }

        try {
            await this.executeAutoAction(alert, marea, sources, mareasService, systemUser);
        } catch (error) {
            this.logger.error(`Fallo en auto-confirmación de alerta ${alertId}: ${error.message}`);
        }
    }

    private async executeAutoAction(alert: Alerta, marea: any, sources: any[], mareasService: any, user: User) {
        const { tipo } = alert;

        let actionKey: string | null = null;
        let payload: any = {};

        // Mapeo de tipos de alerta a acciones de MareasService
        if (tipo === 'ZARPADA') {
            if (marea.estadoActual.codigo === 'DESIGNADA') {
                actionKey = 'REGISTRAR_INICIO';
                payload = {
                    fechaInicioObservador: alert.fechaDetectada, // Usar fecha detectada por el sistema
                    etapas: [{
                        nroEtapa: 1,
                        puertoZarpadaId: metadataValue(sources, 'portId') || marea.puertoZarpadaId,
                        fechaZarpada: alert.fechaDetectada,
                        pesqueriaId: marea.pesqueriaId,
                        fuentesZarpada: { sources, automatizado: true }
                    }],
                    comentarios: 'Confirmación automática por doble validación (PNA + Tracking)'
                };
            }
        } else if (tipo === 'ARRIBO') {
            if (marea.estadoActual.codigo === 'EN_EJECUCION') {
                actionKey = 'REGISTRAR_FINALIZACION';
                payload = {
                    fechaFinObservador: alert.fechaDetectada,
                    etapas: (marea.etapas || []).map((e: any, index: number, arr: any[]) => {
                        if (index === arr.length - 1) {
                            return {
                                ...e,
                                puertoArriboId: metadataValue(sources, 'portId') || e.puertoArriboId,
                                fechaArribo: alert.fechaDetectada,
                                fuentesArribo: { sources, automatizado: true }
                            };
                        }
                        return e;
                    }),
                    comentarios: 'Confirmación automática por doble validación (PNA + Tracking)'
                };
            }
        }

        if (actionKey) {
            this.logger.log(`Ejecutando acción automática ${actionKey} para marea ${marea.id}`);

            // Ejecutar la acción
            await mareasService.executeAction(marea.id, actionKey, user, payload);

            // Resolver la alerta
            await this.prisma.alerta.update({
                where: { id: alert.id },
                data: {
                    estado: 'RESUELTA',
                    fechaCierre: new Date()
                }
            });

            this.logger.log(`Alerta ${alert.id} resuelta automáticamente`);
        }
    }

    private async getSystemUser(): Promise<User | null> {
        return this.prisma.user.findFirst({
            where: { roles: { has: 'admin' } }
        });
    }
}

function metadataValue(sources: any[], key: string): any {
    for (const s of sources) {
        if (s.data && s.data[key]) return s.data[key];
    }
    return null;
}
