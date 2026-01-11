import { AlertsService } from './alerts.service';
import { CreateAlertDto } from './dto/create-alert.dto';
import { UpdateAlertDto } from './dto/update-alert.dto';
import { User } from '@prisma/client';
export declare class AlertsController {
    private readonly alertsService;
    constructor(alertsService: AlertsService);
    create(createAlertDto: CreateAlertDto, user: User): Promise<{
        id: string;
        codigoUnico: string;
        referenciaId: string | null;
        referenciaTipo: string | null;
        metadata: import("@prisma/client/runtime/client").JsonValue | null;
        tipo: string;
        titulo: string;
        descripcion: string;
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
            alertaId: string;
            fechaHora: Date;
            usuarioId: string | null;
            tipoEvento: string;
            detalle: string | null;
        })[];
    } & {
        id: string;
        codigoUnico: string;
        referenciaId: string | null;
        referenciaTipo: string | null;
        metadata: import("@prisma/client/runtime/client").JsonValue | null;
        tipo: string;
        titulo: string;
        descripcion: string;
        estado: string;
        prioridad: string;
        fechaDetectada: Date;
        fechaVencimiento: Date | null;
        fechaCierre: Date | null;
        asignadoId: string | null;
        creadoPorId: string | null;
        ultimaActualizacion: Date;
    }>;
    update(id: string, updateAlertDto: UpdateAlertDto, user: User): Promise<{
        id: string;
        codigoUnico: string;
        referenciaId: string | null;
        referenciaTipo: string | null;
        metadata: import("@prisma/client/runtime/client").JsonValue | null;
        tipo: string;
        titulo: string;
        descripcion: string;
        estado: string;
        prioridad: string;
        fechaDetectada: Date;
        fechaVencimiento: Date | null;
        fechaCierre: Date | null;
        asignadoId: string | null;
        creadoPorId: string | null;
        ultimaActualizacion: Date;
    }>;
}
