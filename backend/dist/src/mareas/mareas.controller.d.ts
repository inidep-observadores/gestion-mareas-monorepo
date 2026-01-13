import { MareasService } from './mareas.service';
import { User } from '@prisma/client';
import { CreateMareaDto } from './dto/create-marea.dto';
import { UpdateMareaDto } from './dto/update-marea.dto';
import { ClaimMareaDto } from './dto/claim-marea.dto';
export declare class MareasController {
    private readonly mareasService;
    constructor(mareasService: MareasService);
    sendClaim(dto: ClaimMareaDto, user: User): Promise<{
        success: boolean;
    }>;
    getDashboardOperativo(year?: string): Promise<{
        kpis: any[];
        items: any;
    }>;
    getDashboardKpis(year?: string): Promise<{
        flotaActiva: number;
        observadoresDisponibles: number;
        mareasDesignadas: number;
        listasParaProtocolizar: number;
        enRevision: number;
    }>;
    getInbox(year?: string): Promise<{
        alerts: any[];
        tasks: any[];
    }>;
    getFleetDistribution(year?: string): Promise<{
        total: number;
        distribution: {
            label: string;
            count: number;
            vessels: {
                mareaCode: string;
                status: string;
                name: string;
            }[];
        }[];
    }>;
    getWorkforceStatus(year?: string): Promise<{
        totalActivos: number;
        navegando: number;
        descanso: number;
        disponibles: number;
        impedidos: number;
        licencia: number;
        topDry: {
            id: string;
            name: string;
            days: number;
            lastArrival: string;
        }[];
        listNavegando: {
            id: string;
            name: string;
            days: number;
            vessel: string;
            startDate: string;
        }[];
        listDescanso: {
            id: string;
            name: string;
            days: number;
            lastArrival: string;
        }[];
        listDisponibles: {
            id: string;
            name: string;
            days: number;
            lastArrival: string;
        }[];
        listImpedidos: {
            id: string;
            name: string;
            motivo: string;
        }[];
    }>;
    getFatigueAlerts(year?: string): Promise<{
        id: string;
        name: string;
        days: number;
        lastArrival: Date | null;
        trips: {
            mareaCode: string;
            vessel: string;
            departure: Date;
            arrival: Date;
            inExecution: boolean;
            navigatedDays: number;
        }[];
    }[]>;
    getCriticalDelays(year?: string): Promise<any[]>;
    getReportDelays(year?: string): Promise<any[]>;
    getCalendarEvents(year?: string): Promise<any[]>;
    search(q: string): Promise<{
        id: string;
        title: string;
        subtitle: string;
        type: string;
    }[]>;
    findOne(id: string): Promise<{
        buque: {
            id: string;
            activo: boolean;
            nombreBuque: string;
            matricula: string;
            codigoInterno: number | null;
            tipoFlotaId: string | null;
            arteHabitualId: string | null;
            pesqueriaHabitualId: string | null;
            diasMareaEstimada: number | null;
            esloraM: import("@prisma/client/runtime/client").Decimal | null;
            potenciaHp: number | null;
            puertoBaseId: string | null;
            empresaNombre: string | null;
            empresaLocalidad: string | null;
            empresaTelefono: string | null;
            empresaFax: string | null;
            empresaCorreoPrincipal: string | null;
            empresaCorreoSecundario: string | null;
            armadorNombre: string | null;
            armadorTelefono: string | null;
            agenciaMaritimaNombre: string | null;
            fechaAlta: Date | null;
            fechaBaja: Date | null;
            observaciones: string | null;
        };
        estadoActual: {
            id: string;
            descripcion: string | null;
            codigo: string;
            nombre: string;
            categoria: string;
            orden: number;
            esInicial: boolean;
            esFinal: boolean;
            permiteCargaArchivos: boolean;
            permiteCorreccion: boolean;
            permiteInforme: boolean;
            activo: boolean;
            mostrarEnPanel: boolean;
        };
        archivos: ({
            movimientoOrigen: {
                id: string;
                fechaHora: Date;
                usuarioId: string | null;
                tipoEvento: string;
                detalle: string | null;
                mareaId: string;
                cantidadMuestrasOtolitos: number | null;
                comentarios: string | null;
                estadoDesdeId: string | null;
                estadoHastaId: string | null;
            };
            usuarioSubio: {
                id: string;
                email: string;
                password: string;
                fullName: string;
                isActive: boolean;
                roles: string[];
                themePreference: string;
                avatarUrl: string | null;
            };
        } & {
            id: string;
            descripcion: string | null;
            mareaId: string;
            fechaSubida: Date;
            movimientoOrigenId: string | null;
            tipoArchivo: string;
            formato: string | null;
            version: string | null;
            rutaArchivo: string;
            usuarioSubioId: string | null;
        })[];
        etapas: ({
            pesqueria: {
                id: string;
                descripcion: string | null;
                codigo: string;
                nombre: string;
                orden: number | null;
                activo: boolean;
                grupo: string | null;
            };
            observadores: ({
                observador: {
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
                };
            } & {
                id: string;
                etapaId: string;
                rol: string;
                esDesignado: boolean;
                observadorId: string;
            })[];
            puertoArribo: {
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
            };
            puertoZarpada: {
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
            };
        } & {
            id: string;
            observaciones: string | null;
            mareaId: string;
            nroEtapa: number;
            pesqueriaId: string | null;
            puertoZarpadaId: string | null;
            puertoArriboId: string | null;
            fechaZarpada: Date | null;
            fechaArribo: Date | null;
            tipoEtapa: string;
        })[];
        movimientos: ({
            usuario: {
                id: string;
                email: string;
                password: string;
                fullName: string;
                isActive: boolean;
                roles: string[];
                themePreference: string;
                avatarUrl: string | null;
            };
            estadoDesde: {
                id: string;
                descripcion: string | null;
                codigo: string;
                nombre: string;
                categoria: string;
                orden: number;
                esInicial: boolean;
                esFinal: boolean;
                permiteCargaArchivos: boolean;
                permiteCorreccion: boolean;
                permiteInforme: boolean;
                activo: boolean;
                mostrarEnPanel: boolean;
            };
            estadoHasta: {
                id: string;
                descripcion: string | null;
                codigo: string;
                nombre: string;
                categoria: string;
                orden: number;
                esInicial: boolean;
                esFinal: boolean;
                permiteCargaArchivos: boolean;
                permiteCorreccion: boolean;
                permiteInforme: boolean;
                activo: boolean;
                mostrarEnPanel: boolean;
            };
        } & {
            id: string;
            fechaHora: Date;
            usuarioId: string | null;
            tipoEvento: string;
            detalle: string | null;
            mareaId: string;
            cantidadMuestrasOtolitos: number | null;
            comentarios: string | null;
            estadoDesdeId: string | null;
            estadoHastaId: string | null;
        })[];
    } & {
        id: string;
        activo: boolean;
        observaciones: string | null;
        anioMarea: number;
        nroMarea: number;
        fechaZarpadaEstimada: Date | null;
        fechaInicioObservador: Date | null;
        fechaFinObservador: Date | null;
        diasZonaAustral: number | null;
        tipoCalculoZonaAustral: string;
        nroProtocolizacion: number | null;
        anioProtocolizacion: number | null;
        fechaProtocolizacion: Date | null;
        fechaCreacion: Date;
        fechaUltimaActualizacion: Date;
        tipoMarea: string;
        diasEstimados: number | null;
        buqueId: string;
        artePrincipalId: string | null;
        estadoActualId: string;
    }>;
    update(id: string, updateMareaDto: UpdateMareaDto): Promise<{
        buque: {
            id: string;
            activo: boolean;
            nombreBuque: string;
            matricula: string;
            codigoInterno: number | null;
            tipoFlotaId: string | null;
            arteHabitualId: string | null;
            pesqueriaHabitualId: string | null;
            diasMareaEstimada: number | null;
            esloraM: import("@prisma/client/runtime/client").Decimal | null;
            potenciaHp: number | null;
            puertoBaseId: string | null;
            empresaNombre: string | null;
            empresaLocalidad: string | null;
            empresaTelefono: string | null;
            empresaFax: string | null;
            empresaCorreoPrincipal: string | null;
            empresaCorreoSecundario: string | null;
            armadorNombre: string | null;
            armadorTelefono: string | null;
            agenciaMaritimaNombre: string | null;
            fechaAlta: Date | null;
            fechaBaja: Date | null;
            observaciones: string | null;
        };
        estadoActual: {
            id: string;
            descripcion: string | null;
            codigo: string;
            nombre: string;
            categoria: string;
            orden: number;
            esInicial: boolean;
            esFinal: boolean;
            permiteCargaArchivos: boolean;
            permiteCorreccion: boolean;
            permiteInforme: boolean;
            activo: boolean;
            mostrarEnPanel: boolean;
        };
        archivos: ({
            movimientoOrigen: {
                id: string;
                fechaHora: Date;
                usuarioId: string | null;
                tipoEvento: string;
                detalle: string | null;
                mareaId: string;
                cantidadMuestrasOtolitos: number | null;
                comentarios: string | null;
                estadoDesdeId: string | null;
                estadoHastaId: string | null;
            };
            usuarioSubio: {
                id: string;
                email: string;
                password: string;
                fullName: string;
                isActive: boolean;
                roles: string[];
                themePreference: string;
                avatarUrl: string | null;
            };
        } & {
            id: string;
            descripcion: string | null;
            mareaId: string;
            fechaSubida: Date;
            movimientoOrigenId: string | null;
            tipoArchivo: string;
            formato: string | null;
            version: string | null;
            rutaArchivo: string;
            usuarioSubioId: string | null;
        })[];
        etapas: ({
            pesqueria: {
                id: string;
                descripcion: string | null;
                codigo: string;
                nombre: string;
                orden: number | null;
                activo: boolean;
                grupo: string | null;
            };
            observadores: ({
                observador: {
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
                };
            } & {
                id: string;
                etapaId: string;
                rol: string;
                esDesignado: boolean;
                observadorId: string;
            })[];
            puertoArribo: {
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
            };
            puertoZarpada: {
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
            };
        } & {
            id: string;
            observaciones: string | null;
            mareaId: string;
            nroEtapa: number;
            pesqueriaId: string | null;
            puertoZarpadaId: string | null;
            puertoArriboId: string | null;
            fechaZarpada: Date | null;
            fechaArribo: Date | null;
            tipoEtapa: string;
        })[];
        movimientos: ({
            usuario: {
                id: string;
                email: string;
                password: string;
                fullName: string;
                isActive: boolean;
                roles: string[];
                themePreference: string;
                avatarUrl: string | null;
            };
            estadoDesde: {
                id: string;
                descripcion: string | null;
                codigo: string;
                nombre: string;
                categoria: string;
                orden: number;
                esInicial: boolean;
                esFinal: boolean;
                permiteCargaArchivos: boolean;
                permiteCorreccion: boolean;
                permiteInforme: boolean;
                activo: boolean;
                mostrarEnPanel: boolean;
            };
            estadoHasta: {
                id: string;
                descripcion: string | null;
                codigo: string;
                nombre: string;
                categoria: string;
                orden: number;
                esInicial: boolean;
                esFinal: boolean;
                permiteCargaArchivos: boolean;
                permiteCorreccion: boolean;
                permiteInforme: boolean;
                activo: boolean;
                mostrarEnPanel: boolean;
            };
        } & {
            id: string;
            fechaHora: Date;
            usuarioId: string | null;
            tipoEvento: string;
            detalle: string | null;
            mareaId: string;
            cantidadMuestrasOtolitos: number | null;
            comentarios: string | null;
            estadoDesdeId: string | null;
            estadoHastaId: string | null;
        })[];
    } & {
        id: string;
        activo: boolean;
        observaciones: string | null;
        anioMarea: number;
        nroMarea: number;
        fechaZarpadaEstimada: Date | null;
        fechaInicioObservador: Date | null;
        fechaFinObservador: Date | null;
        diasZonaAustral: number | null;
        tipoCalculoZonaAustral: string;
        nroProtocolizacion: number | null;
        anioProtocolizacion: number | null;
        fechaProtocolizacion: Date | null;
        fechaCreacion: Date;
        fechaUltimaActualizacion: Date;
        tipoMarea: string;
        diasEstimados: number | null;
        buqueId: string;
        artePrincipalId: string | null;
        estadoActualId: string;
    }>;
    getMareaContext(id: string): Promise<{
        marea: {
            id: any;
            id_marea: string;
            buque_nombre: any;
            puertoBaseId: any;
            estado: any;
            estado_codigo: any;
            observador: string;
            pesqueria: any;
            fecha_zarpada: any;
            fecha_zarpada_estimada: any;
            fechaInicioObservador: any;
            fecha_fin_observador: any;
            dias_marea: number;
            dias_navegados: number;
            alertas: any[];
            etapas: any;
        };
        actions: Record<string, any>;
        lastEvents: any;
        etapas: any;
    }>;
    executeAction(id: string, actionKey: string, user: User, payload: any): Promise<{
        marea: {
            id: any;
            id_marea: string;
            buque_nombre: any;
            puertoBaseId: any;
            estado: any;
            estado_codigo: any;
            observador: string;
            pesqueria: any;
            fecha_zarpada: any;
            fecha_zarpada_estimada: any;
            fechaInicioObservador: any;
            fecha_fin_observador: any;
            dias_marea: number;
            dias_navegados: number;
            alertas: any[];
            etapas: any;
        };
        actions: Record<string, any>;
        lastEvents: any;
        etapas: any;
    } | ({
        estadoActual: {
            id: string;
            descripcion: string | null;
            codigo: string;
            nombre: string;
            categoria: string;
            orden: number;
            esInicial: boolean;
            esFinal: boolean;
            permiteCargaArchivos: boolean;
            permiteCorreccion: boolean;
            permiteInforme: boolean;
            activo: boolean;
            mostrarEnPanel: boolean;
        };
    } & {
        id: string;
        activo: boolean;
        observaciones: string | null;
        anioMarea: number;
        nroMarea: number;
        fechaZarpadaEstimada: Date | null;
        fechaInicioObservador: Date | null;
        fechaFinObservador: Date | null;
        diasZonaAustral: number | null;
        tipoCalculoZonaAustral: string;
        nroProtocolizacion: number | null;
        anioProtocolizacion: number | null;
        fechaProtocolizacion: Date | null;
        fechaCreacion: Date;
        fechaUltimaActualizacion: Date;
        tipoMarea: string;
        diasEstimados: number | null;
        buqueId: string;
        artePrincipalId: string | null;
        estadoActualId: string;
    })>;
    createMarea(createMareaDto: CreateMareaDto, user: User): Promise<{
        id: string;
        activo: boolean;
        observaciones: string | null;
        anioMarea: number;
        nroMarea: number;
        fechaZarpadaEstimada: Date | null;
        fechaInicioObservador: Date | null;
        fechaFinObservador: Date | null;
        diasZonaAustral: number | null;
        tipoCalculoZonaAustral: string;
        nroProtocolizacion: number | null;
        anioProtocolizacion: number | null;
        fechaProtocolizacion: Date | null;
        fechaCreacion: Date;
        fechaUltimaActualizacion: Date;
        tipoMarea: string;
        diasEstimados: number | null;
        buqueId: string;
        artePrincipalId: string | null;
        estadoActualId: string;
    }>;
}
