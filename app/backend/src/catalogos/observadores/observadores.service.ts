import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import * as ExcelJS from 'exceljs';
import { MareaEstado, TipoEtapa, TipoMarea } from '../../mareas/mareas.constants';
import { DateUtils } from '../../common/utils/date.utils';
import { MareaUtils } from '../../common/utils/marea.utils';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';

@Injectable()
export class ObservadoresService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createObservadorDto: CreateObservadorDto) {
        if (createObservadorDto.disponible && createObservadorDto.conImpedimento) {
            throw new BadRequestException('Un observador no puede estar disponible y tener impedimento al mismo tiempo');
        }

        if (createObservadorDto.conImpedimento === false) {
            createObservadorDto.motivoImpedimento = null;
        }

        // Si el email viene vacío o solo con espacios, ponerlo como null
        if (createObservadorDto.email && createObservadorDto.email.trim() === '') {
            createObservadorDto.email = null;
        } else if (createObservadorDto.email === '') {
            createObservadorDto.email = null;
        }

        // Validar unicidad de número de cédula si viene provisto
        if (createObservadorDto.numeroCedula != null) {
            const existenteCedula = await this.prisma.observador.findUnique({
                where: { numeroCedula: createObservadorDto.numeroCedula }
            });
            if (existenteCedula) {
                throw new BadRequestException(`Ya existe un observador registrado con el número de cédula ${createObservadorDto.numeroCedula} (${existenteCedula.apellido}, ${existenteCedula.nombre})`);
            }
        }

        const data: any = { ...createObservadorDto };

        // Convertir strings de fecha a Date si vienen definidos
        if (data.vencimientoCedula) {
            data.vencimientoCedula = DateUtils.parseToAppZone(data.vencimientoCedula);
        }
        if (data.vencimientoAptoMedico) {
            data.vencimientoAptoMedico = DateUtils.parseToAppZone(data.vencimientoAptoMedico);
        }

        // Si se ingresó al menos un dato de documentación de embarque, registrar fecha de actualización
        if (data.numeroCedula != null || data.vencimientoCedula != null || data.vencimientoAptoMedico != null) {
            data.fechaActualizacionDocumentacion = DateUtils.getNow(true);
        }

        return await this.prisma.observador.create({
            data,
        });
    }

    async obtenerTodos(soloDisponibles: boolean = false, incluirInactivos: boolean = false) {
        try {
            const where: any = {};

            if (!incluirInactivos) {
                where.activo = true;
            }

            if (soloDisponibles) {
                where.activo = true; // Si pide solo disponibles, implícitamente solo activos
                // 1. Sin impedimento
                where.conImpedimento = false;

                // 2. No asignado a ninguna marea DESIGNADA activa
                where.mareasAsignadas = {
                    none: {
                        activo: true,
                        estadoActual: {
                            codigo: MareaEstado.DESIGNADA
                        }
                    }
                };
            }

            return await this.prisma.observador.findMany({
                where,
                orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
            });
        } catch (error) {
            console.error(error);
            throw new InternalServerErrorException('Error al obtener observadores');
        }
    }

    async exportToExcel(searchQuery?: string) {
        const where: any = {};

        if (searchQuery) {
            const query = searchQuery.toLowerCase().trim();
            where.OR = [
                { nombre: { contains: query, mode: 'insensitive' } },
                { apellido: { contains: query, mode: 'insensitive' } },
                { email: { contains: query, mode: 'insensitive' } },
                { motivoImpedimento: { contains: query, mode: 'insensitive' } },
            ];

            if (!isNaN(Number(query))) {
                where.OR.push({ codigoInterno: Number(query) });
                where.OR.push({ numeroCedula: Number(query) });
            }
        }

        const observadores = await this.prisma.observador.findMany({
            where,
            orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
        });

        const workbook = new ExcelJS.Workbook();
        const sheet = workbook.addWorksheet('Observadores');

        sheet.columns = [
            { header: 'CÓDIGO', key: 'codigoInterno', width: 10 },
            { header: 'APELLIDO', key: 'apellido', width: 20 },
            { header: 'NOMBRE', key: 'nombre', width: 20 },
            { header: 'DNI', key: 'dni', width: 15 },
            { header: 'CUIL', key: 'cuil', width: 20 },
            { header: 'TIPO', key: 'tipoObservador', width: 15 },
            { header: 'CONTRATO', key: 'tipoContrato', width: 20 },
            { header: 'ACTIVO', key: 'activo', width: 10 },
            { header: 'DISPONIBLE', key: 'disponible', width: 12 },
            { header: 'IMPEDIMENTO', key: 'conImpedimento', width: 12 },
            { header: 'MOTIVO IMPEDIMENTO', key: 'motivoImpedimento', width: 30 },
            { header: 'EMAIL', key: 'email', width: 25 },
            { header: 'TELÉFONO', key: 'telefonoPrincipal', width: 20 },
            { header: 'Nº CÉDULA', key: 'numeroCedula', width: 15 },
            { header: 'VTO. CÉDULA', key: 'vencimientoCedula', width: 15 },
            { header: 'VTO. APTO MÉDICO', key: 'vencimientoAptoMedico', width: 18 },
            { header: 'ACT. DOCUMENTACIÓN', key: 'fechaActualizacionDocumentacion', width: 20 },
            { header: 'OBSERVACIONES', key: 'observaciones', width: 40 },
        ];

        sheet.getRow(1).font = { bold: true };
        sheet.getRow(1).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FFE0E0E0' }
        };

        observadores.forEach(obs => {
            sheet.addRow({
                codigoInterno: obs.codigoInterno,
                apellido: obs.apellido,
                nombre: obs.nombre,
                dni: obs.dni || '-',
                cuil: obs.cuil || '-',
                tipoObservador: obs.tipoObservador,
                tipoContrato: obs.tipoContrato,
                activo: obs.activo ? 'SÍ' : 'NO',
                disponible: obs.disponible ? 'SÍ' : 'NO',
                conImpedimento: obs.conImpedimento ? 'SÍ' : 'NO',
                motivoImpedimento: obs.motivoImpedimento || '-',
                email: obs.email || '-',
                telefonoPrincipal: obs.telefonoPrincipal || '-',
                numeroCedula: obs.numeroCedula != null ? obs.numeroCedula : '-',
                vencimientoCedula: obs.vencimientoCedula ? DateUtils.formatDate(obs.vencimientoCedula) : '-',
                vencimientoAptoMedico: obs.vencimientoAptoMedico ? DateUtils.formatDate(obs.vencimientoAptoMedico) : '-',
                fechaActualizacionDocumentacion: obs.fechaActualizacionDocumentacion ? DateUtils.formatDateTime(obs.fechaActualizacionDocumentacion) : '-',
                observaciones: obs.observaciones || '-',
            });
        });

        return workbook;
    }

    async obtenerUno(id: string) {
        const observador = await this.prisma.observador.findUnique({
            where: { id },
            include: { pesquerias: true }
        });

        if (!observador) {
            throw new NotFoundException(`Observador con ID ${id} no encontrado`);
        }

        return observador;
    }

    async actualizar(id: string, updateObservadorDto: UpdateObservadorDto) {
        const observador = await this.obtenerUno(id);

        if (updateObservadorDto.disponible && updateObservadorDto.conImpedimento) {
            throw new BadRequestException('Un observador no puede estar disponible y tener impedimento al mismo tiempo');
        }

        if (updateObservadorDto.conImpedimento === false) {
            updateObservadorDto.motivoImpedimento = null;
        }

        // Si el email viene vacío o solo con espacios, ponerlo como null
        if (updateObservadorDto.email !== undefined) {
            if (updateObservadorDto.email === null || updateObservadorDto.email.trim() === '') {
                updateObservadorDto.email = null;
            }
        }

        const data: any = { ...updateObservadorDto };

        // Convertir fechas a Date o null
        if (data.vencimientoCedula !== undefined) {
            data.vencimientoCedula = data.vencimientoCedula ? DateUtils.parseToAppZone(data.vencimientoCedula) : null;
        }
        if (data.vencimientoAptoMedico !== undefined) {
            data.vencimientoAptoMedico = data.vencimientoAptoMedico ? DateUtils.parseToAppZone(data.vencimientoAptoMedico) : null;
        }

        // Detectar si hubo cambios en los datos de documentación de embarque
        let docCambiada = false;

        if (data.numeroCedula !== undefined) {
            const actualNum = observador.numeroCedula;
            const nuevoNum = data.numeroCedula;
            if (actualNum !== nuevoNum) {
                docCambiada = true;
                if (nuevoNum != null) {
                    const existenteCedula = await this.prisma.observador.findUnique({
                        where: { numeroCedula: nuevoNum }
                    });
                    if (existenteCedula && existenteCedula.id !== observador.id) {
                        throw new BadRequestException(`Ya existe otro observador registrado con el número de cédula ${nuevoNum} (${existenteCedula.apellido}, ${existenteCedula.nombre})`);
                    }
                }
            }
        }

        if (data.vencimientoCedula !== undefined) {
            const actualDate = observador.vencimientoCedula ? new Date(observador.vencimientoCedula).toISOString().split('T')[0] : null;
            const nuevaDate = data.vencimientoCedula ? new Date(data.vencimientoCedula).toISOString().split('T')[0] : null;
            if (actualDate !== nuevaDate) docCambiada = true;
        }

        if (data.vencimientoAptoMedico !== undefined) {
            const actualDate = observador.vencimientoAptoMedico ? new Date(observador.vencimientoAptoMedico).toISOString().split('T')[0] : null;
            const nuevaDate = data.vencimientoAptoMedico ? new Date(data.vencimientoAptoMedico).toISOString().split('T')[0] : null;
            if (actualDate !== nuevaDate) docCambiada = true;
        }

        if (docCambiada) {
            data.fechaActualizacionDocumentacion = DateUtils.getNow(true);
        }

        return await this.prisma.observador.update({
            where: { id: observador.id },
            data,
        });
    }

    async eliminar(id: string) {
        const observador = await this.obtenerUno(id);
        await this.prisma.observador.delete({
            where: { id: observador.id },
        });
        return { mensaje: 'Observador eliminado correctamente' };
    }

    async obtenerHistorial(id: string, operationalYear: number) {
        const fetchAll = operationalYear === 0;
        let dateFilter: any[] = [];

        if (!fetchAll) {
            const startYear = operationalYear - 1;
            const periodStart = new Date(startYear, 0, 1, 0, 0, 0, 0);
            const periodEnd = new Date(operationalYear, 11, 31, 23, 59, 59, 999);
            dateFilter = [
                {
                    OR: [
                        { anioMarea: { in: [operationalYear, startYear] } },
                        { fechaInicioObservador: { gte: periodStart, lte: periodEnd } },
                        { fechaFinObservador: { gte: periodStart, lte: periodEnd } },
                        { fechaFinObservador: null, fechaInicioObservador: { lte: periodEnd } }
                    ]
                }
            ];
        }

        // 1. Buscar todas las mareas donde el observador participa
        const mareasRaw = await this.prisma.marea.findMany({
            where: {
                activo: true,
                OR: [
                    { observadorPrincipalId: id },
                    {
                        etapas: {
                            some: {
                                observadores: { some: { observadorId: id } }
                            }
                        }
                    }
                ],
                AND: dateFilter
            },
            include: {
                buque: {
                    include: {
                        tipoFlota: true
                    }
                },
                estadoActual: true,
                pesqueria: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        observadores: true
                    }
                }
            } as any,
            orderBy: { fechaInicioObservador: 'asc' }
        });

        const now = DateUtils.getNow(true);
        const currentYear = now.getFullYear();
        const timeline: any[] = [];

        // Procesar viajes
        const trips = mareasRaw.map(m => {
            const mRaw = m as any;
            const start = mRaw.fechaInicioObservador || mRaw.fechaZarpadaEstimada;
            if (!start) return null;

            const isNavegando = mRaw.estadoActual.codigo === MareaEstado.EN_EJECUCION;
            const isDesignada = mRaw.estadoActual.codigo === MareaEstado.DESIGNADA;

            // Determinar fin: Preferir fechaFinObservador si es futura, sino basarse en etapas o estado actual
            let finRaw = mRaw.fechaFinObservador;

            // Si la marea está en ejecución, el final es 'ahora' a menos que haya una fecha de fin futuro (planificada)
            if (isNavegando) {
                if (!finRaw || finRaw < now) {
                    finRaw = now;
                }
            } else if (!finRaw && mRaw.etapas.length > 0) {
                const arrivals = mRaw.etapas
                    .map((e: any) => e.fechaArribo ? new Date(e.fechaArribo).getTime() : null)
                    .filter(Boolean);
                if (arrivals.length > 0) {
                    finRaw = new Date(Math.max(...(arrivals as number[])));
                }
            }

            const end = finRaw || (isNavegando ? now : start);

            // Días totales (rango de vinculación a la marea)
            // Si es DESIGNADA, son 0 días.
            // Si no, usamos 'end' calculado para evitar que calculateInclusiveDays use 'now' por defecto al recibir null.
            const totalDays = isDesignada ? 0 : DateUtils.calculateInclusiveDays(start, end);

            // Días navegados (solo si estuvo en etapas)
            const isPrincipal = mRaw.observadorPrincipalId === id;
            const relevantStages = mRaw.etapas.filter((e: any) =>
                isPrincipal || e.observadores.some((o: any) => o.observadorId === id)
            );

            const navigatedDays = DateUtils.calculateUniqueDays(
                relevantStages.map((e: any) => ({
                    start: e.fechaZarpada,
                    end: e.fechaArribo || (isNavegando ? now : null)
                }))
            );

            return {
                id: mRaw.id,
                mareaCode: MareaUtils.formatCodigo(mRaw),
                vessel: mRaw.buque.nombreBuque,
                fishery: mRaw.pesqueria?.nombre,
                fleet: mRaw.buque.tipoFlota?.nombre,
                start,
                end,
                totalDays,
                navigatedDays,
                year: new Date(start).getFullYear(),
                isNavegando,
                ignoreStats: isDesignada // Flag para excluir del total anual
            };
        }).filter(Boolean);

        // 2. Buscar novedades aprobadas de disponibilidad y no disponibilidad
        let novedadDateFilter: any = {};
        if (!fetchAll) {
            const startYear = operationalYear - 1;
            const periodStart = new Date(startYear, 0, 1, 0, 0, 0, 0);
            const periodEnd = new Date(operationalYear, 11, 31, 23, 59, 59, 999);
            novedadDateFilter = {
                OR: [
                    {
                        fechaInicio: { lte: periodEnd },
                        OR: [
                            { fechaFin: { gte: periodStart } },
                            { fechaFin: null }
                        ]
                    },
                    {
                        fechaCreacion: { gte: periodStart, lte: periodEnd }
                    }
                ]
            };
        }

        const novedadesRaw = await this.prisma.observadorNovedad.findMany({
            where: {
                observadorId: id,
                activo: true,
                estadoAprobacion: { in: ['APROBADA', 'RECTIFICADA'] },
                tipoNovedad: {
                    codigo: { in: ['DISPONIBLE', 'NO_DISPONIBLE'] }
                },
                ...novedadDateFilter
            },
            include: {
                tipoNovedad: true,
                archivos: true,
                movimientos: {
                    include: {
                        usuario: { select: { id: true, email: true, fullName: true } }
                    },
                    orderBy: { fechaHora: 'desc' }
                },
                creadoPor: {
                    select: { id: true, email: true, fullName: true }
                }
            },
            orderBy: { fechaInicio: 'desc' }
        });

        const novedades = novedadesRaw.map(n => {
            const start = n.fechaInicio ? new Date(n.fechaInicio) : new Date(n.fechaCreacion);
            return {
                id: n.id,
                type: 'NOVEDAD',
                codigo: n.tipoNovedad.codigo,
                tipoNovedad: {
                    id: n.tipoNovedad.id,
                    codigo: n.tipoNovedad.codigo,
                    descripcion: n.tipoNovedad.descripcion
                },
                fechaRegistro: n.fechaCreacion,
                fechaCreacion: n.fechaCreacion,
                fechaInicio: n.fechaInicio,
                fechaFin: n.fechaFin,
                motivo: n.motivo,
                permiteUrgencia: n.permiteUrgencia,
                estadoAprobacion: n.estadoAprobacion,
                origen: n.origen,
                metadata: n.metadata,
                archivos: n.archivos || [],
                movimientos: n.movimientos || [],
                creadoPor: n.creadoPor ? {
                    id: n.creadoPor.id,
                    fullName: n.creadoPor.fullName,
                    email: n.creadoPor.email
                } : null,
                start,
                orderDate: start.getTime(),
                year: start.getFullYear()
            };
        });

        // Construir Timeline con intercalado de tierra, novedades y cortes anuales
        const sortedTrips = trips.sort((a: any, b: any) => b.start.getTime() - a.start.getTime());
        const sortedNovedades = novedades.sort((a: any, b: any) => b.start.getTime() - a.start.getTime());
        const refDate = (fetchAll || operationalYear === currentYear) ? now : new Date(operationalYear, 11, 31, 23, 59, 59, 999);

        // Calcular para cada novedad los días hasta la marea inmediata posterior (más reciente en el tiempo) o hasta hoy
        sortedNovedades.forEach((nov: any) => {
            const novTime = nov.start.getTime();
            // Buscar la marea que zarpó inmediatamente después de esta novedad (es decir, con start > novTime)
            // sortedTrips está en orden descendente; la zarpada posterior más cercana es la que tiene start >= novTime con menor start
            const tripsAfterNov = sortedTrips.filter((t: any) => t.start.getTime() >= novTime);
            const nextTrip = tripsAfterNov.length > 0 ? tripsAfterNov[tripsAfterNov.length - 1] : null;

            if (nov.codigo === 'DISPONIBLE') {
                const esFutura = nov.start.getTime() > refDate.getTime();
                nov.esFutura = esFutura;

                if (esFutura) {
                    const diasParaInicio = DateUtils.calculateInclusiveDays(refDate, nov.start) - 1;
                    nov.diasParaInicio = Math.max(0, diasParaInicio);
                    nov.diasHastaSiguienteMarea = undefined;
                    nov.tieneMareaPosterior = false;
                } else if (nextTrip) {
                    const days = DateUtils.calculateInclusiveDays(nov.start, nextTrip.start) - 1;
                    nov.diasHastaSiguienteMarea = Math.max(0, days);
                    nov.tieneMareaPosterior = true;
                } else {
                    const days = DateUtils.calculateInclusiveDays(nov.start, refDate);
                    nov.diasHastaSiguienteMarea = Math.max(0, days);
                    nov.tieneMareaPosterior = false;
                }
            } else if (nov.codigo === 'NO_DISPONIBLE') {
                if (nov.fechaInicio && nov.fechaFin) {
                    nov.diasNoDisponible = DateUtils.calculateInclusiveDays(nov.fechaInicio, nov.fechaFin);
                }
            }
        });

        let years: number[] = [];
        if (fetchAll) {
            const allYears = new Set<number>();
            sortedTrips.forEach((t: any) => allYears.add(t.end.getFullYear()));
            sortedNovedades.forEach((n: any) => allYears.add(n.year));
            allYears.add(currentYear); // Asegurarse de tener el año actual para mostrar el tiempo en tierra
            years = Array.from(allYears).sort((a, b) => b - a);
        } else {
            years = [operationalYear, operationalYear - 1].sort((a, b) => b - a);
        }

        let tripIdx = 0;

        // Helper para evaluar disponibilidad en un intervalo de descanso en tierra [desde, hasta]
        const evaluarDisponibilidadEnTierra = (desde: Date, hasta: Date, mareaSiguienteStart: Date | null) => {
            const desdeTime = desde.getTime();
            const hastaTime = hasta.getTime();

            // Buscar si hubo alguna novedad DISPONIBLE en el rango [desde, hasta]
            const dispEnRango = sortedNovedades.find((n: any) => 
                n.codigo === 'DISPONIBLE' && 
                n.estadoAprobacion === 'APROBADA' &&
                n.start.getTime() >= desdeTime && 
                n.start.getTime() <= hastaTime
            );

            if (dispEnRango) {
                const limiteFin = mareaSiguienteStart || hasta;
                const diasDisp = DateUtils.calculateInclusiveDays(dispEnRango.start, limiteFin) - (mareaSiguienteStart ? 1 : 0);
                return {
                    diasDisponible: Math.max(0, diasDisp),
                    sinAvisoDisponibilidad: false,
                    avisoFuturo: false,
                    fechaAvisoFuturo: null
                };
            }

            // Si no hubo disponibilidad en el rango, verificar si existe un aviso futuro registrado posterior a este intervalo
            // (pero previo a la siguiente zarpada, si la hubiera)
            const dispFutura = sortedNovedades.find((n: any) =>
                n.codigo === 'DISPONIBLE' &&
                n.estadoAprobacion === 'APROBADA' &&
                n.start.getTime() > hastaTime &&
                (!mareaSiguienteStart || n.start.getTime() <= mareaSiguienteStart.getTime())
            );

            if (dispFutura) {
                return {
                    diasDisponible: null,
                    sinAvisoDisponibilidad: false,
                    avisoFuturo: true,
                    fechaAvisoFuturo: dispFutura.start
                };
            }

            return {
                diasDisponible: null,
                sinAvisoDisponibilidad: true,
                avisoFuturo: false,
                fechaAvisoFuturo: null
            };
        };

        for (const y of years) {
            // 1. Agregar el total del año
            timeline.push({
                type: 'YEAR_TOTAL',
                year: y,
                totalDays: this.calculateYearTotal(trips, y)
            });

            // Novedades para este año
            const novedadesYear = sortedNovedades.filter((n: any) => n.year === y);
            let novIdx = 0;

            // 2. Tierra actual (solo en el año operacional actual o si traemos todo y es el primer año)
            if ((fetchAll && y === currentYear && tripIdx === 0) || (!fetchAll && y === operationalYear && tripIdx === 0)) {
                const firstTrip = sortedTrips[0];

                // Insertar novedades que ocurrieron después del inicio del primer viaje (o si no hay viajes)
                while (novIdx < novedadesYear.length && (!firstTrip || novedadesYear[novIdx].start.getTime() >= firstTrip.start.getTime())) {
                    timeline.push(novedadesYear[novIdx++]);
                }

                if (firstTrip && !firstTrip.isNavegando) {
                    const diffTierraActual = DateUtils.calculateInclusiveDays(firstTrip.end, refDate) - 1;
                    if (diffTierraActual > 0) {
                        const evalDisp = evaluarDisponibilidadEnTierra(firstTrip.end, refDate, null);
                        timeline.push({
                            type: 'LAND',
                            days: diffTierraActual,
                            start: firstTrip.end,
                            end: refDate,
                            isCurrent: true,
                            diasDisponible: evalDisp.diasDisponible,
                            sinAvisoDisponibilidad: evalDisp.sinAvisoDisponibilidad,
                            avisoFuturo: evalDisp.avisoFuturo,
                            fechaAvisoFuturo: evalDisp.fechaAvisoFuturo
                        });
                    }
                }
            }

            // 3. Agregar viajes que pertenecen a este año (terminan en y) intercalados con novedades y tierra
            while (tripIdx < sortedTrips.length) {
                const trip = sortedTrips[tripIdx];
                const displayYear = trip.end.getFullYear();

                if (displayYear < y) break; // Pertenece a un bloque anual posterior (más viejo)

                // Novedades antes de este viaje (más recientes que trip.start) que aún no se hayan insertado
                while (novIdx < novedadesYear.length && novedadesYear[novIdx].start.getTime() >= trip.start.getTime()) {
                    timeline.push(novedadesYear[novIdx++]);
                }

                timeline.push({
                    type: 'TRIP',
                    ...trip
                });

                const nextTrip = tripIdx + 1 < sortedTrips.length ? sortedTrips[tripIdx + 1] : null;

                // Novedades que caen entre este viaje y el siguiente (o en adelante)
                while (novIdx < novedadesYear.length && (!nextTrip || novedadesYear[novIdx].start.getTime() >= nextTrip.start.getTime())) {
                    timeline.push(novedadesYear[novIdx++]);
                }

                // Intercalado de tierra con el siguiente viaje (de cara al pasado)
                if (nextTrip) {
                    const diffTierra = DateUtils.calculateInclusiveDays(nextTrip.end, trip.start) - 2;
                    if (diffTierra > 0) {
                        const evalDisp = evaluarDisponibilidadEnTierra(nextTrip.end, trip.start, trip.start);
                        timeline.push({
                            type: 'LAND',
                            days: diffTierra,
                            start: nextTrip.end,
                            end: trip.start,
                            diasDisponible: evalDisp.diasDisponible,
                            sinAvisoDisponibilidad: evalDisp.sinAvisoDisponibilidad,
                            avisoFuturo: evalDisp.avisoFuturo,
                            fechaAvisoFuturo: evalDisp.fechaAvisoFuturo
                        });
                    }
                }

                tripIdx++;
            }

            // Si quedan novedades de este año posteriores a todos los viajes del año, agregarlas
            while (novIdx < novedadesYear.length) {
                timeline.push(novedadesYear[novIdx++]);
            }
        }

        return timeline;
    }

    private calculateYearTotal(trips: any[], year: number): number {
        return trips.reduce((acc, trip) => {
            if (trip.ignoreStats) return acc;
            return acc + DateUtils.calculateDaysInYear(trip.start, trip.end, year);
        }, 0);
    }

    async obtenerArchivos(id: string) {
        const novedades = await this.prisma.observadorNovedad.findMany({
            where: { observadorId: id },
            include: {
                archivos: true,
                tipoNovedad: true
            },
            orderBy: {
                fechaCreacion: 'desc'
            }
        });

        const archivos = novedades.flatMap(n => 
            n.archivos.map(a => ({
                id: a.id,
                novedadId: n.id,
                tipoNovedad: n.tipoNovedad?.descripcion || 'Desconocido',
                tipoNovedadCodigo: n.tipoNovedad?.codigo,
                fechaNovedad: n.fechaInicio,
                fechaRecepcion: n.fechaCreacion,
                fechaSubida: a.fechaSubida,
                rutaArchivo: a.rutaArchivo,
                tipoArchivo: a.tipoArchivo,
                nombreOriginal: a.nombreOriginal || 'Archivo adjunto'
            }))
        );

        archivos.sort((a, b) => {
            const timeA = a.fechaRecepcion ? new Date(a.fechaRecepcion).getTime() : 0;
            const timeB = b.fechaRecepcion ? new Date(b.fechaRecepcion).getTime() : 0;
            return timeB - timeA;
        });

        return archivos;
    }

    async getArchivoDriveId(archivoId: string): Promise<string> {
        const archivo = await this.prisma.observadorNovedadArchivo.findUnique({
            where: { id: archivoId }
        });

        if (!archivo) {
            throw new Error(`Archivo ${archivoId} no encontrado`);
        }

        if (!archivo.driveFileId) {
            throw new Error(`El archivo ${archivoId} no tiene un ID de Google Drive asociado`);
        }

        return archivo.driveFileId;
    }
}
