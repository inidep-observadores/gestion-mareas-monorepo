export interface Observador {
    id: string;
    codigoInterno: number;
    nombre: string;
    apellido: string;
    fotoUrl?: string;
    tipoObservador: string; // 'OBSERVADOR' | 'TECNICO'
    tipoContrato: string; // 'LEY MARCO' | '1109' | 'MONOTRIBUTISTA' | 'PLANTA PERMANENTE'
    activo: boolean;
    disponible: boolean;
    email?: string;
    conImpedimento: boolean;
    motivoImpedimento?: string;
    fechaProximaDisponibilidad?: string;
    observaciones?: string;
}
