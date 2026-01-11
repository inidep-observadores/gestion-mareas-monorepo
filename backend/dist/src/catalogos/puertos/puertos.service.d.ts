import { PrismaService } from '../../prisma/prisma.service';
import { CreatePuertoDto, UpdatePuertoDto } from './dto';
export declare class PuertosService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    crear(createPuertoDto: CreatePuertoDto): Promise<{
        id: string;
        activo: boolean;
        observaciones: string | null;
        codigoInterno: string | null;
        nombre: string;
        orden: number | null;
        provincia: string | null;
        pais: string | null;
        codigoExterno: string | null;
        esLocal: boolean;
        latitud: number | null;
        longitud: number | null;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        activo: boolean;
        observaciones: string | null;
        codigoInterno: string | null;
        nombre: string;
        orden: number | null;
        provincia: string | null;
        pais: string | null;
        codigoExterno: string | null;
        esLocal: boolean;
        latitud: number | null;
        longitud: number | null;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
        activo: boolean;
        observaciones: string | null;
        codigoInterno: string | null;
        nombre: string;
        orden: number | null;
        provincia: string | null;
        pais: string | null;
        codigoExterno: string | null;
        esLocal: boolean;
        latitud: number | null;
        longitud: number | null;
    }>;
    actualizar(id: string, updatePuertoDto: UpdatePuertoDto): Promise<{
        id: string;
        activo: boolean;
        observaciones: string | null;
        codigoInterno: string | null;
        nombre: string;
        orden: number | null;
        provincia: string | null;
        pais: string | null;
        codigoExterno: string | null;
        esLocal: boolean;
        latitud: number | null;
        longitud: number | null;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
}
