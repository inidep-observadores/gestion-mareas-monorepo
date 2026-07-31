import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PlanillaMensualResponseDto, ObservadorRowDto, DiaEstadoDto } from './dto/planilla-mensual-response.dto';
import { DateTime } from 'luxon';
import * as ExcelJS from 'exceljs';
import { MareaEstado } from '../mareas/mareas.constants';
import { evaluarEstadoDia } from '../utils/estado-observador.util';

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
      include: {
        tipoNovedad: true
      }
    });

    // 4. Traer Mareas para el mes actual
    const mareasDb = await this.prisma.marea.findMany({
      where: {
        activo: true,
        OR: [
          { fechaInicioObservador: { lte: endOfMonth.toJSDate() }, fechaFinObservador: { gte: startOfMonth.toJSDate() } },
          { fechaInicioObservador: { lte: endOfMonth.toJSDate() }, fechaFinObservador: null },
          {
            etapas: {
              some: {
                fechaZarpada: { lte: endOfMonth.toJSDate() },
                OR: [
                  { fechaArribo: { gte: startOfMonth.toJSDate() } },
                  { fechaArribo: null }
                ]
              }
            }
          }
        ]
      },
      include: {
        estadoActual: true,
        etapas: {
          orderBy: { nroEtapa: 'asc' },
          include: {
            puertoArribo: true,
            puertoZarpada: true,
            observadores: true
          }
        },
        observadorPrincipal: true
      }
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
          esperandoZarpada: 0,
        },
      };

      const obsNovedades = novedadesDb.filter(n => n.observadorId === obs.id);
      
      const obsMareas = mareasDb.filter(m => 
        m.observadorPrincipalId === obs.id || 
        m.etapas.some(e => e.observadores.some(eo => eo.observadorId === obs.id))
      ).sort((a, b) => {
        const aStarted = a.fechaInicioObservador !== null;
        const bStarted = b.fechaInicioObservador !== null;
        if (aStarted && !bStarted) return -1;
        if (!aStarted && bStarted) return 1;

        const aFinished = a.fechaFinObservador !== null;
        const bFinished = b.fechaFinObservador !== null;
        if (!aFinished && bFinished) return -1;
        if (aFinished && !bFinished) return 1;

        const aDate = a.fechaInicioObservador ? a.fechaInicioObservador.getTime() : 0;
        const bDate = b.fechaInicioObservador ? b.fechaInicioObservador.getTime() : 0;
        return bDate - aDate;
      });

      for (let dia = 1; dia <= diasMes; dia++) {
        const currentDate = startOfMonth.set({ day: dia }).startOf('day');

        // Omitir cálculo para días futuros
        if (currentDate > DateTime.now().startOf('day')) {
          row.dias[dia] = { estado: 'LIBRE' };
          row.totales.libres++;
          continue;
        }

        const feriadoNombre = feriados[dia] || null;
        const isFinSemana = currentDate.weekday === 6 || currentDate.weekday === 7;

        const estadoDto = evaluarEstadoDia(
          currentDate,
          obsMareas,
          obsNovedades,
          feriadoNombre,
          isFinSemana
        );

        // Incrementar totales según el estado devuelto
        if (estadoDto.estado === 'NAVEGANDO') {
          row.totales.navegando++;
        } else if (estadoDto.estado === 'PUERTO') {
          row.totales.puerto++;
        } else if (estadoDto.estado === 'NOVEDAD') {
          row.totales.novedades++;
        } else if (estadoDto.estado === 'FERIADO' || estadoDto.estado === 'FIN_SEMANA') {
          row.totales.feriadosFinSemana++;
        } else if (estadoDto.estado === 'LIBRE') {
          row.totales.libres++;
        } else if (estadoDto.estado === 'CONFLICTO') {
          row.totales.conflictos++;
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
          if (dia.estado === 'NAVEGANDO' && dia.estadoSecundario === 'VIAJE') val = 'NAV/VIA';
          else if (dia.estado === 'NAVEGANDO') val = 'NAVEG';
          else if (dia.estado === 'PUERTO') val = 'PUERTO';
          else if (dia.estado === 'ESPERANDO_ZARPADA') val = 'EZ';
          else if (dia.estado === 'VIAJE') val = 'VIAJE';
          else if (dia.estado === 'FERIADO') val = 'FERIADO';
          else if (dia.estado === 'NOVEDAD') {
            val = dia.codigoCorto === 'ENFERMEDAD' ? 'MÉDICO' : (dia.codigoCorto || 'NOV');
          }
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
        
        if (dia) {
          if (dia.estado === 'NAVEGANDO') {
            if (dia.estadoSecundario === 'VIAJE') {
              cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF98FB98' } }; // Pale green
              cell.font = { color: { argb: 'FF000000' }, bold: true };
              cell.note = `Navegando y Viaje. ${dia.detalle || ''}`.trim();
            } else {
              cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF00FF00' } };
              cell.font = { color: { argb: 'FF000000' }, bold: true };
            }
          } else if (dia.estado === 'PUERTO') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFE4C4' } };
            cell.font = { color: { argb: 'FF000000' }, bold: true };
            if (dia.detalle) cell.note = dia.detalle;
          } else if (dia.estado === 'ESPERANDO_ZARPADA') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE8E8E8' } }; // Light gray for EZ
            cell.font = { color: { argb: 'FF000000' }, bold: true };
            if (dia.detalle) cell.note = `Esperando zarpada: ${dia.detalle}`;
          } else if (dia.estado === 'VIAJE') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE6E6FA' } };
            cell.font = { color: { argb: 'FF000000' }, bold: true };
          } else if (dia.estado === 'FERIADO') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFA500' } };
            cell.font = { color: { argb: 'FF000000' }, bold: true };
            if (dia.detalle) cell.note = dia.detalle;
          } else if (dia.estado === 'NOVEDAD') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFADD8E6' } };
            cell.font = { color: { argb: 'FF000000' }, bold: true };
            if (dia.detalle && dia.detalle.includes(' - ')) {
              cell.note = dia.detalle.substring(dia.detalle.indexOf(' - ') + 3);
            }
          } else if (dia.estado === 'CONFLICTO') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFDC2626' } };
            cell.font = { color: { argb: 'FFFFFFFF' }, bold: true };
            if (dia.conflictoDetalle) cell.note = dia.conflictoDetalle;
          }

          if (dia.computaFranco) {
            cell.border = {
              top: { style: 'medium', color: { argb: 'FFFF0000' } },
              left: { style: 'medium', color: { argb: 'FFFF0000' } },
              bottom: { style: 'medium', color: { argb: 'FFFF0000' } },
              right: { style: 'medium', color: { argb: 'FFFF0000' } }
            };
          }
        }
      }
    });

    return workbook;
  }
}
