import { PesqueriasService } from './pesquerias.service';
import { CreatePesqueriaDto, UpdatePesqueriaDto } from './dto';
export declare class PesqueriasController {
    private readonly pesqueriasService;
    constructor(pesqueriasService: PesqueriasService);
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
}
