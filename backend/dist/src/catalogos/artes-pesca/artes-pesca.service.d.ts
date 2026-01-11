import { PrismaService } from '../../prisma/prisma.service';
import { CreateArtePescaDto, UpdateArtePescaDto } from './dto';
export declare class ArtesPescaService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    crear(createArtePescaDto: CreateArtePescaDto): Promise<{
        id: string;
        activo: boolean;
        nombre: string;
        codigoNumerico: number;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        activo: boolean;
        nombre: string;
        codigoNumerico: number;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
        activo: boolean;
        nombre: string;
        codigoNumerico: number;
    }>;
    actualizar(id: string, updateArtePescaDto: UpdateArtePescaDto): Promise<{
        id: string;
        activo: boolean;
        nombre: string;
        codigoNumerico: number;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
    private handleDBErrors;
}
