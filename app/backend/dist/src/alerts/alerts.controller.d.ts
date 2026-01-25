import { AlertsService } from './alerts.service';
import { CreateAlertDto } from './dto/create-alert.dto';
import { UpdateAlertDto } from './dto/update-alert.dto';
import { User } from '@prisma/client';
export declare class AlertsController {
    private readonly alertsService;
    constructor(alertsService: AlertsService);
    create(createAlertDto: CreateAlertDto, user: User): Promise<{
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
    update(id: string, updateAlertDto: UpdateAlertDto, user: User): Promise<{
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
}
