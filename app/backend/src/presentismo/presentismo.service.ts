import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PlanillaMensualResponseDto, ObservadorRowDto, DiaEstadoDto } from './dto/planilla-mensual-response.dto';
import { DateTime } from 'luxon';

@Injectable()
export class PresentismoService {
  constructor(private readonly prisma: PrismaService) {}

  async obtenerPlanillaMensual(year: number, month: number): Promise<PlanillaMensualResponseDto> {
    const startOfMonth = DateTime.utc(year, month, 1);
    const endOfMonth = startOfMonth.endOf('month');
    const diasMes = startOfMonth.daysInMonth;

    // 1. Obtener observadores activos
    const observadores = await this.prisma.observador.findMany({
      where: { activo: true },
      select: { id: true, nombre: true, apellido: true, codigoInterno: true, tipoObservador: true, tipoContrato: true },
      orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
    });

    // 2. Traer Feriados del mes
    const feriadosDb = await this.prisma.feriado.findMany({
      where: {
        fecha: {
          gte: startOfMonth.toJSDate(),
          lte: endOfMonth.toJSDate(),
        },
      },
    });

    const feriados: Record<number, string> = {};
    feriadosDb.forEach(f => {
      feriados[DateTime.fromJSDate(f.fecha, { zone: 'utc' }).day] = f.nombre;
    });

    // 3. Traer Novedades que se solapen con el mes
    const novedadesDb = await this.prisma.observadorNovedad.findMany({
      where: {
        estadoAprobacion: 'APROBADA',
        fechaInicio: { lte: endOfMonth.toJSDate() },
        OR: [
          { fechaFin: { gte: startOfMonth.toJSDate() } },
          { fechaFin: null },
        ],
      },
    });

    // 4. Traer Etapas para determinar Navegando y Puertos
    const startDateForEtapas = startOfMonth.minus({ days: 60 }).toJSDate();
    const etapasDb = await this.prisma.mareaEtapaObservador.findMany({
      where: {
        etapa: {
          fechaZarpada: { not: null, lte: endOfMonth.toJSDate() },
          fechaArribo: { not: null, gte: startDateForEtapas },
        },
      },
      include: {
        etapa: {
          include: {
            puertoArribo: true,
          },
        },
      },
      orderBy: {
        etapa: {
          fechaZarpada: 'asc',
        },
      },
    });

    const matriz: ObservadorRowDto[] = [];

    for (const obs of observadores) {
      const row: ObservadorRowDto = {
        observador: obs,
        dias: {},
        totales: {
          navegando: 0,
          puerto: 0,
          novedades: 0,
          libres: 0,
          feriadosFinSemana: 0,
          conflictos: 0,
        },
      };

      const obsNovedades = novedadesDb.filter(n => n.observadorId === obs.id);
      const obsEtapas = etapasDb.filter(e => e.observadorId === obs.id).map(e => e.etapa);

      for (let dia = 1; dia <= diasMes; dia++) {
        const currentDate = startOfMonth.set({ day: dia }).startOf('day');

        // Banderas de estado
        let isNavegando = false;
        let etapaNavegando: any = null;

        let isPuerto = false;
        let puertoDetalle = '';

        let isNovedad = false;
        let novedadDetalle = '';

        // Comprobar Novedad
        const novedad = obsNovedades.find(n => {
          const inicio = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
          const fin = n.fechaFin ? DateTime.fromJSDate(n.fechaFin, { zone: 'utc' }).endOf('day') : endOfMonth;
          return currentDate >= inicio && currentDate <= fin;
        });
        if (novedad) {
          isNovedad = true;
          novedadDetalle = novedad.estadoDisponibilidad + (novedad.motivo ? ` - ${novedad.motivo}` : '');
        }

        // Comprobar Navegando
        const etapa = obsEtapas.find(e => {
          if (!e.fechaZarpada || !e.fechaArribo) return false;
          const zarpada = DateTime.fromJSDate(e.fechaZarpada, { zone: 'utc' }).startOf('day');
          const arribo = DateTime.fromJSDate(e.fechaArribo, { zone: 'utc' }).endOf('day');
          return currentDate >= zarpada && currentDate <= arribo;
        });
        if (etapa) {
          isNavegando = true;
          etapaNavegando = etapa;
        }

        // Comprobar Puerto
        if (!isNavegando) {
          const etapasAnteriores = obsEtapas.filter(e => e.fechaArribo && DateTime.fromJSDate(e.fechaArribo, { zone: 'utc' }).endOf('day') < currentDate);
          if (etapasAnteriores.length > 0) {
            const ultimaEtapa = etapasAnteriores[etapasAnteriores.length - 1];
            if (ultimaEtapa.puertoArribo && !ultimaEtapa.puertoArribo.esLocal) {
              const proximasEtapas = obsEtapas.filter(e => e.fechaZarpada && DateTime.fromJSDate(e.fechaZarpada, { zone: 'utc' }).startOf('day') > currentDate);
              // Como la lógica es un puerto entre navegaciones, podríamos requerir que haya una próxima etapa para considerarlo en "Puerto",
              // pero si la marea aún no empezó su próxima etapa igual se asume en ese puerto.
              isPuerto = true;
              puertoDetalle = ultimaEtapa.puertoArribo.nombre;
            }
          }
        }

        // Determinar Feriado o Fin de Semana
        const isFeriado = !!feriados[dia];
        const isFinSemana = currentDate.weekday === 6 || currentDate.weekday === 7; // 6 = Sab, 7 = Dom

        // Evaluación de Conflictos
        let countFuertes = 0;
        if (isNavegando) countFuertes++;
        if (isPuerto) countFuertes++;
        if (isNovedad) countFuertes++;

        let estadoDto: DiaEstadoDto;

        if (countFuertes > 1) {
          // CONFLICTO
          const causantes = [];
          if (isNavegando) causantes.push('Navegando');
          if (isPuerto) causantes.push(`Puerto (${puertoDetalle})`);
          if (isNovedad) causantes.push(`Novedad (${novedadDetalle})`);

          estadoDto = {
            estado: 'CONFLICTO',
            conflictoDetalle: `Solapamiento detectado: ${causantes.join(' y ')}`,
          };
          row.totales.conflictos++;
        } else if (isNavegando) {
          estadoDto = { estado: 'NAVEGANDO', referenciaId: etapaNavegando.id };
          row.totales.navegando++;
        } else if (isPuerto) {
          estadoDto = { estado: 'PUERTO', detalle: puertoDetalle };
          row.totales.puerto++;
        } else if (isNovedad) {
          estadoDto = { estado: 'NOVEDAD', detalle: novedadDetalle, referenciaId: novedad.id };
          row.totales.novedades++;
        } else if (isFeriado) {
          estadoDto = { estado: 'FERIADO', detalle: feriados[dia] };
          row.totales.feriadosFinSemana++;
        } else if (isFinSemana) {
          estadoDto = { estado: 'FIN_SEMANA' };
          row.totales.feriadosFinSemana++;
        } else {
          estadoDto = { estado: 'LIBRE' };
          row.totales.libres++;
        }

        row.dias[dia] = estadoDto;
      }

      matriz.push(row);
    }

    return {
      year,
      month,
      diasMes,
      feriados,
      matriz,
    };
  }
}
