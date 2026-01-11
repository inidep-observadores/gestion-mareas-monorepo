import { ArtesPescaService } from './artes-pesca.service';
import { CreateArtePescaDto, UpdateArtePescaDto } from './dto';
export declare class ArtesPescaController {
    private readonly artesPescaService;
    constructor(artesPescaService: ArtesPescaService);
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
}
