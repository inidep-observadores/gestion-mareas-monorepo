import { Test, TestingModule } from '@nestjs/testing';
import { MareasService } from './mareas.service';
import { PrismaService } from '../prisma/prisma.service';
import { DriveStorageService } from '../files/drive-storage.service';
import { JobQueueService } from '../jobs/job-queue.service';
import { ConfigService } from '@nestjs/config';
import { MailService } from '../mail/mail.service';
import { AlertsService } from '../alerts/alerts.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { JobType } from '@prisma/client';
import { BadRequestException, NotFoundException } from '@nestjs/common';

describe('MareasService - Archivos/Pasajes', () => {
    let service: MareasService;
    let prisma: PrismaService;
    let driveStorage: DriveStorageService;
    let jobQueue: JobQueueService;

    const mockPrisma = {
        marea: { findUnique: jest.fn() },
        mareaArchivo: { create: jest.fn(), findUnique: jest.fn(), delete: jest.fn() }
    };
    const mockDrive = {
        uploadFile: jest.fn(),
        deleteFile: jest.fn()
    };
    const mockJobQueue = {
        addJob: jest.fn()
    };
    const mockConfig = {
        get: jest.fn().mockReturnValue('mock_folder_id')
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                MareasService,
                { provide: PrismaService, useValue: mockPrisma },
                { provide: DriveStorageService, useValue: mockDrive },
                { provide: JobQueueService, useValue: mockJobQueue },
                { provide: ConfigService, useValue: mockConfig },
                { provide: MailService, useValue: {} },
                { provide: AlertsService, useValue: {} },
                { provide: BusinessRulesService, useValue: {} },
            ],
        }).compile();

        service = module.get<MareasService>(MareasService);
        prisma = module.get<PrismaService>(PrismaService);
        driveStorage = module.get<DriveStorageService>(DriveStorageService);
        jobQueue = module.get<JobQueueService>(JobQueueService);

        jest.clearAllMocks();
    });

    describe('uploadPasajes', () => {
        it('debe lanzar NotFound si la marea no existe', async () => {
            mockPrisma.marea.findUnique.mockResolvedValue(null);
            const user = { id: 'u1' } as any;
            await expect(service.uploadPasajes('m1', [], user)).rejects.toThrow(NotFoundException);
        });

        it('debe procesar archivos, subirlos a drive, guardar en BD', async () => {
            mockPrisma.marea.findUnique.mockResolvedValue({ id: 'm1' });
            mockDrive.uploadFile.mockResolvedValue({ fileId: 'd1', webViewLink: 'http://link.com' });
            mockPrisma.mareaArchivo.create.mockResolvedValue({ id: 'a1', mareaId: 'm1' });

            const files = [{ originalname: 'test.pdf', mimetype: 'application/pdf', buffer: Buffer.from('test') }] as any;
            const user = { id: 'u1' } as any;

            const res = await service.uploadPasajes('m1', files, user);

            expect(res.length).toBe(1);
            expect(mockDrive.uploadFile).toHaveBeenCalledWith('test.pdf', 'application/pdf', expect.any(Buffer), 'mock_folder_id');
            expect(mockPrisma.mareaArchivo.create).toHaveBeenCalled();
            expect(mockJobQueue.addJob).not.toHaveBeenCalled();
        });

        it('debe lanzar BadRequestException si la subida a drive falla', async () => {
            mockPrisma.marea.findUnique.mockResolvedValue({ id: 'm1' });
            mockDrive.uploadFile.mockRejectedValue(new Error('Drive error'));

            const files = [{ originalname: 'fail.pdf', mimetype: 'application/pdf', buffer: Buffer.from('test') }] as any;
            const user = { id: 'u1' } as any;

            await expect(service.uploadPasajes('m1', files, user)).rejects.toThrow(BadRequestException);
        });
    });

    describe('deleteArchivo', () => {
        it('debe lanzar NotFoundException si el archivo no existe', async () => {
            mockPrisma.mareaArchivo.findUnique.mockResolvedValue(null);
            const user = { id: 'u1' } as any;
            await expect(service.deleteArchivo('m1', 'a1', user)).rejects.toThrow(NotFoundException);
        });

        it('debe lanzar BadRequestException si el archivo no pertenece a la marea', async () => {
            mockPrisma.mareaArchivo.findUnique.mockResolvedValue({ id: 'a1', mareaId: 'm2' });
            const user = { id: 'u1' } as any;
            await expect(service.deleteArchivo('m1', 'a1', user)).rejects.toThrow(BadRequestException);
        });

        it('debe eliminar archivo de Drive si tiene driveFileId, luego borrar en BD', async () => {
            mockPrisma.mareaArchivo.findUnique.mockResolvedValue({
                id: 'a1',
                mareaId: 'm1',
                metadata: { driveFileId: 'd1' }
            });
            mockDrive.deleteFile.mockResolvedValue({});
            mockPrisma.mareaArchivo.delete.mockResolvedValue({});

            const user = { id: 'u1' } as any;
            const res = await service.deleteArchivo('m1', 'a1', user);

            expect(res).toEqual({ success: true });
            expect(mockDrive.deleteFile).toHaveBeenCalledWith('d1');
            expect(mockPrisma.mareaArchivo.delete).toHaveBeenCalledWith({ where: { id: 'a1' } });
        });
    });
});
