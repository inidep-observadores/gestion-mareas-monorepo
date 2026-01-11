import { PrismaService } from '../../prisma/prisma.service';
import { CreateEstadoMareaDto, UpdateEstadoMareaDto } from './dto';
export declare class EstadosMareaService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    crear(createEstadoMareaDto: CreateEstadoMareaDto): Promise<{
        id: string;
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
        activo: boolean;
        mostrarEnPanel: boolean;
    }>;
    obtenerTodos(): Promise<{
        id: string;
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
        activo: boolean;
        mostrarEnPanel: boolean;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
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
        activo: boolean;
        mostrarEnPanel: boolean;
    }>;
    actualizar(id: string, updateEstadoMareaDto: UpdateEstadoMareaDto): Promise<{
        id: string;
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
        activo: boolean;
        mostrarEnPanel: boolean;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
    private handleDBErrors;
}
