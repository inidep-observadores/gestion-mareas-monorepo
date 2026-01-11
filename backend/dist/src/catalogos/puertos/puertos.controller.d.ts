import { PuertosService } from './puertos.service';
import { CreatePuertoDto, UpdatePuertoDto } from './dto';
export declare class PuertosController {
    private readonly puertosService;
    constructor(puertosService: PuertosService);
    crear(createPuertoDto: CreatePuertoDto): Promise<{
        id: string;
        nombre: string;
        orden: number | null;
        activo: boolean;
        codigoInterno: string | null;
        observaciones: string | null;
        provincia: string | null;
        pais: string | null;
        codigoExterno: string | null;
        esLocal: boolean;
        latitud: number | null;
        longitud: number | null;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        nombre: string;
        orden: number | null;
        activo: boolean;
        codigoInterno: string | null;
        observaciones: string | null;
        provincia: string | null;
        pais: string | null;
        codigoExterno: string | null;
        esLocal: boolean;
        latitud: number | null;
        longitud: number | null;
    }[]>;
    obtenerUno(id: string): Promise<{
        id: string;
        nombre: string;
        orden: number | null;
        activo: boolean;
        codigoInterno: string | null;
        observaciones: string | null;
        provincia: string | null;
        pais: string | null;
        codigoExterno: string | null;
        esLocal: boolean;
        latitud: number | null;
        longitud: number | null;
    }>;
    actualizar(id: string, updatePuertoDto: UpdatePuertoDto): Promise<{
        id: string;
        nombre: string;
        orden: number | null;
        activo: boolean;
        codigoInterno: string | null;
        observaciones: string | null;
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
