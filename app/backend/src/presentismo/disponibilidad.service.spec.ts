import { Test, TestingModule } from '@nestjs/testing';
import { DisponibilidadService } from './disponibilidad.service';
import { PrismaService } from '../prisma/prisma.service';

describe('DisponibilidadService', () => {
  let service: DisponibilidadService;
  let prisma: PrismaService;

  const mockPrismaService = {
    observador: {
      findMany: jest.fn(),
    },
    observadorNovedad: {
      findMany: jest.fn(),
    },
    marea: {
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DisponibilidadService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<DisponibilidadService>(DisponibilidadService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('debe estar definido', () => {
    expect(service).toBeDefined();
  });

  it('debe retornar DISPONIBLE_NO_CONFIRMADA para observador sin aviso documental de disponibilidad', async () => {
    mockPrismaService.observador.findMany.mockResolvedValue([
      {
        id: 'obs-1',
        nombre: 'Juan',
        apellido: 'Perez',
        codigoInterno: 101,
        tipoObservador: 'OBSERVADOR',
        tipoContrato: 'PLANTA PERMANENTE',
        conImpedimento: false,
        motivoImpedimento: null,
        disponible: true,
      },
    ]);

    mockPrismaService.observadorNovedad.findMany.mockResolvedValue([]);
    mockPrismaService.marea.findMany.mockResolvedValue([]);

    const result = await service.obtenerDisponibilidad(3);

    expect(result).toBeDefined();
    expect(result.observadores.length).toBe(1);
    const obs = result.observadores[0];
    expect(obs.eventos.length).toBeGreaterThan(0);
    const eventoNoConfirmado = obs.eventos.find(e => e.estado === 'DISPONIBLE_NO_CONFIRMADA');
    expect(eventoNoConfirmado).toBeDefined();
    expect(eventoNoConfirmado?.codigoCorto).toBe('¿DISPONIBLE?');
    expect(eventoNoConfirmado?.detalle).toContain('no confirmó la disponibilidad');
  });

  it('debe retornar DISPONIBLE confirmado cuando existe una novedad de aviso de disponibilidad activa', async () => {
    const today = new Date();
    const inicioAviso = new Date(today.getTime() - 2 * 24 * 60 * 60 * 1000); // Aviso desde hace 2 días

    mockPrismaService.observador.findMany.mockResolvedValue([
      {
        id: 'obs-2',
        nombre: 'Carlos',
        apellido: 'Gomez',
        codigoInterno: 102,
        tipoObservador: 'OBSERVADOR',
        tipoContrato: 'PLANTA PERMANENTE',
        conImpedimento: false,
        motivoImpedimento: null,
        disponible: true,
      },
    ]);

    mockPrismaService.observadorNovedad.findMany.mockResolvedValue([
      {
        id: 'nov-disp-activa',
        observadorId: 'obs-2',
        fechaInicio: inicioAviso,
        fechaFin: null,
        permiteUrgencia: false,
        motivo: 'Disponible',
        tipoNovedad: {
          codigo: 'DISPONIBLE',
          descripcion: 'Declaración de Disponibilidad',
          afectaPresentismo: false,
        },
      },
    ]);
    mockPrismaService.marea.findMany.mockResolvedValue([]);

    const result = await service.obtenerDisponibilidad(3);
    const obs = result.observadores[0];
    const eventoDisponible = obs.eventos.find(e => e.estado === 'DISPONIBLE');
    expect(eventoDisponible).toBeDefined();
    expect(eventoDisponible?.codigoCorto).toBe('DISPONIBLE');
    expect(eventoDisponible?.detalle).toBe('Disponible para embarque');
  });

  it('debe filtrar en Prisma los observadores con impedimento o no disponibles', async () => {
    mockPrismaService.observador.findMany.mockResolvedValue([]);
    mockPrismaService.observadorNovedad.findMany.mockResolvedValue([]);
    mockPrismaService.marea.findMany.mockResolvedValue([]);

    await service.obtenerDisponibilidad(3);

    expect(mockPrismaService.observador.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: {
          activo: true,
          conImpedimento: false,
          disponible: true,
        },
      })
    );
  });

  it('debe marcar como flexible una novedad de Franco Compensatorio (FC)', async () => {
    const today = new Date();
    const futureStart = new Date(today.getTime() + 5 * 24 * 60 * 60 * 1000);
    const futureEnd = new Date(today.getTime() + 8 * 24 * 60 * 60 * 1000);

    mockPrismaService.observador.findMany.mockResolvedValue([
      {
        id: 'obs-3',
        nombre: 'Maria',
        apellido: 'Lopez',
        codigoInterno: 103,
        tipoObservador: 'OBSERVADOR',
        tipoContrato: 'PLANTA PERMANENTE',
        conImpedimento: false,
        motivoImpedimento: null,
        disponible: true,
      },
    ]);

    mockPrismaService.observadorNovedad.findMany.mockResolvedValue([
      {
        id: 'nov-1',
        observadorId: 'obs-3',
        fechaInicio: futureStart,
        fechaFin: futureEnd,
        permiteUrgencia: false, // aunque sea false, por ser FC es flexible
        motivo: 'Franco Compensatorio',
        tipoNovedad: {
          codigo: 'FC',
          descripcion: 'Franco Compensatorio',
          afectaPresentismo: true,
        },
      },
    ]);
    mockPrismaService.marea.findMany.mockResolvedValue([]);

    const result = await service.obtenerDisponibilidad(3);
    const obs = result.observadores[0];
    const eventoFC = obs.eventos.find(e => e.codigoCorto === 'FC');
    expect(eventoFC).toBeDefined();
    expect(eventoFC?.flexible).toBe(true);
  });

  it('debe pintar como NO_DISP los días libres anteriores a un aviso de disponibilidad (DISPONIBLE)', async () => {
    const today = new Date();
    // Aviso de disponibilidad para dentro de 10 días
    const fechaAvisoDisp = new Date(today.getTime() + 10 * 24 * 60 * 60 * 1000);

    mockPrismaService.observador.findMany.mockResolvedValue([
      {
        id: 'obs-4',
        nombre: 'Pedro',
        apellido: 'Sanchez',
        codigoInterno: 104,
        tipoObservador: 'OBSERVADOR',
        tipoContrato: 'PLANTA PERMANENTE',
        conImpedimento: false,
        motivoImpedimento: null,
        disponible: true,
      },
    ]);

    mockPrismaService.observadorNovedad.findMany.mockResolvedValue([
      {
        id: 'nov-disp',
        observadorId: 'obs-4',
        fechaInicio: fechaAvisoDisp,
        fechaFin: null,
        permiteUrgencia: false,
        motivo: 'Disponible a partir del 10',
        tipoNovedad: {
          codigo: 'DISPONIBLE',
          descripcion: 'Declaración de Disponibilidad',
          afectaPresentismo: false,
        },
      },
    ]);
    mockPrismaService.marea.findMany.mockResolvedValue([]);

    const result = await service.obtenerDisponibilidad(1);
    const obs = result.observadores[0];
    
    // Debe existir un bloque NO DISPONIBLE antes de la fecha de disponibilidad
    const bloqueNoDisp = obs.eventos.find(e => e.codigoCorto === 'NO DISPONIBLE' || e.estado === 'NOVEDAD');
    expect(bloqueNoDisp).toBeDefined();
    expect(bloqueNoDisp?.detalle).toContain('aviso');

    // A partir de la fecha del aviso, debe existir el bloque DISPONIBLE
    const bloqueDisponible = obs.eventos.find(e => e.estado === 'DISPONIBLE');
    expect(bloqueDisponible).toBeDefined();
  });

  it('debe limitar el bloque de NAVEGANDO a la fecha estimada de arribo según diasEstimados', async () => {
    const today = new Date();
    // Marea que inicia hoy con 5 días estimados
    const mareaInicio = new Date(today.getTime());
    const diasEstimados = 5;

    mockPrismaService.observador.findMany.mockResolvedValue([
      {
        id: 'obs-5',
        nombre: 'Lucas',
        apellido: 'Diaz',
        codigoInterno: 105,
        tipoObservador: 'OBSERVADOR',
        tipoContrato: 'PLANTA PERMANENTE',
        conImpedimento: false,
        motivoImpedimento: null,
        disponible: true,
      },
    ]);

    mockPrismaService.observadorNovedad.findMany.mockResolvedValue([]);
    mockPrismaService.marea.findMany.mockResolvedValue([
      {
        id: 'marea-1',
        tipoMarea: 'MC',
        nroMarea: 99,
        anioMarea: 2026,
        diasEstimados,
        fechaInicioObservador: mareaInicio,
        fechaFinObservador: null,
        fechaZarpadaEstimada: mareaInicio,
        observadorPrincipalId: 'obs-5',
        estadoActual: { codigo: 'EN_EJECUCION' },
        etapas: [
          {
            id: 'etapa-1',
            nroEtapa: 1,
            fechaZarpada: mareaInicio,
            fechaArribo: null, // Sin arribo real
            puertoZarpada: { id: 'p1', esLocal: true },
            puertoArribo: null,
            observadores: [{ observadorId: 'obs-5' }],
          },
        ],
      },
    ]);

    const result = await service.obtenerDisponibilidad(1);
    const obs = result.observadores[0];

    // 1. Debe haber un bloque de NAVEGANDO
    const eventoNavegando = obs.eventos.find(e => e.estado === 'NAVEGANDO');
    expect(eventoNavegando).toBeDefined();

    // 2. Debe haber un bloque posterior de ¿DISPONIBLE? (no confirmada) para los días siguientes
    const eventoDisponiblePosterior = obs.eventos.find(e => e.estado === 'DISPONIBLE_NO_CONFIRMADA');
    expect(eventoDisponiblePosterior).toBeDefined();
    expect(eventoDisponiblePosterior?.codigoCorto).toBe('¿DISPONIBLE?');
  });

  it('debe generar un bloque de DESIGNADA para observador asignado a marea en estado DESIGNADA', async () => {
    const today = new Date();
    // Zarpada estimada dentro de 3 días con 7 días estimados de marea
    const zarpadaEstimada = new Date(today.getTime() + 3 * 24 * 60 * 60 * 1000);
    const diasEstimados = 7;

    mockPrismaService.observador.findMany.mockResolvedValue([
      {
        id: 'obs-6',
        nombre: 'Valeria',
        apellido: 'Sanchez',
        codigoInterno: 106,
        tipoObservador: 'OBSERVADOR',
        tipoContrato: 'CONTRATADO',
        conImpedimento: false,
        motivoImpedimento: null,
        disponible: true,
      },
    ]);

    mockPrismaService.observadorNovedad.findMany.mockResolvedValue([]);
    mockPrismaService.marea.findMany.mockResolvedValue([
      {
        id: 'marea-desig-1',
        tipoMarea: 'MC',
        nroMarea: 45,
        anioMarea: 2026,
        diasEstimados,
        fechaInicioObservador: null,
        fechaFinObservador: null,
        fechaZarpadaEstimada: zarpadaEstimada,
        observadorPrincipalId: 'obs-6',
        buque: { nombreBuque: 'BUQUE ATLANTICO' },
        pesqueria: { nombre: 'Merluza' },
        estadoActual: { codigo: 'DESIGNADA' },
        etapas: [],
      },
    ]);

    const result = await service.obtenerDisponibilidad(1);
    const obs = result.observadores[0];

    // 1. Debe haber un bloque de DESIGNADA con código corto DESIGNADA
    const eventoDesignada = obs.eventos.find(e => e.estado === 'DESIGNADA');
    expect(eventoDesignada).toBeDefined();
    expect(eventoDesignada?.codigoCorto).toBe('DESIGNADA');
    expect(eventoDesignada?.detalle).toContain('BUQUE ATLANTICO');

    // 2. Debe haber un bloque inicial de ¿DISPONIBLE? (no confirmada) antes de la designación (días 0 a 2)
    const eventosDisponibles = obs.eventos.filter(e => e.estado === 'DISPONIBLE_NO_CONFIRMADA');
    expect(eventosDisponibles.length).toBeGreaterThanOrEqual(1);
    expect(eventosDisponibles[0].codigoCorto).toBe('¿DISPONIBLE?');
  });

  it('no debe tener en cuenta mareas en estado A_REASIGNAR', async () => {
    const today = new Date();
    mockPrismaService.observador.findMany.mockResolvedValue([
      {
        id: 'obs-7',
        nombre: 'Federico',
        apellido: 'Lopez',
        codigoInterno: 107,
        tipoObservador: 'OBSERVADOR',
        tipoContrato: 'PLANTA PERMANENTE',
        conImpedimento: false,
        motivoImpedimento: null,
        disponible: true,
      },
    ]);

    mockPrismaService.observadorNovedad.findMany.mockResolvedValue([]);
    mockPrismaService.marea.findMany.mockResolvedValue([
      {
        id: 'marea-reasig-1',
        tipoMarea: 'MC',
        nroMarea: 46,
        anioMarea: 2026,
        diasEstimados: 10,
        fechaInicioObservador: null,
        fechaFinObservador: null,
        fechaZarpadaEstimada: today,
        observadorPrincipalId: 'obs-7',
        buque: { nombreBuque: 'BUQUE EJEMPLO' },
        pesqueria: { nombre: 'Merluza' },
        estadoActual: { codigo: 'A_REASIGNAR' },
        etapas: [],
      },
    ]);

    const result = await service.obtenerDisponibilidad(1);
    const obs = result.observadores[0];

    // No debe existir ningún bloque de DESIGNADA
    const eventoDesignada = obs.eventos.find(e => e.estado === 'DESIGNADA');
    expect(eventoDesignada).toBeUndefined();

    // El observador debe estar en ¿DISPONIBLE? (no confirmada)
    const eventoDisponible = obs.eventos.find(e => e.estado === 'DISPONIBLE_NO_CONFIRMADA');
    expect(eventoDisponible).toBeDefined();
    expect(eventoDisponible?.codigoCorto).toBe('¿DISPONIBLE?');
  });
});


