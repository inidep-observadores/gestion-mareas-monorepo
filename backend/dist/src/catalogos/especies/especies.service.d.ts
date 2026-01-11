import { PrismaService } from '../../prisma/prisma.service';
import { CreateEspecieDto, UpdateEspecieDto } from './dto';
export declare class EspeciesService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    crear(createEspecieDto: CreateEspecieDto): Promise<{
        id: string;
        codigo: string;
        activo: boolean;
        observaciones: string | null;
        nombreCientifico: string;
        nombreVulgar: string;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        codigo: string;
        activo: boolean;
        observaciones: string | null;
        nombreCientifico: string;
        nombreVulgar: string;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
        codigo: string;
        activo: boolean;
        observaciones: string | null;
        nombreCientifico: string;
        nombreVulgar: string;
    }>;
    actualizar(id: string, updateEspecieDto: UpdateEspecieDto): Promise<{
        id: string;
        codigo: string;
        activo: boolean;
        observaciones: string | null;
        nombreCientifico: string;
        nombreVulgar: string;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
    private handleDBErrors;
}
