export interface Observador {
    id: string;
    codigoInterno: number;
    nombre: string;
    apellido: string;
    fotoUrl?: string;
    tipoObservador: string; // 'OBSERVADOR' | 'TECNICO'
    tipoContrato: string; // 'LEY MARCO' | 'MONOTRIBUTISTA' | 'PLANTA PERMANENTE'
    activo: boolean;
    disponible: boolean;
    fechaProximaDisponibilidad?: string;
    observaciones?: string;
}
