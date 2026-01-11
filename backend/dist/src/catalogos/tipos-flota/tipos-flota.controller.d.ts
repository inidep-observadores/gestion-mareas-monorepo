import { TiposFlotaService } from './tipos-flota.service';
import { CreateTipoFlotaDto, UpdateTipoFlotaDto } from './dto';
export declare class TiposFlotaController {
    private readonly tiposFlotaService;
    constructor(tiposFlotaService: TiposFlotaService);
    crear(createTipoFlotaDto: CreateTipoFlotaDto): Promise<{
        id: string;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        orden: number | null;
        activo: boolean;
        codigo_numerico: number;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        orden: number | null;
        activo: boolean;
        codigo_numerico: number;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        orden: number | null;
        activo: boolean;
        codigo_numerico: number;
    }>;
    actualizar(id: string, updateTipoFlotaDto: UpdateTipoFlotaDto): Promise<{
        id: string;
        descripcion: string | null;
        codigo: string;
        nombre: string;
        orden: number | null;
        activo: boolean;
        codigo_numerico: number;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
}
