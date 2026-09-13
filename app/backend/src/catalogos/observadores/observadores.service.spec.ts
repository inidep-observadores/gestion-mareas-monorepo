import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { ObservadoresService } from './observadores.service';
import { PrismaService } from '../../prisma/prisma.service';
import { BadRequestException, NotFoundException } from '@nestjs/common';

describe('ObservadoresService', () => {
    let service: ObservadoresService;
    let prisma: PrismaService;

    const mockPrisma = {
        observador: {
            create: jest.fn(),
            findMany: jest.fn(),
            findUnique: jest.fn(),
            update: jest.fn(),
            delete: jest.fn(),
        },
        marea: {
            findMany: jest.fn(),
        }
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                ObservadoresService,
                { provide: PrismaService, useValue: mockPrisma },
            ],
        }).compile();

        service = module.get<ObservadoresService>(ObservadoresService);
        prisma = module.get<PrismaService>(PrismaService);
        jest.clearAllMocks();
    });

    describe('crear', () => {
        it('debería convertir un email vacío en null', async () => {
            const dto = {
                codigoInterno: 1,
                nombre: 'Juan',
                apellido: 'Perez',
                tipoObservador: 'OBSERVADOR',
                tipoContrato: 'LEY MARCO',
                email: '   ' // espacios en blanco
            } as any;

            mockPrisma.observador.create.mockResolvedValue({ id: 'uuid', ...dto });

            await service.crear(dto);

            expect(mockPrisma.observador.create).toHaveBeenCalledWith({
                data: expect.objectContaining({
                    email: null
                })
            });
        });

        it('debería lanzar error si está disponible y tiene impedimento', async () => {
            const dto = {
                disponible: true,
                conImpedimento: true,
            } as any;

            await expect(service.crear(dto)).rejects.toThrow(BadRequestException);
        });

        it('debería registrar fechaActualizacionDocumentacion al crear con datos de documentación', async () => {
            const dto = {
                codigoInterno: 10,
                nombre: 'Carlos',
                apellido: 'Gomez',
                tipoObservador: 'OBSERVADOR',
                tipoContrato: 'LEY MARCO',
                numeroCedula: 12345,
                vencimientoCedula: '2026-10-15',
                vencimientoAptoMedico: '2026-11-20'
            } as any;

            mockPrisma.observador.findUnique.mockResolvedValue(null);
            mockPrisma.observador.create.mockResolvedValue({ id: 'uuid-10', ...dto });

            await service.crear(dto);

            expect(mockPrisma.observador.create).toHaveBeenCalledWith({
                data: expect.objectContaining({
                    numeroCedula: 12345,
                    vencimientoCedula: expect.any(Date),
                    vencimientoAptoMedico: expect.any(Date),
                    fechaActualizacionDocumentacion: expect.any(Date)
                })
            });
        });

        it('debería lanzar BadRequestException al crear si la cédula ya existe', async () => {
            const dto = {
                codigoInterno: 10,
                nombre: 'Carlos',
                apellido: 'Gomez',
                tipoObservador: 'OBSERVADOR',
                tipoContrato: 'LEY MARCO',
                numeroCedula: 12345,
            } as any;

            mockPrisma.observador.findUnique.mockResolvedValue({ id: 'uuid-otro', apellido: 'Perez', nombre: 'Juan' });

            await expect(service.crear(dto)).rejects.toThrow(BadRequestException);
        });
    });

    describe('actualizar', () => {
        it('debería convertir un email vacío en null al actualizar', async () => {
            const id = 'uuid-1';
            const dto = { email: '' };

            mockPrisma.observador.findUnique.mockResolvedValue({ id, email: 'viejo@test.com' });
            mockPrisma.observador.update.mockResolvedValue({ id, email: null });

            await service.actualizar(id, dto as any);

            expect(mockPrisma.observador.update).toHaveBeenCalledWith({
                where: { id },
                data: expect.objectContaining({
                    email: null
                })
            });
        });

        it('debería registrar fechaActualizacionDocumentacion si se actualiza la cédula o vencimientos', async () => {
            const id = 'uuid-2';
            const dto = { numeroCedula: 99999 };

            mockPrisma.observador.findUnique
                .mockResolvedValueOnce({ 
                    id, 
                    numeroCedula: 11111,
                    vencimientoCedula: null,
                    vencimientoAptoMedico: null 
                }) // para obtenerUno
                .mockResolvedValueOnce(null); // para validar unicidad de 99999
            mockPrisma.observador.update.mockResolvedValue({ id, numeroCedula: 99999 });

            await service.actualizar(id, dto as any);

            expect(mockPrisma.observador.update).toHaveBeenCalledWith({
                where: { id },
                data: expect.objectContaining({
                    numeroCedula: 99999,
                    fechaActualizacionDocumentacion: expect.any(Date)
                })
            });
        });

        it('debería lanzar BadRequestException si se intenta asignar una cédula ya existente a otro observador', async () => {
            const id = 'uuid-2';
            const dto = { numeroCedula: 88888 };

            mockPrisma.observador.findUnique
                .mockResolvedValueOnce({ id, numeroCedula: 11111 }) // obtenerUno
                .mockResolvedValueOnce({ id: 'uuid-otro', apellido: 'Gomez', nombre: 'Juan', numeroCedula: 88888 }); // check unicidad

            await expect(service.actualizar(id, dto as any)).rejects.toThrow(BadRequestException);
        });

        it('NO debería actualizar fechaActualizacionDocumentacion si los datos de documentación no cambiaron', async () => {
            const id = 'uuid-3';
            const dto = { telefonoPrincipal: '12345678' };

            mockPrisma.observador.findUnique.mockResolvedValue({ 
                id, 
                telefonoPrincipal: '000000',
                numeroCedula: 11111,
                vencimientoCedula: null,
                vencimientoAptoMedico: null 
            });
            mockPrisma.observador.update.mockResolvedValue({ id, telefonoPrincipal: '12345678' });

            await service.actualizar(id, dto as any);

            expect(mockPrisma.observador.update).toHaveBeenCalledWith({
                where: { id },
                data: expect.not.objectContaining({
                    fechaActualizacionDocumentacion: expect.anything()
                })
            });
        });

        it('debería lanzar NotFoundException si el observador no existe', async () => {
            mockPrisma.observador.findUnique.mockResolvedValue(null);
            await expect(service.actualizar('id-inexistente', {})).rejects.toThrow(NotFoundException);
        });
    });

    describe('obtenerHistorial', () => {
        // Importarlo dinamicamente o asumir que DateUtils está disponible.
        // Como DateUtils es static, podemos usar jest spyOn.
        const { DateUtils } = require('../../common/utils/date.utils');

        it('debería calcular correctamente si está navegando usando DateUtils.getNow', async () => {
            const obsId = 'obs1';
            const year = 2024;
            const fixedNow = new Date('2024-05-10T12:00:00Z');

            // Mockear DateUtils.getNow
            const getNowSpy = jest.spyOn(DateUtils, 'getNow').mockReturnValue(fixedNow);

            // Mock DB Response
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    fechaInicioObservador: new Date('2024-05-01T10:00:00Z'),
                    fechaZarpadaEstimada: new Date('2024-05-01T10:00:00Z'),
                    fechaFinObservador: null,
                    estadoActual: { codigo: 'EN_EJECUCION', nombre: 'En Ejecucion' },
                    buque: { nombreBuque: 'Buque 1' },
                    etapas: [
                        { fechaZarpada: new Date('2024-05-01T10:00:00Z'), fechaArribo: null, observadores: [{ observadorId: obsId }] }
                    ]
                }
            ]);

            const result = await service.obtenerHistorial(obsId, year);

            // Verificar que se llamó a getNow(true)
            expect(getNowSpy).toHaveBeenCalledWith(true);

            // Verificar que la marea en curso usa "fixedNow" como fecha de fin para cálculos
            const trip = result.find((t: any) => t.id === 'm1');
            expect(trip).toBeDefined();
            expect(trip.isNavegando).toBe(true);
            expect(trip.end).toEqual(fixedNow); // Debe cerrar con "ahora" para mostrar progreso

            getNowSpy.mockRestore();
        });

        it('debería retornar 0 días totales y no sumar al anual si la marea es DESIGNADA', async () => {
            const obsId = 'obs1';
            const year = 2024;
            const fixedNow = new Date('2024-05-10T12:00:00Z');

            // Mockear DateUtils.getNow
            const getNowSpy = jest.spyOn(DateUtils, 'getNow').mockReturnValue(fixedNow);

            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm_designada',
                    // Fechas que normalmente darían días (ej: inicio hace 5 días)
                    fechaInicioObservador: new Date('2024-05-05T10:00:00Z'),
                    fechaZarpadaEstimada: new Date('2024-05-05T10:00:00Z'),
                    fechaFinObservador: null, // Sin fin explícito
                    estadoActual: { codigo: 'DESIGNADA', nombre: 'Designada' },
                    buque: { nombreBuque: 'Buque Designado' },
                    etapas: []
                }
            ]);

            const result = await service.obtenerHistorial(obsId, year);

            // Verificar trip
            const trip = result.find((t: any) => t.id === 'm_designada');
            expect(trip).toBeDefined();
            expect(trip.totalDays).toBe(0); // Debe ser 0 forzado
            expect(trip.ignoreStats).toBe(true);

            // Verificar Total Anual
            const yearTotal = result.find((t: any) => t.type === 'YEAR_TOTAL' && t.year === 2024);
            expect(yearTotal).toBeDefined();
            expect(yearTotal.totalDays).toBe(0); // No debe haber sumado los 5 días teóricos

            getNowSpy.mockRestore();
        });
    });
});
