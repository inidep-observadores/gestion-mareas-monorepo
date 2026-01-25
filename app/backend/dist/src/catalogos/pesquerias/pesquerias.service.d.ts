import { PrismaService } from '../../prisma/prisma.service';
import { CreatePesqueriaDto, UpdatePesqueriaDto } from './dto';
export declare class PesqueriasService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    crear(createPesqueriaDto: CreatePesqueriaDto): Promise<{
        id: string;
        codigo: string;
        nombre: string;
        descripcion: string | null;
        orden: number | null;
        activo: boolean;
        grupo: string | null;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        codigo: string;
        nombre: string;
        descripcion: string | null;
        orden: number | null;
        activo: boolean;
        grupo: string | null;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
        codigo: string;
        nombre: string;
        descripcion: string | null;
        orden: number | null;
        activo: boolean;
        grupo: string | null;
    }>;
    actualizar(id: string, updatePesqueriaDto: UpdatePesqueriaDto): Promise<{
        id: string;
        codigo: string;
        nombre: string;
        descripcion: string | null;
        orden: number | null;
        activo: boolean;
        grupo: string | null;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
    private handleDBErrors;
}
