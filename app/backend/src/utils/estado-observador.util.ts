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
  isFinSemana: boolean,
  includeNoAfectaPresentismo: boolean = false
): DiaEstadoDto {
  let isNavegando = false;
  let etapaNavegando: any = null;
  let isViaje = false;
  let tipoViajeTramo: 'INICIO' | 'FIN' | null = null;
  let isPuerto = false;
  let isEsperandoZarpada = false;
  let puertoDetalle = '';

  let isNovedad = false;
  let novedadDetalle = '';
  let novedadCodigoCorto = '';
  let mareaReferencia: any = null;
  let novedadReferenciaId: string | undefined = undefined;
  let novedadesActivas: any[] = [];

  // Comprobar Novedades (se permiten superposiciones para detectarlas como conflictos)
  const novedadesDelDia = obsNovedades.filter(n => {
    const inicio = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
    const fin = n.fechaFin ? DateTime.fromJSDate(n.fechaFin, { zone: 'utc' }).endOf('day') : DateTime.now().endOf('year').plus({ years: 10 });
    return currentDate >= inicio && currentDate <= fin;
  });

  for (const novedad of novedadesDelDia) {
    if (novedad && novedad.tipoNovedad) {
      if (!novedad.tipoNovedad.afectaPresentismo && !includeNoAfectaPresentismo) {
        // Ignorar para matriz de presentismo
      } else if (novedad.tipoNovedad.codigo === 'VIAJE_INICIO' || novedad.tipoNovedad.codigo === 'VIAJE_FIN') {
        isViaje = true;
        novedadCodigoCorto = novedad.tipoNovedad.codigo;
        tipoViajeTramo = novedad.tipoNovedad.codigo === 'VIAJE_FIN' ? 'FIN' : 'INICIO';
        novedadDetalle = 'En viaje' + (novedad.motivo ? ` - ${novedad.motivo}` : '');
        novedadReferenciaId = novedad.id;
      } else {
        isNovedad = true;
        novedadesActivas.push(novedad);
        // Retenemos el detalle para el caso en que haya una sola (sin conflicto)
        novedadCodigoCorto = novedad.tipoNovedad.codigo;
        novedadDetalle = novedad.tipoNovedad.descripcion + (novedad.motivo ? ` - ${novedad.motivo}` : '');
        novedadReferenciaId = novedad.id;
      }
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

    // 1. VIAJE INICIAL / EN TRÁNSITO PRE-ZARPADA
    const primeraEtapa = marea.etapas[0];
    if (primeraEtapa && primeraEtapa.fechaZarpada) {
      const zarpada1 = DateTime.fromJSDate(primeraEtapa.fechaZarpada, { zone: 'utc' }).startOf('day');
      
      // A. Inicio de marea validado con fecha de inicio del observador
      if (marea.inicioValidado && marea.fechaInicioObservador) {
        const inicioObs = DateTime.fromJSDate(marea.fechaInicioObservador, { zone: 'utc' }).startOf('day');
        if (currentDate >= inicioObs && currentDate < zarpada1) {
          isViaje = true;
          tipoViajeTramo = 'INICIO';
          mareaReferencia = marea;
          if (!puertoDetalle) puertoDetalle = 'En tránsito';
          break;
        }
      }

      // B. Novedad VIAJE_INICIO previa a la zarpada
      const viajeInicio = obsNovedades.find(n => n.tipoNovedad?.codigo === 'VIAJE_INICIO');
      if (viajeInicio) {
        const finViajeInicio = viajeInicio.fechaFin 
          ? DateTime.fromJSDate(viajeInicio.fechaFin, { zone: 'utc' }).endOf('day')
          : DateTime.fromJSDate(viajeInicio.fechaInicio, { zone: 'utc' }).endOf('day');
        
        if (finViajeInicio < zarpada1 && zarpada1.diff(finViajeInicio, 'days').days <= 10) {
          if (currentDate > finViajeInicio && currentDate < zarpada1) {
            isViaje = true;
            tipoViajeTramo = 'INICIO';
            mareaReferencia = marea;
            if (!puertoDetalle) puertoDetalle = 'En tránsito';
            break;
          }
        }
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
          } else {
            isEsperandoZarpada = true;
          }
          puertoDetalle = puerto.nombre;
          mareaReferencia = marea;
          break;
        }
      }
    }

    if (isPuerto || isEsperandoZarpada) break;

    // Post última etapa
    if (ultimaEtapa && ultimaEtapa.fechaArribo) {
      const arriboUltima = DateTime.fromJSDate(ultimaEtapa.fechaArribo, { zone: 'utc' }).endOf('day');
      if (currentDate > arriboUltima) {
        // A. Novedad VIAJE_FIN posterior al arribo
        const viajeFin = obsNovedades.find(n => {
          if (n.tipoNovedad?.codigo !== 'VIAJE_FIN') return false;
          const ini = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
          return ini > arriboUltima && ini.diff(arriboUltima, 'days').days <= 10;
        });

        if (viajeFin) {
          const inicioViajeFin = DateTime.fromJSDate(viajeFin.fechaInicio, { zone: 'utc' }).startOf('day');
          if (currentDate < inicioViajeFin) {
            isViaje = true;
            tipoViajeTramo = 'FIN';
            mareaReferencia = marea;
            if (!puertoDetalle) puertoDetalle = 'En tránsito';
            break;
          }
        }

        // B. Fecha fin de observador validada
        if (marea.finValidado && marea.fechaFinObservador && currentDate <= DateTime.fromJSDate(marea.fechaFinObservador, { zone: 'utc' }).startOf('day')) {
          isViaje = true;
          tipoViajeTramo = 'FIN';
          mareaReferencia = marea;
          if (!puertoDetalle) puertoDetalle = 'En tránsito';
          break;
        } else if (!marea.fechaFinObservador) {
          // No hay fecha fin observador
          // Si el observador es secundario, su participación concluyó con el arribo de su última etapa asignada
          if (marea.isSecundario) {
            // Participación de observador secundario finalizada, no se consideran días posteriores
          } else if (marea.estadoActual.codigo !== MareaEstado.EN_EJECUCION && marea.estadoActual.codigo !== MareaEstado.DESIGNADA && marea.estadoActual.codigo !== MareaEstado.A_REASIGNAR) {
            // Marea finalizó, no se consideran más días
          } else {
            // Marea activa de observador principal, esperando etapa -> Puerto si no es local, Esperando Zarpada si es local
            const puerto = ultimaEtapa.puertoArribo;
            if (puerto) {
              if (!puerto.esLocal) {
                isPuerto = true;
              } else {
                isEsperandoZarpada = true;
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
  if (isEsperandoZarpada) causasConflicto.push('Esperando Zarpada');
  if (isViaje) causasConflicto.push('Viaje');
  
  for (const nov of novedadesActivas) {
    causasConflicto.push(`Novedad (${nov.tipoNovedad.codigo})`);
  }

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
    const isTransito = puertoDetalle === 'En tránsito' && !novedadDetalle;
    const isInicio = novedadCodigoCorto === 'VIAJE_INICIO' || tipoViajeTramo === 'INICIO';
    const isFin = novedadCodigoCorto === 'VIAJE_FIN' || tipoViajeTramo === 'FIN';
    
    let codCorto = 'VIAJE';
    if (isTransito) {
      codCorto = isFin ? 'TRANSITO_FIN' : 'TRANSITO_INICIO';
    } else {
      codCorto = isFin ? 'VIAJE_FIN' : 'VIAJE_INICIO';
    }

    const detalleFinal = isTransito ? 'En tránsito' : (novedadDetalle || 'En viaje');
    
    estadoDto = { 
      estado: 'VIAJE', 
      codigoCorto: codCorto,
      referenciaId: novedadReferenciaId || mareaReferencia?.id, 
      detalle: detalleFinal 
    };
  } else if (isPuerto) {
    estadoDto = { estado: 'PUERTO', detalle: puertoDetalle };
  } else if (isEsperandoZarpada) {
    estadoDto = { estado: 'ESPERANDO_ZARPADA', detalle: `Esperando zarpada desde puerto local\n${puertoDetalle}` };
  } else if (isNovedad) {
    estadoDto = { estado: 'NOVEDAD', detalle: novedadDetalle, referenciaId: novedadReferenciaId, codigoCorto: novedadCodigoCorto };
  } else if (isFeriado) {
    estadoDto = { estado: 'FERIADO', detalle: feriadoNombre };
  } else if (isFinSemana) {
    estadoDto = { estado: 'FIN_SEMANA' };
  } else {
    estadoDto = { estado: 'LIBRE' };
  }

  if (estadoDto && (estadoDto.estado === 'NAVEGANDO' || estadoDto.estado === 'PUERTO' || estadoDto.estado === 'VIAJE' || estadoDto.estado === 'ESPERANDO_ZARPADA') && (isFeriado || isFinSemana)) {
    estadoDto.computaFranco = true;
  }

  return estadoDto;
}
