import { EstadosMareaService } from './estados-marea.service';
import { CreateEstadoMareaDto, UpdateEstadoMareaDto } from './dto';
export declare class EstadosMareaController {
    private readonly estadosMareaService;
    constructor(estadosMareaService: EstadosMareaService);
    crear(createEstadoMareaDto: CreateEstadoMareaDto): Promise<{
        id: string;
        activo: boolean;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        categoria: string;
        orden: number;
        esInicial: boolean;
        esFinal: boolean;
        permiteCargaArchivos: boolean;
        permiteCorreccion: boolean;
        permiteInforme: boolean;
        mostrarEnPanel: boolean;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        activo: boolean;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        categoria: string;
        orden: number;
        esInicial: boolean;
        esFinal: boolean;
        permiteCargaArchivos: boolean;
        permiteCorreccion: boolean;
        permiteInforme: boolean;
        mostrarEnPanel: boolean;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
        activo: boolean;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        categoria: string;
        orden: number;
        esInicial: boolean;
        esFinal: boolean;
        permiteCargaArchivos: boolean;
        permiteCorreccion: boolean;
        permiteInforme: boolean;
        mostrarEnPanel: boolean;
    }>;
    actualizar(id: string, updateEstadoMareaDto: UpdateEstadoMareaDto): Promise<{
        id: string;
        activo: boolean;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        categoria: string;
        orden: number;
        esInicial: boolean;
        esFinal: boolean;
        permiteCargaArchivos: boolean;
        permiteCorreccion: boolean;
        permiteInforme: boolean;
        mostrarEnPanel: boolean;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
}
