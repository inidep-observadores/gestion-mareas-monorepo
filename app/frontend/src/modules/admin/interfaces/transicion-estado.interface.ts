export interface EstadoMareaResumen {
    id: string;
    codigo: string;
    nombre: string;
    categoria: string;
    orden: number;
}

export interface TransicionEstado {
    id: string;
    estadoOrigenId: string;
    estadoOrigen?: EstadoMareaResumen;
    estadoDestinoId: string;
    estadoDestino?: EstadoMareaResumen;
    accion: string;
    etiqueta: string;
    claseBoton?: string | null;
    requiereObs: boolean;
    mostrarEnPanel: boolean;
    activo: boolean;
}
