import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PlanillaMensualResponseDto, ObservadorRowDto, DiaEstadoDto } from './dto/planilla-mensual-response.dto';
import { DateTime } from 'luxon';
import * as ExcelJS from 'exceljs';

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

  async exportToExcel(year: number, month: number, ids?: string[]) {
    const planilla = await this.obtenerPlanillaMensual(year, month);
    
    // Filtrar observadores si se reciben IDs
    const matrizFiltrada = ids && ids.length > 0
      ? planilla.matriz.filter((m) => ids.includes(m.observador.id))
      : planilla.matriz;

    const workbook = new ExcelJS.Workbook();
    const sheet = workbook.addWorksheet(`Presentismo ${month.toString().padStart(2, '0')}-${year}`);

    // Configurar columnas: Legajo, Observador, días del mes
    const columns: Partial<ExcelJS.Column>[] = [
      { header: 'LEGAJO', key: 'legajo', width: 12 },
      { header: 'OBSERVADOR', key: 'observador', width: 30 },
    ];
    
    for (let i = 1; i <= planilla.diasMes; i++) {
      const fechaObj = DateTime.utc(year, month, i).setLocale('es');
      let nombreDia = fechaObj.toFormat('ccc'); // lun, mar, mié
      nombreDia = nombreDia.normalize("NFD").replace(/[\u0300-\u036f]/g, ""); // Quitar tildes
      nombreDia = nombreDia.charAt(0).toUpperCase() + nombreDia.slice(1);
      
      columns.push({ header: `${nombreDia} ${i}/${month}`, key: `d${i}`, width: 10 });
    }
    
    sheet.columns = columns;

    // Estilo encabezados
    sheet.getRow(1).font = { bold: true };
    sheet.getRow(1).fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FFE0E0E0' }
    };
    sheet.getRow(1).alignment = { horizontal: 'center', vertical: 'middle' };

    matrizFiltrada.forEach((row) => {
      const rowData: any = {
        legajo: row.observador.codigoInterno,
        observador: `${row.observador.apellido}, ${row.observador.nombre}`
      };

      for (let i = 1; i <= planilla.diasMes; i++) {
        const dia = row.dias[i];
        let val = '';
        if (dia) {
          if (dia.estado === 'NAVEGANDO') val = 'NAV';
          else if (dia.estado === 'PUERTO') val = 'PTO';
          else if (dia.estado === 'NOVEDAD') val = 'NOV';
          else if (dia.estado === 'CONFLICTO') val = 'ERR';
        }
        rowData[`d${i}`] = val;
      }

      const newRow = sheet.addRow(rowData);
      
      // Aplicar estilos a las celdas de días
      for (let i = 1; i <= planilla.diasMes; i++) {
        const dia = row.dias[i];
        const cell = newRow.getCell(`d${i}`);
        cell.alignment = { horizontal: 'center', vertical: 'middle' };
        const val = cell.value;
        if (val === 'NAV') {
          cell.font = { color: { argb: 'FF0284C7' }, bold: true };
        } else if (val === 'PTO') {
          cell.font = { color: { argb: 'FFD97706' }, bold: true };
        } else if (val === 'NOV') {
          cell.font = { color: { argb: 'FF059669' }, bold: true };
        } else if (val === 'ERR') {
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFDC2626' } };
          cell.font = { color: { argb: 'FFFFFFFF' }, bold: true };
        } else if (dia && (dia.estado === 'FIN_SEMANA' || dia.estado === 'FERIADO')) {
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFF3F4F6' } };
        }
      }
    });

    return workbook;
  }
}
