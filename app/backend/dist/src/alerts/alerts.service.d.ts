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
        estado: import("@prisma/client").$Enums.AlertaEstado;
        codigoUnico: string;
        referenciaId: string | null;
        referenciaTipo: string | null;
        metadata: import("@prisma/client/runtime/client").JsonValue | null;
        tipo: string;
        titulo: string;
        prioridad: import("@prisma/client").$Enums.AlertaPrioridad;
        fechaVencimiento: Date | null;
        asignadoId: string | null;
        visible: boolean;
        fechaDetectada: Date;
        fechaCierre: Date | null;
        creadoPorId: string | null;
        ultimaActualizacion: Date;
    }>;
    findAll(query: any): Promise<any[]>;
    findOne(id: string): Promise<{
        asignadoA: {
            id: string;
            roles: string[];
            email: string;
            password: string;
            fullName: string;
            isActive: boolean;
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
            tipoEvento: string;
            detalle: string | null;
            alertaId: string;
            usuarioId: string | null;
        })[];
    } & {
        id: string;
        descripcion: string;
        estado: import("@prisma/client").$Enums.AlertaEstado;
        codigoUnico: string;
        referenciaId: string | null;
        referenciaTipo: string | null;
        metadata: import("@prisma/client/runtime/client").JsonValue | null;
        tipo: string;
        titulo: string;
        prioridad: import("@prisma/client").$Enums.AlertaPrioridad;
        fechaVencimiento: Date | null;
        asignadoId: string | null;
        visible: boolean;
        fechaDetectada: Date;
        fechaCierre: Date | null;
        creadoPorId: string | null;
        ultimaActualizacion: Date;
    }>;
    update(id: string, updateAlertDto: UpdateAlertDto, user: any): Promise<{
        id: string;
        descripcion: string;
        estado: import("@prisma/client").$Enums.AlertaEstado;
        codigoUnico: string;
        referenciaId: string | null;
        referenciaTipo: string | null;
        metadata: import("@prisma/client/runtime/client").JsonValue | null;
        tipo: string;
        titulo: string;
        prioridad: import("@prisma/client").$Enums.AlertaPrioridad;
        fechaVencimiento: Date | null;
        asignadoId: string | null;
        visible: boolean;
        fechaDetectada: Date;
        fechaCierre: Date | null;
        creadoPorId: string | null;
        ultimaActualizacion: Date;
    }>;
    private extractNotaGestion;
    logEvent(alertaId: string, tipo: string, detalle: string, userId?: string): Promise<{
        id: string;
        fechaHora: Date;
        tipoEvento: string;
        detalle: string | null;
        alertaId: string;
        usuarioId: string | null;
    }>;
}
