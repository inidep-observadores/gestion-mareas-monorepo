import { PrismaService } from '../prisma/prisma.service';
import { CreateAlertDto } from './dto/create-alert.dto';
import { UpdateAlertDto } from './dto/update-alert.dto';
export declare class AlertsService {
    private prisma;
    private readonly logger;
    constructor(prisma: PrismaService);
    create(createAlertDto: CreateAlertDto, user?: any): Promise<{
        id: string;
        descripcion: string;
        metadata: import("@prisma/client/runtime/client").JsonValue | null;
        codigoUnico: string;
        referenciaId: string | null;
        referenciaTipo: string | null;
        tipo: string;
        titulo: string;
        estado: string;
        prioridad: string;
        fechaDetectada: Date;
        fechaVencimiento: Date | null;
        fechaCierre: Date | null;
        asignadoId: string | null;
        creadoPorId: string | null;
        ultimaActualizacion: Date;
    }>;
    findAll(query: any): Promise<any[]>;
    findOne(id: string): Promise<{
        asignadoA: {
            id: string;
            email: string;
            password: string;
            fullName: string;
            isActive: boolean;
            roles: string[];
            themePreference: string;
            avatarUrl: string | null;
        };
        eventos: ({
            usuario: {
                fullName: string;
            };
        } & {
            id: string;
            fechaHora: Date;
            usuarioId: string | null;
            tipoEvento: string;
            detalle: string | null;
            alertaId: string;
        })[];
    } & {
        id: string;
        descripcion: string;
        metadata: import("@prisma/client/runtime/client").JsonValue | null;
        codigoUnico: string;
        referenciaId: string | null;
        referenciaTipo: string | null;
        tipo: string;
        titulo: string;
        estado: string;
        prioridad: string;
        fechaDetectada: Date;
        fechaVencimiento: Date | null;
        fechaCierre: Date | null;
        asignadoId: string | null;
        creadoPorId: string | null;
        ultimaActualizacion: Date;
    }>;
    update(id: string, updateAlertDto: UpdateAlertDto, user: any): Promise<{
        id: string;
        descripcion: string;
        metadata: import("@prisma/client/runtime/client").JsonValue | null;
        codigoUnico: string;
        referenciaId: string | null;
        referenciaTipo: string | null;
        tipo: string;
        titulo: string;
        estado: string;
        prioridad: string;
        fechaDetectada: Date;
        fechaVencimiento: Date | null;
        fechaCierre: Date | null;
        asignadoId: string | null;
        creadoPorId: string | null;
        ultimaActualizacion: Date;
    }>;
    private extractNotaGestion;
    logEvent(alertaId: string, tipo: string, detalle: string, userId?: string): Promise<{
        id: string;
        fechaHora: Date;
        usuarioId: string | null;
        tipoEvento: string;
        detalle: string | null;
        alertaId: string;
    }>;
}
