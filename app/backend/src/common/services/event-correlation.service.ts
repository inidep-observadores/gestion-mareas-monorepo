import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { DateTime } from 'luxon';
import { AlertaEstado } from '../../alerts/alerts.enums';

export enum EventDecisionAction {
    CREATE_ALERT = 'CREATE_ALERT',
    VALIDATE_ALERT = 'VALIDATE_ALERT',
    RECOMMEND_FIN_MAREA = 'RECOMMEND_FIN_MAREA',
    IGNORE_OLD = 'IGNORE_OLD',
    DISCREPANCY_PORT = 'DISCREPANCY_PORT',
    DISCREPANCY_DATE = 'DISCREPANCY_DATE',
    NO_MATCH = 'NO_MATCH'
}

export interface EventDecision {
    action: EventDecisionAction;
    marea: any;
    mareaSiguiente?: any;
    existingAlert?: any;
    stageMatch?: any;
    nroEtapa?: number;
}

@Injectable()
export class EventCorrelationService {
    private readonly logger = new Logger(EventCorrelationService.name);
    private readonly TIMEZONE = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';
    private readonly ALERT_WINDOW_HOURS = 24;

    constructor(private prisma: PrismaService) { }

    /**
     * Evalúa el contexto de un evento (ZARPADA o ARRIBO) para decidir la acción a tomar.
     * Centraliza las reglas de cronología, secuencialidad y recomendaciones de fin de marea.
     */
    async evaluateEventContext(buqueId: string, type: 'ZARPADA' | 'ARRIBO', date: Date, portId?: string, portName?: string, allPorts: any[] = []): Promise<EventDecision> {
        const TIMEZONE = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';
        const eventDate = DateTime.fromJSDate(date).setZone(TIMEZONE);

        // 1. Encontrar las mareas potenciales (DESIGNADA o EN_EJECUCION)
        const mareas = await this.prisma.marea.findMany({
            where: {
                buqueId,
                estadoActual: { codigo: { in: ['DESIGNADA', 'EN_EJECUCION'] } }
            },
            include: {
                estadoActual: true,
                etapas: { orderBy: { nroEtapa: 'asc' } },
                buque: true,
                observadorPrincipal: true
            }
        });

        if (mareas.length === 0) return { action: EventDecisionAction.NO_MATCH, marea: null };

        const mareaDesignada = mareas.find(m => m.estadoActual.codigo === 'DESIGNADA');
        const mareaEnEjecucion = mareas.find(m => m.estadoActual.codigo === 'EN_EJECUCION');

        // REGLA: Para ZARPADA, priorizamos DESIGNADA (la más reciente/por empezar)
        // Para ARRIBO, priorizamos EN_EJECUCION (la actual)
        let mareaMatch = type === 'ZARPADA'
            ? (mareaDesignada || mareaEnEjecucion)
            : (mareaEnEjecucion || mareaDesignada);

        if (!mareaMatch) return { action: EventDecisionAction.NO_MATCH, marea: null };

        // 2. Deduplicación funcional: ¿Ya existe una alerta (PNA, Tracking u otro)?
        // REGLA: Si tenemos una marea candidata, la deduplicación debe ser ESTRICTA para esa marea.
        // Esto evita que alertas de mareas anteriores bloqueen las alertas de la marea nueva.
        const existingAlert = await this.findExistingAlert(buqueId, type, date, mareaMatch.id);

        // 3. Caso Deduplicación: Si ya existe alerta, indicamos VALIDAR (Source Stacking)
        if (existingAlert) {
            return { action: EventDecisionAction.VALIDATE_ALERT, marea: mareaMatch, existingAlert };
        }

        // 4. Caso Etapa Registrada: ¿Coincide con una etapa ya registrada? (Match por ventana temporal)
        const stageMatch = this.findMatchingStage(mareaMatch, type, date, portId, portName);
        if (stageMatch) {
            const matchedPortId = type === 'ZARPADA' ? stageMatch.puertoZarpadaId : stageMatch.puertoArriboId;
            const registeredDate = type === 'ZARPADA' ? stageMatch.fechaZarpada : stageMatch.fechaArribo;

            // VALIDACIÓN DE PUERTO: Solo si se provee información de puerto para comparar
            if (portId || portName) {
                let portIsSame = false;
                if (portId && matchedPortId) {
                    portIsSame = matchedPortId === portId;
                } else if (portName) {
                    const registeredPortName = allPorts.find(p => p.id === matchedPortId)?.nombre;
                    portIsSame = registeredPortName && registeredPortName.toLowerCase() === portName.toLowerCase();
                }

                if (!portIsSame && (portId || portName)) {
                    return { action: EventDecisionAction.DISCREPANCY_PORT, marea: mareaMatch, stageMatch };
                }
            }

            // VALIDACIÓN DE FECHA: Mismo día local
            const registeredLocalKey = DateTime.fromJSDate(registeredDate!).setZone(TIMEZONE).toFormat('yyyy-MM-dd');
            const eventLocalKey = eventDate.toFormat('yyyy-MM-dd');

            if (registeredLocalKey !== eventLocalKey) {
                // Si el día es distinto, es una discrepancia de fecha importante
                return { action: EventDecisionAction.DISCREPANCY_DATE, marea: mareaMatch, stageMatch };
            }

            // REGLA DE COHERENCIA: Si el día es el mismo pero el evento es posterior al ya registrado,
            // lo ignoramos (ya tenemos un registro igual de válido o más reciente del mismo día).
            if (registeredDate && new Date(date) >= new Date(registeredDate)) {
                return { action: EventDecisionAction.IGNORE_OLD, marea: mareaMatch };
            }

            return { action: EventDecisionAction.NO_MATCH, marea: mareaMatch, stageMatch };
        }

        // 5. Aplicar Reglas de Negocio Específicas
        if (type === 'ZARPADA') {
            // COHERENCIA CRONOLÓGICA: Ignorar si la zarpada es anterior a etapas ya registradas
            const hasPosteriorStage = mareaMatch.etapas.some(e => e.fechaZarpada && new Date(e.fechaZarpada) > date);
            if (hasPosteriorStage) {
                return { action: EventDecisionAction.IGNORE_OLD, marea: mareaMatch };
            }

            return { action: EventDecisionAction.CREATE_ALERT, marea: mareaMatch };
        } else {
            // ARRIBO
            // REGLA: Si no hay marea EN_EJECUCION, ignoramos los arribos (aunque haya una DESIGNADA)
            if (!mareaEnEjecucion) {
                this.logger.debug(`Ignorando ARRIBO para buque ${buqueId}: Solo existe marea DESIGNADA o ninguna.`);
                return { action: EventDecisionAction.NO_MATCH, marea: mareaDesignada || null };
            }

            if (mareaEnEjecucion) {
                // REGLA ESPECIAL: Si hay una marea DESIGNADA esperando, sugerir FINALIZAR marea
                if (mareaDesignada) {
                    return {
                        action: EventDecisionAction.RECOMMEND_FIN_MAREA,
                        marea: mareaEnEjecucion,
                        mareaSiguiente: mareaDesignada
                    };
                }

                // COHERENCIA CRONOLÓGICA: Ignorar si el arribo es anterior a cualquier etapa ya cerrada o zarpadas posteriores
                const hasConflictiveStage = mareaEnEjecucion.etapas.some(e => {
                    const fZarpada = e.fechaZarpada ? new Date(e.fechaZarpada) : null;
                    const fArribo = e.fechaArribo ? new Date(e.fechaArribo) : null;
                    // Es anterior a una zarpada o un arribo ya registrado
                    return (fZarpada && fZarpada > date) || (fArribo && fArribo > date);
                });

                if (hasConflictiveStage) {
                    return { action: EventDecisionAction.IGNORE_OLD, marea: mareaEnEjecucion };
                }

                const lastStageOpen = [...mareaEnEjecucion.etapas].sort((a, b) => b.nroEtapa - a.nroEtapa).find(e => !e.fechaArribo);

                // REGLA DE ARRIBO: Debe existir una etapa abierta
                if (!lastStageOpen) {
                    this.logger.debug(`Ignorando ARRIBO para buque ${buqueId}: No hay etapa abierta en marea ${mareaEnEjecucion.id}`);
                    return { action: EventDecisionAction.IGNORE_OLD, marea: mareaEnEjecucion };
                }

                // SECUENCIALIDAD: El arribo debe ser posterior a la zarpada registrada de la etapa abierta
                if (lastStageOpen.fechaZarpada && new Date(date) < new Date(lastStageOpen.fechaZarpada)) {
                    this.logger.debug(`Ignorando ARRIBO para buque ${buqueId}: Fecha de arribo anterior a la zarpada de la etapa`);
                    return { action: EventDecisionAction.IGNORE_OLD, marea: mareaEnEjecucion };
                }

                return {
                    action: EventDecisionAction.CREATE_ALERT,
                    marea: mareaEnEjecucion,
                    nroEtapa: lastStageOpen.nroEtapa
                };
            }
        }

        // Fallback genérico para crear alerta si no hubo reglas restrictivas
        return { action: EventDecisionAction.CREATE_ALERT, marea: mareaMatch };
    }

    /**
     * Encuentra la mejor marea para asignar un evento según el buque y el tipo de evento.
     * Prioriza EN_EJECUCION para arribos y DESIGNADA para zarpadas.
     */
    async findBestMareaMatch(buqueId: string, type: 'ZARPADA' | 'ARRIBO') {
        const mareas = await this.prisma.marea.findMany({
            where: {
                buqueId,
                estadoActual: { codigo: { in: ['DESIGNADA', 'EN_EJECUCION'] } }
            },
            include: {
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' }
                },
                buque: true
            }
        });

        if (mareas.length === 0) return null;

        const mareaDesignada = mareas.find(m => m.estadoActual.codigo === 'DESIGNADA');
        const mareaEnEjecucion = mareas.find(m => m.estadoActual.codigo === 'EN_EJECUCION');

        if (type === 'ZARPADA') {
            // Para zarpada, preferimos la marea DESIGNADA si existe
            return mareaDesignada || mareaEnEjecucion;
        } else {
            // Para arribo, preferimos SIEMPRE la marea EN_EJECUCION
            // incluso si hay una designada (el arribo cierra la actual).
            return mareaEnEjecucion || mareaDesignada;
        }
    }

    /**
     * Verifica si un evento (fecha + puerto) coincide con una etapa ya registrada
     * en la marea, con una tolerancia de +/- 1 día calendario.
     */
    findMatchingStage(marea: any, type: 'ZARPADA' | 'ARRIBO', eventDate: Date, portId?: string, portName?: string) {
        if (!marea.etapas || marea.etapas.length === 0) return null;

        const detDate = DateTime.fromJSDate(eventDate).setZone(this.TIMEZONE).startOf('day');

        for (const etapa of marea.etapas) {
            const fieldDate = type === 'ZARPADA' ? etapa.fechaZarpada : etapa.fechaArribo;
            if (!fieldDate) continue;

            const regDate = DateTime.fromJSDate(fieldDate).setZone(this.TIMEZONE).startOf('day');

            // Criterio de Match: +/- 1 día calendario
            const diffDays = Math.abs(regDate.diff(detDate, 'days').days);

            if (diffDays <= 1) {
                // Validación de puerto si se provee
                // Nota: Eliminamos la restricción estricta de ID aquí para permitir que
                // evaluateEventContext detecte discrepancias de puerto o valide por NOMBRE.
                return etapa;
            }
        }
        return null;
    }

    /**
     * Busca alertas existentes en el sistema que puedan referirse al mismo evento.
     * Realiza una búsqueda bidireccional entre tipos 'ARRIBO'/'POSIBLE_ARRIBO'.
     * Prioriza la búsqueda por mareaId (referenciaId) si se proporciona.
     */
    async findExistingAlert(buqueId: string, type: 'ZARPADA' | 'ARRIBO', date: Date, mareaId?: string) {
        const windowStart = DateTime.fromJSDate(date).minus({ hours: this.ALERT_WINDOW_HOURS }).toJSDate();
        const windowEnd = DateTime.fromJSDate(date).plus({ hours: this.ALERT_WINDOW_HOURS }).toJSDate();

        // Tipos equivalentes para búsqueda cruzada
        const equivalentTypes = type === 'ZARPADA'
            ? ['ZARPADA', 'POSIBLE_ZARPADA']
            : ['ARRIBO', 'POSIBLE_ARRIBO'];

        // REGLA: Si conocemos la mareaId, la búsqueda debe ser ESTRICTA por marea.
        // Si no, usamos el buqueId como fallback general.
        const filterCriteria = mareaId ? {
            referenciaId: mareaId,
            referenciaTipo: 'MAREA'
        } : {
            metadata: {
                path: ['buqueId'],
                equals: buqueId
            }
        };

        return this.prisma.alerta.findFirst({
            where: {
                estado: { in: [AlertaEstado.PENDIENTE, AlertaEstado.SEGUIMIENTO] },
                fechaDetectada: { gte: windowStart, lte: windowEnd },
                AND: [
                    filterCriteria as any,
                    // 2) Filtro de Tipo (Cualquier coincidencia semántica)
                    {
                        OR: [
                            { tipo: { in: equivalentTypes } },
                            {
                                metadata: {
                                    path: ['type'],
                                    equals: type
                                }
                            }
                        ]
                    }
                ]
            }
        });
    }
}
