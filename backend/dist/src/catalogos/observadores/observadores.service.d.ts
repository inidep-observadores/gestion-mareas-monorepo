import { PrismaService } from '../../prisma/prisma.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';
export declare class ObservadoresService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    crear(createObservadorDto: CreateObservadorDto): Promise<{
        id: string;
        activo: boolean;
        observaciones: string | null;
        codigoInterno: number;
        nombre: string;
        email: string | null;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
    }>;
    obtenerTodos(): Promise<{
        id: string;
        activo: boolean;
        observaciones: string | null;
        codigoInterno: number;
        nombre: string;
        email: string | null;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
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
        activo: boolean;
        observaciones: string | null;
        codigoInterno: number;
        nombre: string;
        email: string | null;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
    }>;
    actualizar(id: string, updateObservadorDto: UpdateObservadorDto): Promise<{
        id: string;
        activo: boolean;
        observaciones: string | null;
        codigoInterno: number;
        nombre: string;
        email: string | null;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        disponible: boolean;
        fechaProximaDisponibilidad: Date | null;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
}
