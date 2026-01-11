import { ObservadoresService } from './observadores.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';
export declare class ObservadoresController {
    private readonly observadoresService;
    constructor(observadoresService: ObservadoresService);
    crear(createObservadorDto: CreateObservadorDto): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        codigoInterno: number;
        observaciones: string | null;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        conImpedimento: boolean;
        email: string | null;
        motivoImpedimento: string | null;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        codigoInterno: number;
        observaciones: string | null;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        conImpedimento: boolean;
        email: string | null;
        motivoImpedimento: string | null;
    }[]>;
    obtenerUno(id: string): Promise<{
        pesquerias: {
            id: string;
            activo: boolean;
            especieId: string;
            pesqueriaId: string;
            observadorId: string;
            modo: string;
            motivo: string | null;
            fechaDesde: Date | null;
            fechaHasta: Date | null;
        }[];
    } & {
        id: string;
        nombre: string;
        activo: boolean;
        codigoInterno: number;
        observaciones: string | null;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        conImpedimento: boolean;
        email: string | null;
        motivoImpedimento: string | null;
    }>;
    actualizar(id: string, updateObservadorDto: UpdateObservadorDto): Promise<{
        id: string;
        nombre: string;
        activo: boolean;
        codigoInterno: number;
        observaciones: string | null;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        conImpedimento: boolean;
        email: string | null;
        motivoImpedimento: string | null;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
}
