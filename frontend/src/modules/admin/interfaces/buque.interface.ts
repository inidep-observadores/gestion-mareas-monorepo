export interface TipoFlota {
    id: string;
    nombre: string;
    codigo: string;
}

export interface Puerto {
    id: string;
    nombre: string;
}

export interface Pesqueria {
    id: string;
    nombre: string;
    codigo: string;
}

export interface ArtePesca {
    id: string;
    nombre: string;
    codigo: string;
}

export interface Buque {
    id: string;
    nombreBuque: string;
    matricula: string;
    codigoInterno?: number | null;
    tipoFlotaId?: string | null;
    tipoFlota?: TipoFlota | null;
    arteHabitualId?: string | null;
    arteHabitual?: ArtePesca | null;
    pesqueriaHabitualId?: string | null;
    pesqueriaHabitual?: Pesqueria | null;
    diasMareaEstimada?: number | null;
    esloraM?: number | null;
    potenciaHp?: number | null;
    puertoBaseId?: string | null;
    puertoBase?: Puerto | null;
    empresaNombre?: string | null;
    empresaLocalidad?: string | null;
    empresaTelefono?: string | null;
    empresaFax?: string | null;
    empresaCorreoPrincipal?: string | null;
    empresaCorreoSecundario?: string | null;
    armadorNombre?: string | null;
    armadorTelefono?: string | null;
    agenciaMaritimaNombre?: string | null;
    activo: boolean;
    fechaAlta?: string | null;
    fechaBaja?: string | null;
    observaciones?: string | null;
}
