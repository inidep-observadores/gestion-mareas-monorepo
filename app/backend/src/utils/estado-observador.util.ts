import { DateTime } from 'luxon';
import { MareaEstado } from '../mareas/mareas.constants';
import { DiaEstadoDto } from '../presentismo/dto/planilla-mensual-response.dto';

/**
 * Evalúa el estado de un observador para un día específico basándose en sus mareas, novedades y feriados.
 * Extraído para ser reutilizado entre Presentismo y Planificación sin acoplar los dominios.
 */
export function evaluarEstadoDia(
  currentDate: DateTime,
  obsMareas: any[],
  obsNovedades: any[],
  feriadoNombre: string | null,
  isFinSemana: boolean
): DiaEstadoDto {
  let isNavegando = false;
  let etapaNavegando: any = null;
  let isViaje = false;
  let isPuerto = false;
  let puertoDetalle = '';

  let isNovedad = false;
  let novedadDetalle = '';
  let novedadCodigoCorto = '';
  let mareaReferencia: any = null;

  // Comprobar Novedad
  const novedad = obsNovedades.find(n => {
    const inicio = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
    const fin = n.fechaFin ? DateTime.fromJSDate(n.fechaFin, { zone: 'utc' }).endOf('day') : DateTime.now().endOf('year').plus({ years: 10 });
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
        const zarpadaSiguiente = marea.etapas[i + 1].fechaZarpada ? DateTime.fromJSDate(marea.etapas[i + 1].fechaZarpada, { zone: 'utc' }).startOf('day') : null;

        if (arriboActual && zarpadaSiguiente && currentDate > arriboActual && currentDate < zarpadaSiguiente) {
          if (!marea.etapas[i].puertoArribo && !marea.etapas[i + 1].puertoZarpada) {
            isNavegando = true;
            etapaNavegando = marea.etapas[i];
            break;
          }
        }
      }
      if (isNavegando) {
        mareaReferencia = marea;
        break;
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

    if (isNavegando) {
      mareaReferencia = marea;
      break;
    }

    // Descartar si el día es posterior a la fecha de fin o anterior a la designación
    if (marea.fechaFinObservador && currentDate > DateTime.fromJSDate(marea.fechaFinObservador, { zone: 'utc' }).startOf('day')) {
      continue;
    }

    // 1. VIAJE INICIAL
    const primeraEtapa = marea.etapas[0];
    if (marea.inicioValidado && primeraEtapa && primeraEtapa.fechaZarpada && marea.fechaInicioObservador) {
      const zarpada1 = DateTime.fromJSDate(primeraEtapa.fechaZarpada, { zone: 'utc' }).startOf('day');
      const inicioObs = DateTime.fromJSDate(marea.fechaInicioObservador, { zone: 'utc' }).startOf('day');
      if (currentDate >= inicioObs && currentDate < zarpada1) {
        isViaje = true;
        mareaReferencia = marea;
        break;
      }
    }

    // 2. VIAJE FINAL O PUERTO
    const ultimaEtapa = marea.etapas.length > 0 ? marea.etapas[marea.etapas.length - 1] : null;

    // Puerto Intermedio entre etapas
    for (let i = 0; i < marea.etapas.length - 1; i++) {
      const arriboActual = marea.etapas[i].fechaArribo ? DateTime.fromJSDate(marea.etapas[i].fechaArribo, { zone: 'utc' }).endOf('day') : null;
      const zarpadaSiguiente = marea.etapas[i + 1].fechaZarpada ? DateTime.fromJSDate(marea.etapas[i + 1].fechaZarpada, { zone: 'utc' }).startOf('day') : null;

      if (arriboActual && zarpadaSiguiente && currentDate > arriboActual && currentDate < zarpadaSiguiente) {
        const puerto = marea.etapas[i].puertoArribo;
        if (puerto) {
          if (!puerto.esLocal) {
            isPuerto = true;
          }
          puertoDetalle = puerto.nombre;
          mareaReferencia = marea;
          break;
        }
      }
    }

    if (isPuerto) break;

    // Post última etapa
    if (ultimaEtapa && ultimaEtapa.fechaArribo) {
      const arriboUltima = DateTime.fromJSDate(ultimaEtapa.fechaArribo, { zone: 'utc' }).endOf('day');
      if (currentDate > arriboUltima) {
        if (marea.finValidado && marea.fechaFinObservador && currentDate <= DateTime.fromJSDate(marea.fechaFinObservador, { zone: 'utc' }).startOf('day')) {
          // Hay fecha_fin_observador seteada y validada -> Es Viaje
          isViaje = true;
          mareaReferencia = marea;
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
              }
              puertoDetalle = puerto.nombre;
              mareaReferencia = marea;
              break;
            }
          }
        }
      }
    }
  }

  // Construir el DTO final
  const isFeriado = !!feriadoNombre;
  let causasConflicto = [];
  if (isNavegando) causasConflicto.push('Navegación');
  if (isPuerto) causasConflicto.push('Puerto');
  if (isViaje) causasConflicto.push('Viaje');
  if (isNovedad) causasConflicto.push(`Novedad (${novedadCodigoCorto})`);

  let countFuertes = causasConflicto.length;
  let estadoDto: DiaEstadoDto;

  if (countFuertes > 1) {
    if (countFuertes === 2 && isNavegando && isViaje) {
      const mareaStr = mareaReferencia ? `${mareaReferencia.tipoMarea}-${mareaReferencia.nroMarea}-${mareaReferencia.anioMarea.toString().slice(-2)}` : '';
      estadoDto = { estado: 'NAVEGANDO', estadoSecundario: 'VIAJE', referenciaId: etapaNavegando?.id || mareaReferencia?.id, detalle: mareaStr };
    } else {
      estadoDto = {
        estado: 'CONFLICTO',
        conflictoDetalle: `Solapamiento: ${causasConflicto.join(' + ')}`,
      };
    }
  } else if (isNavegando) {
    const mareaStr = mareaReferencia ? `${mareaReferencia.tipoMarea}-${mareaReferencia.nroMarea}-${mareaReferencia.anioMarea.toString().slice(-2)}` : '';
    estadoDto = { estado: 'NAVEGANDO', referenciaId: etapaNavegando?.id || mareaReferencia?.id, detalle: mareaStr };
  } else if (isViaje) {
    const mareaStr = mareaReferencia ? `${mareaReferencia.tipoMarea}-${mareaReferencia.nroMarea}-${mareaReferencia.anioMarea.toString().slice(-2)}` : '';
    estadoDto = { estado: 'VIAJE', referenciaId: mareaReferencia?.id, detalle: mareaStr };
  } else if (isPuerto) {
    estadoDto = { estado: 'PUERTO', detalle: puertoDetalle };
  } else if (isNovedad) {
    estadoDto = { estado: 'NOVEDAD', detalle: novedadDetalle, referenciaId: novedad?.id, codigoCorto: novedadCodigoCorto };
  } else if (isFeriado) {
    estadoDto = { estado: 'FERIADO', detalle: feriadoNombre };
  } else if (isFinSemana) {
    estadoDto = { estado: 'FIN_SEMANA' };
  } else {
    estadoDto = { estado: 'LIBRE' };
  }

  if (estadoDto && (estadoDto.estado === 'NAVEGANDO' || estadoDto.estado === 'PUERTO' || estadoDto.estado === 'VIAJE') && (isFeriado || isFinSemana)) {
    estadoDto.computaFranco = true;
  }

  return estadoDto;
}
