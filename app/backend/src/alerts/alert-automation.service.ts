import { Injectable, Logger, Inject, forwardRef } from '@nestjs/common';
import { ModuleRef } from '@nestjs/core';
import { PrismaService } from '../prisma/prisma.service';
import { Alerta, User } from '@prisma/client';
import { MareasService } from '../mareas/mareas.service';

@Injectable()
export class AlertAutomationService {
    private readonly logger = new Logger(AlertAutomationService.name);

    constructor(
        private prisma: PrismaService,
        @Inject(forwardRef(() => MareasService))
        private mareasService: MareasService,
    ) { }

    /**
     * Evalúa si una alerta califica para auto-confirmación basado en sus fuentes.
     */
    async processAlertAutomation(alertId: string): Promise<{ status: 'CONFIRMED' | 'SKIPPED' | 'ERROR'; reason?: string }> {
        const alert = await this.prisma.alerta.findUnique({
            where: { id: alertId }
        });

        if (!alert || alert.estado !== 'PENDIENTE') {
            return { status: 'SKIPPED', reason: 'Alerta no encontrada o no está en estado PENDIENTE' };
        }

        // Buscar la marea asociada manualmente ya que no hay relación directa en el esquema
        let marea = null;
        if (alert.referenciaId && alert.referenciaTipo === 'MAREA') {
            marea = await this.prisma.marea.findUnique({
                where: { id: alert.referenciaId },
                include: { estadoActual: true, etapas: { orderBy: { nroEtapa: 'asc' } } }
            });
        }

        if (!marea) {
            return { status: 'SKIPPED', reason: 'No se encontró la marea asociada' };
        }

        const metadata = (alert.metadata as any) || {};
        const sources = metadata.sources || [];

        // Tipos de alerta confiables que permiten fuente única (generados por lógica interna de Tracking/Correlation)
        const trustedSingleSourceTypes = ['RECOMENDACION_FIN_MAREA', 'POSIBLE_ZARPADA', 'POSIBLE_ARRIBO'];
        const isTrustedType = trustedSingleSourceTypes.includes(alert.tipo);

        // Criterio básico: Al menos 2 fuentes distintas o ser un tipo confiable de fuente única
        if (sources.length < 2 && !isTrustedType) {
            return { status: 'SKIPPED', reason: 'Fuentes insuficientes (< 2)' };
        }

        this.logger.log(`Iniciando auto-confirmación para alerta ${alertId} (Tipo: ${alert.tipo})`);

        // Obtener un usuario administrador para registrar el movimiento
        const systemUser = await this.getSystemUser();
        if (!systemUser) {
            this.logger.error('No se encontró un usuario administrador para registrar la acción automática');
            return { status: 'ERROR', reason: 'No se encontró usuario de sistema para ejecutar la acción' };
        }

        try {
            const executed = await this.executeAutoAction(alert, marea, sources, this.mareasService, systemUser);
            if (executed) {
                return { status: 'CONFIRMED', reason: 'Acción ejecutada correctamente' };
            } else {
                return { status: 'SKIPPED', reason: `El estado de la marea (${marea.estadoActual.codigo}) no permite esta acción automática` };
            }
        } catch (error) {
            this.logger.error(`Fallo en auto-confirmación de alerta ${alertId}: ${error.message}`);
            return { status: 'ERROR', reason: `Error al ejecutar acción: ${error.message}` };
        }
    }

    /**
     * Procesa todas las alertas pendientes de zarpada y arribo que cumplan las condiciones.
     */
    async processBatch() {
        const pendingAlerts = await this.prisma.alerta.findMany({
            where: {
                estado: 'PENDIENTE',
                tipo: { in: ['ZARPADA', 'ARRIBO', 'POSIBLE_ZARPADA', 'POSIBLE_ARRIBO', 'RECOMENDACION_FIN_MAREA'] }
            },
            select: { id: true, titulo: true, tipo: true }
        });

        this.logger.log(`Iniciando procesamiento por lote de ${pendingAlerts.length} alertas pendientes`);

        let processed = 0;
        const details: Array<{ id: string; titulo: string; status: 'CONFIRMED' | 'SKIPPED' | 'ERROR'; reason?: string }> = [];

        for (const alert of pendingAlerts) {
            try {
                const result = await this.processAlertAutomation(alert.id);
                if (result.status === 'CONFIRMED') {
                    processed++;
                }
                details.push({
                    id: alert.id,
                    titulo: alert.titulo,
                    status: result.status,
                    reason: result.reason
                });
            } catch (error) {
                this.logger.error(`Error procesando alerta ${alert.id} en lote: ${error.message}`);
                details.push({
                    id: alert.id,
                    titulo: alert.titulo,
                    status: 'ERROR',
                    reason: `Excepción no controlada: ${error.message}`
                });
            }
        }

        return {
            total: pendingAlerts.length,
            processed,
            details
        };
    }

    private async executeAutoAction(alert: Alerta, marea: any, sources: any[], mareasService: MareasService, user: User): Promise<boolean> {
        const { tipo } = alert;

        let actionKey: string | null = null;
        let payload: any = {};

        // Mapeo de tipos de alerta a acciones de MareasService
        // IMPORTANTE: Convertir fechas a ISO string porque MareasService espera strings y usa .includes() para validaciones
        const fechaDetectadaIso = alert.fechaDetectada instanceof Date
            ? alert.fechaDetectada.toISOString()
            : new Date(alert.fechaDetectada).toISOString();

        if (tipo === 'ZARPADA' || tipo === 'POSIBLE_ZARPADA') {
            if (marea.estadoActual.codigo === 'DESIGNADA') {
                actionKey = 'REGISTRAR_INICIO';
                payload = {
                    fechaInicioObservador: fechaDetectadaIso,
                    etapas: [{
                        nroEtapa: 1,
                        puertoZarpadaId: metadataValue(sources, 'portId') || marea.puertoZarpadaId || (alert.metadata as any)?.portId,
                        fechaZarpada: fechaDetectadaIso,
                        pesqueriaId: marea.pesqueriaId,
                        fuentesZarpada: { sources, automatizado: true, eventDate: fechaDetectadaIso }
                    }],
                    comentarios: `Confirmación automática por lógica de negocio (${alert.tipo})`
                };
            } else if (marea.estadoActual.codigo === 'EN_EJECUCION') {
                const stages = marea.etapas || [];
                const lastStage = stages[stages.length - 1];

                // Si la última etapa ya tiene arribo, esta zarpada corresponde a una NUEVA etapa
                if (lastStage && lastStage.fechaArribo) {
                    actionKey = 'EDITAR_ETAPAS';
                    payload = {
                        fechaInicioObservador: marea.fechaInicioObservador,
                        etapas: [
                            ...stages.map((s: any) => ({
                                id: s.id,
                                nroEtapa: s.nroEtapa,
                                puertoZarpadaId: s.puertoZarpadaId,
                                fechaZarpada: s.fechaZarpada,
                                puertoArriboId: s.puertoArriboId,
                                fechaArribo: s.fechaArribo,
                                pesqueriaId: s.pesqueriaId,
                                tipoEtapa: s.tipoEtapa,
                                fuentesZarpada: s.fuentesZarpada,
                                fuentesArribo: s.fuentesArribo,
                                observaciones: s.observaciones
                            })),
                            {
                                nroEtapa: stages.length + 1,
                                puertoZarpadaId: metadataValue(sources, 'portId') || lastStage.puertoArriboId || (alert.metadata as any)?.portId,
                                fechaZarpada: fechaDetectadaIso,
                                pesqueriaId: lastStage.pesqueriaId || marea.pesqueriaId,
                                fuentesZarpada: { sources, automatizado: true, eventDate: fechaDetectadaIso }
                            }
                        ],
                        comentarios: `Nueva etapa detectada automáticamente por lógica de negocio (${alert.tipo})`
                    };
                }
            }
        } else if (tipo === 'ARRIBO' || tipo === 'POSIBLE_ARRIBO' || tipo === 'RECOMENDACION_FIN_MAREA') {
            if (marea.estadoActual.codigo === 'EN_EJECUCION') {
                // REGLA: Si es una RECOMENDACIÓN de fin de marea (hay otra esperando), finalizamos la marea.
                // Si es un ARRIBO normal, solo cerramos la etapa mediante EDITAR_ETAPAS (mantiene estado EN_EJECUCION).
                actionKey = tipo === 'RECOMENDACION_FIN_MAREA' ? 'REGISTRAR_FINALIZACION' : 'EDITAR_ETAPAS';

                payload = {
                    ...(actionKey === 'REGISTRAR_FINALIZACION'
                        ? { fechaFinObservador: fechaDetectadaIso }
                        : { fechaInicioObservador: marea.fechaInicioObservador }),
                    etapas: (marea.etapas || []).map((e: any, index: number, arr: any[]) => {
                        if (index === arr.length - 1) {
                            return {
                                ...e,
                                puertoArriboId: metadataValue(sources, 'portId') || (alert.metadata as any)?.portId || e.puertoArriboId,
                                fechaArribo: fechaDetectadaIso,
                                fuentesArribo: { sources, automatizado: true, eventDate: fechaDetectadaIso }
                            };
                        }
                        return e;
                    }),
                    comentarios: `Confirmación automática por lógica de negocio (${alert.tipo})`
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
                    fechaCierre: new Date(),
                    metadata: {
                        ...(alert.metadata as any || {}),
                        isAuto: true
                    }
                }
            });

            // Registrar evento de auditoría
            await this.prisma.alertaEvento.create({
                data: {
                    alertaId: alert.id,
                    tipoEvento: 'AUTO_RESOLUCION',
                    detalle: `Alerta resuelta automáticamente por sistema tras ejecutar acción: ${actionKey}`,
                    usuarioId: user.id // Usuario de sistema
                }
            });

            this.logger.log(`Alerta ${alert.id} resuelta automáticamente`);
            return true;
        }

        return false;
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
