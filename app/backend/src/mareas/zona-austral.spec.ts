import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { MareasService } from './mareas.service';
import { PrismaService } from '../prisma/prisma.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { MailService } from '../mail/mail.service';
import { AlertsService } from '../alerts/alerts.service';
import { ConfigService } from '@nestjs/config';
import { NotFoundException } from '@nestjs/common';
import { DateTime } from 'luxon';

describe('MareasService - Zona Austral', () => {
    let service: MareasService;
    let mockPrismaService: any;

    beforeEach(async () => {
        mockPrismaService = {
            marea: {
                findUnique: jest.fn(),
            },
            buqueTrayectoriaPunto: {
                findMany: jest.fn(),
            },
        };

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                MareasService,
                { provide: PrismaService, useValue: mockPrismaService },
                { provide: BusinessRulesService, useValue: {} },
                { provide: MailService, useValue: {} },
                { provide: AlertsService, useValue: {} },
                { provide: ConfigService, useValue: { get: jest.fn() } },
            ],
        }).compile();

        service = module.get<MareasService>(MareasService);
    });

    it('should throw NotFoundException if marea does not exist', async () => {
        mockPrismaService.marea.findUnique.mockResolvedValue(null);
        await expect(service.getZonaAustralDays('invalid-id')).rejects.toThrow(NotFoundException);
    });

    it('should return 0 days if there are no stages with fechaZarpada', async () => {
        mockPrismaService.marea.findUnique.mockResolvedValue({
            id: 'marea-1',
            etapas: [{ nroEtapa: 1, fechaZarpada: null }]
        });

        const result = await service.getZonaAustralDays('marea-1');
        expect(result.totalDiasMarea).toBe(0);
        expect(result.etapas).toHaveLength(0);
    });

    it('should return 0 days if no points are in Zona Austral (lat <= -50)', async () => {
        mockPrismaService.marea.findUnique.mockResolvedValue({
            id: 'marea-1',
            buqueId: 'buque-1',
            etapas: [{ id: 'e1', nroEtapa: 1, fechaZarpada: new Date('2025-01-01T10:00:00Z'), fechaArribo: new Date('2025-01-05T10:00:00Z') }]
        });

        mockPrismaService.buqueTrayectoriaPunto.findMany.mockResolvedValue([]);

        const result = await service.getZonaAustralDays('marea-1');
        expect(result.totalDiasMarea).toBe(0);
        expect(result.etapas[0].totalDias).toBe(0);
    });

    it('should return 0 days if there is only 1 point in Zona Austral for a given day', async () => {
        mockPrismaService.marea.findUnique.mockResolvedValue({
            id: 'marea-1',
            buqueId: 'buque-1',
            etapas: [{ id: 'e1', nroEtapa: 1, fechaZarpada: new Date(2025, 0, 1), fechaArribo: new Date(2025, 0, 5) }]
        });

        mockPrismaService.buqueTrayectoriaPunto.findMany.mockResolvedValue([
            { timestamp: new Date(2025, 0, 2, 10), lat: -55.0 }, // Only 1 point
        ]);

        const result = await service.getZonaAustralDays('marea-1');
        expect(result.totalDiasMarea).toBe(0);
        expect(result.etapas[0].totalDias).toBe(0);
    });

    it('should return 1 day if there are 2 or more points in Zona Austral for a given day', async () => {
        mockPrismaService.marea.findUnique.mockResolvedValue({
            id: 'marea-1',
            buqueId: 'buque-1',
            etapas: [{ id: 'e1', nroEtapa: 1, fechaZarpada: new Date(2025, 0, 1), fechaArribo: new Date(2025, 0, 5) }]
        });

        mockPrismaService.buqueTrayectoriaPunto.findMany.mockResolvedValue([
            { timestamp: new Date(2025, 0, 2, 10), lat: -55.0 },
            { timestamp: new Date(2025, 0, 2, 14), lat: -56.0 },
        ]);

        const result = await service.getZonaAustralDays('marea-1');
        expect(result.totalDiasMarea).toBe(1);
        expect(result.diasDetectadosMarea).toContain('2025-01-02');
        expect(result.etapas[0].totalDias).toBe(1);
        expect(result.etapas[0].diasDetectados).toContain('2025-01-02');
    });

    it('should NOT count points that are outside of navigation stages', async () => {
        mockPrismaService.marea.findUnique.mockResolvedValue({
            id: 'marea-1',
            buqueId: 'buque-1',
            etapas: [
                { id: 'e1', nroEtapa: 1, fechaZarpada: new Date(2025, 0, 1, 0), fechaArribo: new Date(2025, 0, 2, 23) },
                { id: 'e2', nroEtapa: 2, fechaZarpada: new Date(2025, 0, 4, 0), fechaArribo: new Date(2025, 0, 5, 23) }
            ]
        });

        mockPrismaService.buqueTrayectoriaPunto.findMany.mockResolvedValue([
            { timestamp: new Date(2025, 0, 1, 10), lat: -55.0 },
            { timestamp: new Date(2025, 0, 1, 14), lat: -55.0 }, // Counts in Stage 1
            { timestamp: new Date(2025, 0, 3, 10), lat: -55.0 },
            { timestamp: new Date(2025, 0, 3, 14), lat: -55.0 }, // Outside stages
            { timestamp: new Date(2025, 0, 4, 10), lat: -55.0 },
            { timestamp: new Date(2025, 0, 4, 14), lat: -55.0 }, // Counts in Stage 2
        ]);

        const result = await service.getZonaAustralDays('marea-1');
        expect(result.totalDiasMarea).toBe(2);
        expect(result.etapas[0].totalDias).toBe(1);
        expect(result.etapas[1].totalDias).toBe(1);
    });

    it('should handle correctly points exactly on the boundary of stages', async () => {
        const stageStart = new Date(2025, 0, 1, 0, 0, 0, 0);
        const stageEnd = new Date(2025, 0, 1, 23, 59, 59, 0);

        mockPrismaService.marea.findUnique.mockResolvedValue({
            id: 'marea-1',
            buqueId: 'buque-1',
            etapas: [{ id: 'e1', nroEtapa: 1, fechaZarpada: stageStart, fechaArribo: stageEnd }]
        });

        mockPrismaService.buqueTrayectoriaPunto.findMany.mockResolvedValue([
            { timestamp: stageStart, lat: -55.0 },
            { timestamp: stageEnd, lat: -56.0 },
        ]);

        const result = await service.getZonaAustralDays('marea-1');
        expect(result.totalDiasMarea).toBe(1);
        expect(result.etapas[0].totalDias).toBe(1);
    });

    it('should distinguish between days with multiple points and days with only one point per stage', async () => {
        mockPrismaService.marea.findUnique.mockResolvedValue({
            id: 'marea-1',
            buqueId: 'buque-1',
            etapas: [{ id: 'e1', nroEtapa: 1, fechaZarpada: new Date(2025, 0, 1), fechaArribo: new Date(2025, 0, 10) }]
        });

        mockPrismaService.buqueTrayectoriaPunto.findMany.mockResolvedValue([
            { timestamp: new Date(2025, 0, 2, 10), lat: -55.0 },
            { timestamp: new Date(2025, 0, 2, 11), lat: -55.0 }, // Valid (2)
            { timestamp: new Date(2025, 0, 3, 10), lat: -55.0 }, // Invalid (1)
            { timestamp: new Date(2025, 0, 4, 10), lat: -55.0 },
            { timestamp: new Date(2025, 0, 4, 12), lat: -55.0 },
            { timestamp: new Date(2025, 0, 4, 14), lat: -55.0 }, // Valid (3)
        ]);

        const result = await service.getZonaAustralDays('marea-1');
        expect(result.totalDiasMarea).toBe(2);
        expect(result.etapas[0].diasDetectados).toEqual(['2025-01-02', '2025-01-04']);
    });
});
