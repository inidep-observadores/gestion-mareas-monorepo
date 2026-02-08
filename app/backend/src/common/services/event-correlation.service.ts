import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { DateTime } from 'luxon';
import { AlertaEstado } from '../../alerts/alerts.enums';

@Injectable()
export class EventCorrelationService {
    private readonly logger = new Logger(EventCorrelationService.name);
    private readonly TIMEZONE = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';
    private readonly ALERT_WINDOW_HOURS = 24;

    constructor(private prisma: PrismaService) { }

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
                const registeredPortId = type === 'ZARPADA' ? etapa.puertoZarpadaId : etapa.puertoArriboId;

                // Si no hay info de puerto en el evento, confiamos en la fecha
                if (!portId && !portName) return etapa;

                // Si hay ID de puerto registrado y coincide
                if (portId && registeredPortId === portId) return etapa;

                // Si hay ID de puerto registrado y no coincide, seguimos buscando
                if (portId && registeredPortId && portId !== registeredPortId) continue;

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
