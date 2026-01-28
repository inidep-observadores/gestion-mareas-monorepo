import { ObservadoresService } from './observadores.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';
export declare class ObservadoresController {
    private readonly observadoresService;
    constructor(observadoresService: ObservadoresService);
    crear(createObservadorDto: CreateObservadorDto): Promise<{
        id: string;
        codigoInterno: number;
        nombre: string;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        activo: boolean;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        observaciones: string | null;
        conImpedimento: boolean;
        email: string | null;
        motivoImpedimento: string | null;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        codigoInterno: number;
        nombre: string;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        activo: boolean;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        observaciones: string | null;
        conImpedimento: boolean;
        email: string | null;
        motivoImpedimento: string | null;
    }[]>;
    obtenerUno(id: string): Promise<{
        pesquerias: {
            id: string;
            activo: boolean;
            observadorId: string;
            pesqueriaId: string;
            modo: string;
            motivo: string | null;
            fechaDesde: Date | null;
            fechaHasta: Date | null;
            especieId: string;
        }[];
    } & {
        id: string;
        codigoInterno: number;
        nombre: string;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        activo: boolean;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        observaciones: string | null;
        conImpedimento: boolean;
        email: string | null;
        motivoImpedimento: string | null;
    }>;
    actualizar(id: string, updateObservadorDto: UpdateObservadorDto): Promise<{
        id: string;
        codigoInterno: number;
        nombre: string;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        activo: boolean;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        observaciones: string | null;
        conImpedimento: boolean;
        email: string | null;
        motivoImpedimento: string | null;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
}
