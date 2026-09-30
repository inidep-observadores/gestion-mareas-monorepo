import type { ObservadorDisponibilidadItem } from '@/modules/admin/interfaces/disponibilidad.interface';

export const formatFechasRango = (startIso: string, endIso: string): string => {
  const start = new Date(startIso.includes('T') ? startIso : startIso + 'T00:00:00');
  const end = new Date(endIso.includes('T') ? endIso : endIso + 'T00:00:00');

  const fStart = start.toLocaleDateString('es-AR', { day: '2-digit', month: '2-digit', year: 'numeric' });
  const fEnd = end.toLocaleDateString('es-AR', { day: '2-digit', month: '2-digit', year: 'numeric' });

  const diffTime = Math.abs(end.getTime() - start.getTime());
  const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24)) + 1;

  if (fStart === fEnd) {
    return `${fStart} (1 día)`;
  }
  return `${fStart} – ${fEnd} (${diffDays} días)`;
};

export const formatItemTooltip = (item: ObservadorDisponibilidadItem, nombreObs: string): string => {
  let titulo = '';
  let tituloColor = 'text-white';

  if (item.codigoCorto === 'NO DISP. (EST.)') {
    titulo = 'No disponible (Proyección estimada)';
    tituloColor = 'text-rose-400';
  } else if (item.estado === 'NAVEGANDO') {
    if (item.estadoSecundario === 'PROYECTADA') {
      titulo = 'Navegación (Proyección estimada)';
      tituloColor = 'text-emerald-400';
    } else {
      titulo = 'Navegación';
      tituloColor = 'text-emerald-400';
    }
  } else if (item.estado === 'DISPONIBLE') {
    titulo = 'Disponible (Confirmada)';
    tituloColor = 'text-amber-400';
  } else if (item.estado === 'DISPONIBLE_NO_CONFIRMADA') {
    titulo = 'Disponibilidad no confirmada';
    tituloColor = 'text-amber-300';
  } else if (item.estado === 'DESIGNADA') {
    titulo = 'Marea Designada';
    tituloColor = 'text-emerald-400';
  } else if (item.estado === 'IMPEDIMENTO') {
    titulo = 'Con Impedimento';
    tituloColor = 'text-red-400';
  } else if (item.estado === 'PUERTO') {
    titulo = 'En Puerto (No local)';
    tituloColor = 'text-orange-400';
  } else if (item.estado === 'ESPERANDO_ZARPADA') {
    titulo = 'Esperando zarpada';
    tituloColor = 'text-gray-300';
  } else if (item.estado === 'VIAJE') {
    titulo = 'En Viaje / Tránsito';
    tituloColor = 'text-indigo-400';
  } else if (item.estado === 'NOVEDAD') {
    const cod = (item.codigoCorto || '').toUpperCase();
    if (cod === 'NO_DISP' || cod === 'NO DISPONIBLE' || cod === 'NO_DISPONIBLE') {
      titulo = 'No Disponible';
      tituloColor = 'text-red-400';
    } else if (cod === 'FC') {
      titulo = 'Franco Compensatorio';
      tituloColor = 'text-amber-400';
    } else if (cod === 'LICEN' || cod === 'LICENCIA') {
      titulo = 'Licencia / Vacaciones';
      tituloColor = 'text-sky-400';
    } else if (cod === 'DONACION_SANGRE') {
      titulo = 'Donación de Sangre';
      tituloColor = 'text-sky-400';
    } else if (cod === 'RP') {
      titulo = 'Razones Particulares';
      tituloColor = 'text-sky-400';
    } else {
      titulo = item.codigoCorto ? item.codigoCorto.replace(/_/g, ' ') : 'Novedad';
      tituloColor = 'text-sky-400';
    }
  } else if (item.estado === 'CONFLICTO') {
    titulo = 'Conflicto de eventos';
    tituloColor = 'text-red-400';
  } else {
    titulo = String(item.estado || '').replace(/_/g, ' ');
  }

  const rangoStr = formatFechasRango(item.startDate, item.endDate);

  let html = `<div class="font-bold text-xs ${tituloColor} mb-0.5">${titulo}</div>`;
  html += `<div class="text-[11px] text-gray-300 font-mono mb-1">📅 ${rangoStr}</div>`;

  if (item.codigoCorto === 'NO DISP. (EST.)') {
    if (item.detalle) {
      html += `<div class="text-xs text-gray-100 font-medium mt-1">${item.detalle}</div>`;
    }
    html += `<div class="text-[10px] text-rose-300 font-semibold mt-1">⚠️ Proyección estimada de marea en curso (ventana móvil de 7 días)</div>`;
    html += `<div class="text-[10px] text-gray-400 italic mt-0.5">Sujeto a la confirmación de arribo o finalización formal</div>`;
  } else if (item.estado === 'NAVEGANDO') {
    if (item.detalle) {
      html += `<div class="text-xs text-gray-100 font-medium mt-1">${item.detalle}</div>`;
    }
    if (item.estadoSecundario === 'PROYECTADA') {
      html += `<div class="text-[10px] text-emerald-300 font-semibold mt-1">Estimación según días previstos de marea en curso</div>`;
      html += `<div class="text-[10px] text-gray-400 italic mt-0.5">Sujeto a la fecha real de arribo y cierre de marea</div>`;
    }
  } else if (item.estado === 'DISPONIBLE_NO_CONFIRMADA') {
    html += `<div class="text-xs text-amber-200/95 mt-1 font-medium">El observador no confirmó la disponibilidad</div>`;
  } else if (item.estado === 'DESIGNADA') {
    if (item.detalle) {
      html += `<div class="text-xs text-gray-100 font-medium mt-1">${item.detalle}</div>`;
    }
    html += `<div class="text-[10px] text-emerald-300/80 mt-0.5 italic">Asignación prevista aún no confirmada</div>`;
  } else if (item.estado === 'NOVEDAD' && (item.codigoCorto === 'NO_DISP' || item.codigoCorto === 'NO DISPONIBLE' || item.codigoCorto === 'NO_DISPONIBLE')) {
    if (item.detalle) {
      html += `<div class="text-xs text-gray-100 mt-0.5">${item.detalle}</div>`;
    }
  } else if (item.estado === 'IMPEDIMENTO') {
    if (item.detalle && item.detalle !== 'IMPEDIMENTO') {
      html += `<div class="text-xs text-red-200 mt-0.5">${item.detalle}</div>`;
    }
  } else if (item.estado !== 'DISPONIBLE' && item.detalle && item.detalle !== titulo) {
    html += `<div class="text-xs text-gray-200 mt-0.5">${item.detalle}</div>`;
  }

  if (item.flexible) {
    html += `<div class="mt-2 inline-block px-2 py-0.5 rounded bg-amber-500/20 text-amber-200 border border-amber-400/40 text-[10px] font-bold">` +
            `⚡ Permite cancelación anticipada por urgencia</div>`;
  }

  return html;
};

export const getNovedadLabel = (codigoCorto?: string): string => {
  if (!codigoCorto) return 'NOVEDAD';
  const clean = codigoCorto.trim().toUpperCase();

  switch (clean) {
    case 'NO_DISP':
    case 'NO DISP':
    case 'NO_DISPONIBLE':
    case 'NO DISPONIBLE':
      return 'NO DISPONIBLE';
    case 'FC':
      return 'FRANCO';
    case 'LICEN':
    case 'LICENCIA':
      return 'LICENCIA';
    case 'ENFERMEDAD':
      return 'ENFERMEDAD';
    case 'RP':
      return 'RAZONES PART.';
    case 'MATERNIDAD':
      return 'MATERNIDAD';
    case 'NACIMIENTO':
      return 'NACIMIENTO';
    case 'FALLECIMIENTO':
      return 'DUELO';
    case 'EXAMEN':
      return 'EXAMEN';
    case 'DONACION_SANGRE':
      return 'DONACIÓN SANGRE';
    case 'VIAJE_INICIO':
    case 'VIAJE_FIN':
    case 'TRANSITO_INICIO':
    case 'TRANSITO_FIN':
      return 'EN VIAJE';
    default:
      return clean.replace(/_/g, ' ');
  }
};

export const getBloqueLabel = (item: ObservadorDisponibilidadItem): string => {
  if (item.codigoCorto === 'NO DISP. (EST.)') {
    return 'NO DISP. (EST.)';
  }

  switch (item.estado) {
    case 'DISPONIBLE':
      return 'DISPONIBLE';
    case 'DISPONIBLE_NO_CONFIRMADA':
      return '¿DISPONIBLE?';
    case 'DESIGNADA':
      return 'DESIGNADA';
    case 'NAVEGANDO':
      return 'NAVEGANDO';
    case 'IMPEDIMENTO':
      return 'IMPEDIMENTO';
    case 'PUERTO':
      return 'EN PUERTO';
    case 'VIAJE':
      return 'EN VIAJE';
    case 'ESPERANDO_ZARPADA':
      return 'ESP. ZARPADA';
    case 'CONFLICTO':
      return 'CONFLICTO';
    case 'NOVEDAD':
      return getNovedadLabel(item.codigoCorto);
    default:
      return (item.codigoCorto || String(item.estado || '')).replace(/_/g, ' ');
  }
};

export const getItemVisClass = (item: ObservadorDisponibilidadItem): string => {
  let baseClass = 'vis-item-default';

  if (item.estado === 'NAVEGANDO') {
    if (item.estadoSecundario === 'PROYECTADA') {
      baseClass = 'vis-item-navegando-proyectada';
    } else if (item.estadoSecundario === 'VIAJE') {
      baseClass = 'vis-item-naveg-viaje';
    } else {
      baseClass = 'vis-item-navegando';
    }
  } else if (item.codigoCorto === 'NO DISP. (EST.)' || (item.estadoSecundario === 'PROYECTADA' && item.estado === 'NOVEDAD')) {
    baseClass = 'vis-item-no-disponible-proyectada';
  } else if (item.estado === 'DISPONIBLE') {
    baseClass = 'vis-item-disponible';
  } else if (item.estado === 'DISPONIBLE_NO_CONFIRMADA') {
    baseClass = 'vis-item-disponible-no-confirmada';
  } else if (item.estado === 'IMPEDIMENTO') {
    baseClass = 'vis-item-impedido';
  } else if (item.estado === 'DESIGNADA') {
    baseClass = 'vis-item-designada';
  } else if (item.estado === 'PUERTO') {
    baseClass = 'vis-item-puerto';
  } else if (item.estado === 'ESPERANDO_ZARPADA') {
    baseClass = 'vis-item-ez';
  } else if (item.estado === 'VIAJE') {
    baseClass = 'vis-item-viaje';
  } else if (item.estado === 'NOVEDAD') {
    const cod = (item.codigoCorto || '').toUpperCase();
    if (cod === 'NO DISPONIBLE' || cod === 'NO_DISP' || cod === 'NO_DISPONIBLE') {
      baseClass = 'vis-item-no-disponible';
    } else {
      baseClass = 'vis-item-novedad';
    }
  } else if (item.estado === 'CONFLICTO') {
    baseClass = 'vis-item-conflicto';
  }

  if (item.flexible) {
    baseClass += ' vis-item-flexible';
  }

  if (item.isPast) {
    baseClass += ' vis-item-attenuated';
  }

  return baseClass;
};
