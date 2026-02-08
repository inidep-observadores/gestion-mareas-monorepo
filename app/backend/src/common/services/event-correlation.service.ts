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

        // 1. Deduplicación funcional: ¿Ya existe una alerta (PNA, Tracking u otro)?
        const existingAlert = await this.findExistingAlert(buqueId, type, date);

        // 2. Encontrar las mareas potenciales (DESIGNADA o EN_EJECUCION)
        const mareas = await this.prisma.marea.findMany({
            where: {
                buqueId,
                estadoActual: { codigo: { in: ['DESIGNADA', 'EN_EJECUCION'] } }
            },
            include: {
                estadoActual: true,
                etapas: { orderBy: { nroEtapa: 'asc' } },
                buque: true
            }
        });

        if (mareas.length === 0) return { action: EventDecisionAction.NO_MATCH, marea: null };

        const mareaDesignada = mareas.find(m => m.estadoActual.codigo === 'DESIGNADA');
        const mareaEnEjecucion = mareas.find(m => m.estadoActual.codigo === 'EN_EJECUCION');

        // Determinar marea objetivo inicial según tipo de evento
        let mareaMatch = type === 'ZARPADA'
            ? (mareaDesignada || mareaEnEjecucion)
            : (mareaEnEjecucion || mareaDesignada);

        if (!mareaMatch) return { action: EventDecisionAction.NO_MATCH, marea: null };

        // 3. Caso Deduplicación: Si ya existe alerta, indicamos VALIDAR (Source Stacking)
        if (existingAlert) {
            return { action: EventDecisionAction.VALIDATE_ALERT, marea: mareaMatch, existingAlert };
        }

        // 4. Caso Etapa Registrada: ¿Coincide con una etapa ya registrada?
        const stageMatch = this.findMatchingStage(mareaMatch, type, date, portId, portName);
        if (stageMatch) {
            const matchedPortId = type === 'ZARPADA' ? stageMatch.puertoZarpadaId : stageMatch.puertoArriboId;
            const registeredDate = type === 'ZARPADA' ? stageMatch.fechaZarpada : stageMatch.fechaArribo;

            // VALIDACIÓN DE PUERTO: Por ID o por Nombre
            const registeredPortName = allPorts.find(p => p.id === matchedPortId)?.nombre;
            const portIsSame = matchedPortId === portId || (registeredPortName && registeredPortName === portName);

            if (!portIsSame) {
                return { action: EventDecisionAction.DISCREPANCY_PORT, marea: mareaMatch, stageMatch };
            }

            // VALIDACIÓN DE FECHA: Mismo día local
            const registeredLocalKey = DateTime.fromJSDate(registeredDate!).setZone(TIMEZONE).toFormat('yyyy-MM-dd');
            const eventLocalKey = eventDate.toFormat('yyyy-MM-dd');

            if (registeredLocalKey !== eventLocalKey) {
                return { action: EventDecisionAction.DISCREPANCY_DATE, marea: mareaMatch, stageMatch };
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
            if (mareaEnEjecucion) {
                // REGLA ESPECIAL: Si hay una marea DESIGNADA esperando, sugerir FINALIZAR marea
                if (mareaDesignada) {
                    return {
                        action: EventDecisionAction.RECOMMEND_FIN_MAREA,
                        marea: mareaEnEjecucion,
                        mareaSiguiente: mareaDesignada
                    };
                }

                // COHERENCIA CRONOLÓGICA: Ignorar si el arribo es anterior al inicio de la marea o etapas posteriores
                const hasPosteriorStage = mareaEnEjecucion.etapas.some(e => e.fechaZarpada && new Date(e.fechaZarpada) > date);
                if (hasPosteriorStage) {
                    return { action: EventDecisionAction.IGNORE_OLD, marea: mareaEnEjecucion };
                }

                const lastStageOpen = [...mareaEnEjecucion.etapas].sort((a, b) => b.nroEtapa - a.nroEtapa).find(e => !e.fechaArribo);

                // SECUENCIALIDAD: El arribo debe ser posterior a la zarpada registrada de la etapa abierta (si existe)
                if (lastStageOpen && new Date(date) <= new Date(lastStageOpen.fechaZarpada)) {
                    return { action: EventDecisionAction.IGNORE_OLD, marea: mareaEnEjecucion };
                }

                return {
                    action: EventDecisionAction.CREATE_ALERT,
                    marea: mareaEnEjecucion,
                    nroEtapa: lastStageOpen?.nroEtapa
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
     */
    async findExistingAlert(buqueId: string, type: 'ZARPADA' | 'ARRIBO', date: Date) {
        const windowStart = DateTime.fromJSDate(date).minus({ hours: this.ALERT_WINDOW_HOURS }).toJSDate();
        const windowEnd = DateTime.fromJSDate(date).plus({ hours: this.ALERT_WINDOW_HOURS }).toJSDate();

        // Tipos equivalentes para búsqueda cruzada
        const equivalentTypes = type === 'ZARPADA'
            ? ['ZARPADA', 'POSIBLE_ZARPADA']
            : ['ARRIBO', 'POSIBLE_ARRIBO'];

        return this.prisma.alerta.findFirst({
            where: {
                estado: { in: [AlertaEstado.PENDIENTE, AlertaEstado.SEGUIMIENTO] },
                fechaDetectada: { gte: windowStart, lte: windowEnd },
                AND: [
                    // 1) Filtro de Buque (Obligatorio)
                    {
                        metadata: {
                            path: ['buqueId'],
                            equals: buqueId
                        }
                    },
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
