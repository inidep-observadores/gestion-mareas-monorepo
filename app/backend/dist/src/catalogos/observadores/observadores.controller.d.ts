import { ObservadoresService } from './observadores.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';
export declare class ObservadoresController {
    private readonly observadoresService;
    constructor(observadoresService: ObservadoresService);
    crear(createObservadorDto: CreateObservadorDto): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        observaciones: string | null;
        email: string | null;
        codigoInterno: number;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
        fechaProximaDisponibilidad: Date | null;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        observaciones: string | null;
        email: string | null;
        codigoInterno: number;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
        fechaProximaDisponibilidad: Date | null;
    }[]>;
    obtenerUno(id: string): Promise<{
        pesquerias: {
            id: string;
            activo: boolean;
            pesqueriaId: string;
            observadorId: string;
            modo: string;
            motivo: string | null;
            fechaDesde: Date | null;
            fechaHasta: Date | null;
            especieId: string;
        }[];
    } & {
        id: string;
        nombre: string;
        activo: boolean;
        observaciones: string | null;
        email: string | null;
        codigoInterno: number;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
        fechaProximaDisponibilidad: Date | null;
    }>;
    actualizar(id: string, updateObservadorDto: UpdateObservadorDto): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        observaciones: string | null;
        email: string | null;
        codigoInterno: number;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
        fechaProximaDisponibilidad: Date | null;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
}
