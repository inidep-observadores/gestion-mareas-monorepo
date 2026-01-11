import { PrismaService } from '../../prisma/prisma.service';
import { CreateArtePescaDto, UpdateArtePescaDto } from './dto';
export declare class ArtesPescaService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    crear(createArtePescaDto: CreateArtePescaDto): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        codigoNumerico: number;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        codigoNumerico: number;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        codigoNumerico: number;
    }>;
    actualizar(id: string, updateArtePescaDto: UpdateArtePescaDto): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        codigoNumerico: number;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
    private handleDBErrors;
}
