// Fuente de verdad para Tipo de Observador
export const TIPO_OBSERVADOR_MAP = {
    'OBSERVADOR': 'Observador',
    'TECNICO': 'Técnico',
} as const;

// Fuente de verdad para Tipo de Contrato
export const TIPO_CONTRATO_MAP = {
    'LEY MARCO': 'Ley Marco',
    '1109': 'Decreto 1109',
    'MONOTRIBUTISTA': 'Monotributista',
    'PLANTA PERMANENTE': 'Planta Permanente',
} as const;

// Derivados para Selects
export const TIPO_OBSERVADOR = Object.entries(TIPO_OBSERVADOR_MAP).map(([id, name]) => ({ id, name }));
export const TIPO_CONTRATO = Object.entries(TIPO_CONTRATO_MAP).map(([id, name]) => ({ id, name }));

// Derivados para Labels (compatibilidad)
export const TIPO_OBSERVADOR_LABELS: Record<string, string> = TIPO_OBSERVADOR_MAP;
export const TIPO_CONTRATO_LABELS: Record<string, string> = TIPO_CONTRATO_MAP;

// Fuente de verdad para Sexo
export const SEXO_MAP = {
    'Masculino': 'Masculino',
    'Femenino': 'Femenino',
} as const;

export const SEXO = Object.entries(SEXO_MAP).map(([id, name]) => ({ id, name }));
export const SEXO_LABELS: Record<string, string> = SEXO_MAP;
