import type { Observador } from '../interfaces/observador.interface';
import { normalizeToLocalStartOfDay, formatDateUI, formatDateTimeUI } from '@/utils/date.utils';

export type EstadoDocumentacion = 'sin_datos' | 'al_dia' | 'por_vencer' | 'vencido';

export interface DocumentacionStatus {
    estado: EstadoDocumentacion;
    color: 'gray' | 'green' | 'yellow' | 'red';
    tieneIcono: boolean;
    diasMinimos: number | null;
    diasCedula: number | null;
    diasApto: number | null;
    tooltipText: string;
    detalles: {
        cedula: {
            numero: number | null;
            vencimiento: string | null;
            dias: number | null;
            vencido: boolean;
        };
        aptoMedico: {
            vencimiento: string | null;
            dias: number | null;
            vencido: boolean;
        };
        ultimaActualizacion: string | null;
    };
}

/**
 * Calcula los días de diferencia entre la fecha actual y la fecha de vencimiento.
 * Si la fecha de vencimiento es hoy, devuelve 0.
 * Si ya venció en el pasado, devuelve un valor negativo.
 */
export const calcularDiasRestantes = (fechaStr?: string | Date | null): number | null => {
    if (!fechaStr) return null;
    const target = normalizeToLocalStartOfDay(fechaStr);
    if (!target) return null;
    const today = normalizeToLocalStartOfDay(new Date())!;

    const diffMs = target.getTime() - today.getTime();
    return Math.round(diffMs / (1000 * 60 * 60 * 24));
};

/**
 * Evalúa la documentación de embarque del observador:
 * - Sin información: Gris (sin cédula ni fechas registradas)
 * - Vencimiento < 30 días o ya vencido: Rojo
 * - Vencimiento < 60 días (2 meses) y >= 30 días: Amarillo
 * - Vencimiento >= 60 días: Al día (Verde / Sin alerta)
 */
export const calcularEstadoDocumentacion = (observador?: Partial<Observador> | null): DocumentacionStatus => {
    if (!observador) {
        return {
            estado: 'sin_datos',
            color: 'gray',
            tieneIcono: true,
            diasMinimos: null,
            diasCedula: null,
            diasApto: null,
            tooltipText: 'Documentación de embarque: Sin registrar',
            detalles: {
                cedula: { numero: null, vencimiento: null, dias: null, vencido: false },
                aptoMedico: { vencimiento: null, dias: null, vencido: false },
                ultimaActualizacion: null
            }
        };
    }

    const { numeroCedula, vencimientoCedula, vencimientoAptoMedico, fechaActualizacionDocumentacion } = observador;

    const tieneAlgundato = numeroCedula != null || !!vencimientoCedula || !!vencimientoAptoMedico;

    const diasCedula = calcularDiasRestantes(vencimientoCedula);
    const diasApto = calcularDiasRestantes(vencimientoAptoMedico);

    // Si no tiene ningún dato o le falta tanto la cédula como las fechas
    if (!tieneAlgundato || (diasCedula === null && diasApto === null)) {
        return {
            estado: 'sin_datos',
            color: 'gray',
            tieneIcono: true,
            diasMinimos: null,
            diasCedula,
            diasApto,
            tooltipText: 'Documentación de embarque no registrada',
            detalles: {
                cedula: {
                    numero: numeroCedula ?? null,
                    vencimiento: vencimientoCedula ? formatDateUI(vencimientoCedula) : null,
                    dias: diasCedula,
                    vencido: diasCedula !== null && diasCedula < 0
                },
                aptoMedico: {
                    vencimiento: vencimientoAptoMedico ? formatDateUI(vencimientoAptoMedico) : null,
                    dias: diasApto,
                    vencido: diasApto !== null && diasApto < 0
                },
                ultimaActualizacion: fechaActualizacionDocumentacion ? formatDateTimeUI(fechaActualizacionDocumentacion) : null
            }
        };
    }

    // Calcular días mínimos entre los documentos con fecha
    const diasDisponibles = [diasCedula, diasApto].filter((d): d is number => d !== null);
    const diasMinimos = diasDisponibles.length > 0 ? Math.min(...diasDisponibles) : null;

    let estado: EstadoDocumentacion = 'al_dia';
    let color: 'gray' | 'green' | 'yellow' | 'red' = 'green';

    if (diasMinimos === null) {
        estado = 'sin_datos';
        color = 'gray';
    } else if (diasMinimos < 30) {
        estado = 'vencido';
        color = 'red';
    } else if (diasMinimos < 60) {
        estado = 'por_vencer';
        color = 'yellow';
    } else {
        estado = 'al_dia';
        color = 'green';
    }

    // Armar tooltip descriptivo y estructurado
    const lineasTooltip: string[] = [];
    
    // Título de estado
    if (estado === 'vencido') {
        if (diasMinimos !== null && diasMinimos < 0) {
            lineasTooltip.push('⚠️ Documentación VENCIDA');
        } else {
            lineasTooltip.push(`⚠️ Documentación con vencimiento crítico (${diasMinimos} días)`);
        }
    } else if (estado === 'por_vencer') {
        lineasTooltip.push(`⚠️ Documentación próxima a vencer (${diasMinimos} días)`);
    } else if (estado === 'al_dia') {
        lineasTooltip.push('✓ Documentación de embarque al día');
    } else {
        lineasTooltip.push('ℹ Documentación incompleta o sin registrar');
    }

    // Cédula
    const textoNumCedula = numeroCedula ? `Nº ${numeroCedula}` : 'Sin número';
    if (vencimientoCedula) {
        const fechaCedulaFmt = formatDateUI(vencimientoCedula);
        let avisoCedula = '';
        if (diasCedula !== null) {
            if (diasCedula < 0) avisoCedula = ` (Vencida hace ${Math.abs(diasCedula)} días)`;
            else if (diasCedula === 0) avisoCedula = ' (Vence hoy)';
            else avisoCedula = ` (Vence en ${diasCedula} días)`;
        }
        lineasTooltip.push(`• Cédula: ${textoNumCedula} - Vto: ${fechaCedulaFmt}${avisoCedula}`);
    } else {
        lineasTooltip.push(`• Cédula: ${textoNumCedula} - Sin fecha de vencimiento`);
    }

    // Apto médico
    if (vencimientoAptoMedico) {
        const fechaAptoFmt = formatDateUI(vencimientoAptoMedico);
        let avisoApto = '';
        if (diasApto !== null) {
            if (diasApto < 0) avisoApto = ` (Vencido hace ${Math.abs(diasApto)} días)`;
            else if (diasApto === 0) avisoApto = ' (Vence hoy)';
            else avisoApto = ` (Vence en ${diasApto} días)`;
        }
        lineasTooltip.push(`• Apto Médico: Vto: ${fechaAptoFmt}${avisoApto}`);
    } else {
        lineasTooltip.push('• Apto Médico: Sin registrar');
    }

    // Última actualización
    if (fechaActualizacionDocumentacion) {
        lineasTooltip.push(`Última actualización: ${formatDateTimeUI(fechaActualizacionDocumentacion)}`);
    }

    return {
        estado,
        color,
        tieneIcono: true,
        diasMinimos,
        diasCedula,
        diasApto,
        tooltipText: lineasTooltip.join('\n'),
        detalles: {
            cedula: {
                numero: numeroCedula ?? null,
                vencimiento: vencimientoCedula ? formatDateUI(vencimientoCedula) : null,
                dias: diasCedula,
                vencido: diasCedula !== null && diasCedula < 0
            },
            aptoMedico: {
                vencimiento: vencimientoAptoMedico ? formatDateUI(vencimientoAptoMedico) : null,
                dias: diasApto,
                vencido: diasApto !== null && diasApto < 0
            },
            ultimaActualizacion: fechaActualizacionDocumentacion ? formatDateTimeUI(fechaActualizacionDocumentacion) : null
        }
    };
};
