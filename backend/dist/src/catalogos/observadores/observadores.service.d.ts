import { PrismaService } from '../../prisma/prisma.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';
export declare class ObservadoresService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    crear(createObservadorDto: CreateObservadorDto): Promise<{
        codigoInterno: number;
        nombre: string;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        activo: boolean;
        disponible: boolean;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
        email: string | null;
        fechaProximaDisponibilidad: Date | null;
        observaciones: string | null;
        id: string;
    }>;
    obtenerTodos(): Promise<{
        codigoInterno: number;
        nombre: string;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        activo: boolean;
        disponible: boolean;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
        email: string | null;
        fechaProximaDisponibilidad: Date | null;
        observaciones: string | null;
        id: string;
    }[]>;
    obtenerUno(id: string): Promise<{
        pesquerias: {
            activo: boolean;
            id: string;
            observadorId: string;
            pesqueriaId: string;
            modo: string;
            motivo: string | null;
            fechaDesde: Date | null;
            fechaHasta: Date | null;
            especieId: string;
        }[];
    } & {
        codigoInterno: number;
        nombre: string;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        activo: boolean;
        disponible: boolean;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
        email: string | null;
        fechaProximaDisponibilidad: Date | null;
        observaciones: string | null;
        id: string;
    }>;
    actualizar(id: string, updateObservadorDto: UpdateObservadorDto): Promise<{
        codigoInterno: number;
        nombre: string;
        apellido: string;
        fotoUrl: string | null;
        tipoObservador: string;
        tipoContrato: string;
        activo: boolean;
        disponible: boolean;
        conImpedimento: boolean;
        motivoImpedimento: string | null;
        email: string | null;
        fechaProximaDisponibilidad: Date | null;
        observaciones: string | null;
        id: string;
    }>;
    eliminar(id: string): Promise<{
        mensaje: string;
    }>;
}
