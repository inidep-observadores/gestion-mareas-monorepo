import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PlanillaMensualResponseDto, ObservadorRowDto, DiaEstadoDto } from './dto/planilla-mensual-response.dto';
import { DateTime } from 'luxon';
import * as ExcelJS from 'exceljs';
import { MareaEstado } from '../mareas/mareas.constants';

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
      );

      for (let dia = 1; dia <= diasMes; dia++) {
        const currentDate = startOfMonth.set({ day: dia }).startOf('day');

        // Omitir cálculo para días futuros
        if (currentDate > DateTime.now().startOf('day')) {
          row.dias[dia] = { estado: 'LIBRE' };
          row.totales.libres++;
          continue;
        }

        // Banderas de estado
        let isNavegando = false;
        let etapaNavegando: any = null;
        let isViaje = false;
        let isPuerto = false;
        let puertoDetalle = '';
        let isEsperandoZarpada = false;
        let isNovedad = false;
        let novedadDetalle = '';
        let novedadCodigoCorto = '';

        // Comprobar Novedad
        const novedad = obsNovedades.find(n => {
          const inicio = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
          const fin = n.fechaFin ? DateTime.fromJSDate(n.fechaFin, { zone: 'utc' }).endOf('day') : endOfMonth;
          return currentDate >= inicio && currentDate <= fin;
        });
        
        if (novedad && novedad.tipoNovedad) {
          if (!novedad.tipoNovedad.afectaPresentismo) {
            // Ignorar para matriz de presentismo
          } else if (novedad.tipoNovedad.codigo === 'VIAJE_INICIO' || novedad.tipoNovedad.codigo === 'VIAJE_FIN') {
            isViaje = true;
          } else {
            isNovedad = true;
            novedadCodigoCorto = novedad.tipoNovedad.codigo;
            novedadDetalle = novedad.tipoNovedad.descripcion + (novedad.motivo ? ` - ${novedad.motivo}` : '');
          }
        }

        // Comprobar Mareas
        for (const marea of obsMareas) {
          // Evaluar etapas (NAVEGANDO)
          for (let i = 0; i < marea.etapas.length; i++) {
            const etapa = marea.etapas[i];
            const zarpada = etapa.fechaZarpada ? DateTime.fromJSDate(etapa.fechaZarpada, { zone: 'utc' }).startOf('day') : null;
            const arribo = etapa.fechaArribo ? DateTime.fromJSDate(etapa.fechaArribo, { zone: 'utc' }).endOf('day') : null;

            if (zarpada && currentDate >= zarpada) {
              if (!arribo || currentDate <= arribo) {
                isNavegando = true;
                etapaNavegando = etapa;
                break;
              }
            }
          }

          if (!isNavegando) {
            // Etapas Administrativas (entre etapas sin puerto)
            for (let i = 0; i < marea.etapas.length - 1; i++) {
              const arriboActual = marea.etapas[i].fechaArribo ? DateTime.fromJSDate(marea.etapas[i].fechaArribo, { zone: 'utc' }).endOf('day') : null;
              const zarpadaSiguiente = marea.etapas[i+1].fechaZarpada ? DateTime.fromJSDate(marea.etapas[i+1].fechaZarpada, { zone: 'utc' }).startOf('day') : null;

              if (arriboActual && zarpadaSiguiente && currentDate > arriboActual && currentDate < zarpadaSiguiente) {
                if (!marea.etapas[i].puertoArribo && !marea.etapas[i+1].puertoZarpada) {
                  isNavegando = true;
                  etapaNavegando = marea.etapas[i];
                  break;
                }
              }
            }

            // Post última etapa (si llegó pero sin puerto, sigue navegando)
            if (!isNavegando && marea.etapas.length > 0) {
              const ultimaEtapa = marea.etapas[marea.etapas.length - 1];
              if (ultimaEtapa.fechaArribo && !ultimaEtapa.puertoArribo) {
                const arriboUltima = DateTime.fromJSDate(ultimaEtapa.fechaArribo, { zone: 'utc' }).endOf('day');
                if (currentDate > arriboUltima) {
                  if (marea.estadoActual.codigo === MareaEstado.EN_EJECUCION) {
                    isNavegando = true;
                    etapaNavegando = ultimaEtapa;
                  }
                }
              }
            }
          }

          if (isNavegando) break;          // VIAJE O PUERTO
          const isActivaEnEsteDia = (!marea.fechaFinObservador || DateTime.fromJSDate(marea.fechaFinObservador, { zone: 'utc' }).startOf('day') >= currentDate) && 
                                    (marea.fechaInicioObservador && DateTime.fromJSDate(marea.fechaInicioObservador, { zone: 'utc' }).startOf('day') <= currentDate);
          
          if (!isActivaEnEsteDia && marea.fechaFinObservador) continue;

          // 1. VIAJE INICIAL
          const primeraEtapa = marea.etapas[0];
          if (primeraEtapa && primeraEtapa.fechaZarpada && marea.fechaInicioObservador) {
            const zarpada1 = DateTime.fromJSDate(primeraEtapa.fechaZarpada, { zone: 'utc' }).startOf('day');
            const inicioObs = DateTime.fromJSDate(marea.fechaInicioObservador, { zone: 'utc' }).startOf('day');
            if (currentDate >= inicioObs && currentDate < zarpada1) {
              isViaje = true;
              break;
            }
          }

          // 2. VIAJE FINAL O PUERTO
          const ultimaEtapa = marea.etapas.length > 0 ? marea.etapas[marea.etapas.length - 1] : null;
          
          // Puerto Intermedio entre etapas
          for (let i = 0; i < marea.etapas.length - 1; i++) {
            const arriboActual = marea.etapas[i].fechaArribo ? DateTime.fromJSDate(marea.etapas[i].fechaArribo, { zone: 'utc' }).endOf('day') : null;
            const zarpadaSiguiente = marea.etapas[i+1].fechaZarpada ? DateTime.fromJSDate(marea.etapas[i+1].fechaZarpada, { zone: 'utc' }).startOf('day') : null;

            if (arriboActual && zarpadaSiguiente && currentDate > arriboActual && currentDate < zarpadaSiguiente) {
              const puerto = marea.etapas[i].puertoArribo;
              if (puerto) {
                if (!puerto.esLocal) {
                  isPuerto = true;
                } else {
                  isEsperandoZarpada = true;
                }
                puertoDetalle = puerto.nombre;
                break;
              }
            }
          }

          if (isPuerto || isEsperandoZarpada) break;

          // Post última etapa
          if (ultimaEtapa && ultimaEtapa.fechaArribo) {
            const arriboUltima = DateTime.fromJSDate(ultimaEtapa.fechaArribo, { zone: 'utc' }).endOf('day');
            if (currentDate > arriboUltima) {
              if (marea.fechaFinObservador && currentDate <= DateTime.fromJSDate(marea.fechaFinObservador, { zone: 'utc' }).startOf('day')) {
                // Hay fecha_fin_observador seteada -> Es Viaje
                isViaje = true;
                break;
              } else if (!marea.fechaFinObservador) {
                // No hay fecha fin observador
                if (marea.estadoActual.codigo !== MareaEstado.EN_EJECUCION && marea.estadoActual.codigo !== MareaEstado.DESIGNADA && marea.estadoActual.codigo !== MareaEstado.A_REASIGNAR) {
                  // Marea finalizó, no se consideran más días
                } else {
                  // Marea activa, esperando etapa -> Puerto si no es local, Esperando Zarpada si es local
                  const puerto = ultimaEtapa.puertoArribo;
                  if (puerto) {
                    if (!puerto.esLocal) {
                      isPuerto = true;
                    } else {
                      isEsperandoZarpada = true;
                    }
                    puertoDetalle = puerto.nombre;
                    break;
                  }
                }
              }
            }
          }
        }

        // Determinar Feriado o Fin de Semana
        const isFeriado = !!feriados[dia];
        const isFinSemana = currentDate.weekday === 6 || currentDate.weekday === 7;

        let causasConflicto = [];
        if (isNavegando) causasConflicto.push('Navegación');
        if (isPuerto) causasConflicto.push('Puerto');
        if (isEsperandoZarpada) causasConflicto.push('Esperando Zarpada');
        if (isViaje) causasConflicto.push('Viaje');
        if (isNovedad) causasConflicto.push(`Novedad (${novedadCodigoCorto})`);

        let countFuertes = causasConflicto.length;
        let estadoDto: DiaEstadoDto;

        if (countFuertes > 1) {
          estadoDto = {
            estado: 'CONFLICTO',
            conflictoDetalle: `Solapamiento: ${causasConflicto.join(' + ')}`,
          };
          row.totales.conflictos++;
        } else if (isNavegando) {
          estadoDto = { estado: 'NAVEGANDO', referenciaId: etapaNavegando.id };
          row.totales.navegando++;
        } else if (isViaje) {
          estadoDto = { estado: 'VIAJE' };
        } else if (isPuerto) {
          estadoDto = { estado: 'PUERTO', detalle: puertoDetalle };
          row.totales.puerto++;
        } else if (isEsperandoZarpada) {
          estadoDto = { estado: 'ESPERANDO_ZARPADA', detalle: puertoDetalle };
          row.totales.esperandoZarpada++;
        } else if (isNovedad) {
          estadoDto = { estado: 'NOVEDAD', detalle: novedadDetalle, referenciaId: novedad.id, codigoCorto: novedadCodigoCorto };
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

        if (estadoDto && (estadoDto.estado === 'NAVEGANDO' || estadoDto.estado === 'PUERTO' || estadoDto.estado === 'ESPERANDO_ZARPADA' || estadoDto.estado === 'VIAJE') && (isFeriado || isFinSemana)) {
          estadoDto.computaFranco = true;
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
          if (dia.estado === 'NAVEGANDO') val = 'NAVEG';
          else if (dia.estado === 'PUERTO') val = 'PUERTO';
          else if (dia.estado === 'ESPERANDO_ZARPADA') val = 'EZ';
          else if (dia.estado === 'VIAJE') val = 'VIAJE';
          else if (dia.estado === 'FERIADO') val = 'FERIADO';
          else if (dia.estado === 'NOVEDAD') val = dia.codigoCorto || 'NOV';
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
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF00FF00' } };
            cell.font = { color: { argb: 'FF000000' }, bold: true };
          } else if (dia.estado === 'PUERTO') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFE4C4' } };
            cell.font = { color: { argb: 'FF000000' }, bold: true };
            if (dia.detalle) cell.note = dia.detalle;
          } else if (dia.estado === 'ESPERANDO_ZARPADA') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE8E8E8' } }; // Light gray for EZ
            cell.font = { color: { argb: 'FF000000' }, bold: true };
            if (dia.detalle) cell.note = `Esperando zarpada en: ${dia.detalle}`;
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
