import { PrismaService } from '../../prisma/prisma.service';
import { CreatePesqueriaDto, UpdatePesqueriaDto } from './dto';
export declare class PesqueriasService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    crear(createPesqueriaDto: CreatePesqueriaDto): Promise<{
        id: string;
        activo: boolean;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        orden: number | null;
        grupo: string | null;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        activo: boolean;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        orden: number | null;
        grupo: string | null;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
        activo: boolean;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        orden: number | null;
        grupo: string | null;
    }>;
    actualizar(id: string, updatePesqueriaDto: UpdatePesqueriaDto): Promise<{
        id: string;
        activo: boolean;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        orden: number | null;
        grupo: string | null;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
    private handleDBErrors;
}
