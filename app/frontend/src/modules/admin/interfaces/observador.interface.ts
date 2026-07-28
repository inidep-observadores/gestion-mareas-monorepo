export interface Observador {
    id: string;
    codigoInterno: number;
    nombre: string;
    apellido: string;
    fotoUrl?: string;
    tipoObservador: string; // 'OBSERVADOR' | 'TECNICO'
    tipoContrato: string; // 'LEY MARCO' | '1109' | 'MONOTRIBUTISTA' | 'PLANTA PERMANENTE'
    sexo: 'Masculino' | 'Femenino';
    eventual: boolean;
    activo: boolean;
    disponible: boolean;
    email?: string;
    conImpedimento: boolean;
    motivoImpedimento?: string;
    dni?: string;
    cuil?: string;
    telefonoPrincipal?: string;
    observaciones?: string;
}
