import { Test, TestingModule } from '@nestjs/testing';
import * as path from 'path';
import * as os from 'os';
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
        marea: { findUnique: jest.fn(), update: jest.fn() },
        mareaArchivo: { create: jest.fn(), findUnique: jest.fn(), delete: jest.fn() },
        mareaMovimiento: { create: jest.fn() },
        jobQueue: { findMany: jest.fn(), deleteMany: jest.fn(), create: jest.fn() },
        $transaction: jest.fn()
    };
    const mockDrive = {
        uploadFile: jest.fn(),
        deleteFile: jest.fn()
    };
    const mockJobQueue = {
        addJob: jest.fn()
    };
    const mockConfig = {
        get: jest.fn().mockImplementation((key: string) => {
            if (key === 'UPLOADS_PATH' || key === 'MAREA_INFORMES_DIR') {
                return path.join(os.tmpdir(), 'sigma-test-uploads');
            }
            return 'mock_folder_id';
        })
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

    describe('resolverAdjuntoArchivo (envío a protocolizar)', () => {
        const marea = { nroMarea: 12, anioMarea: 2026 };
        const fs = require('fs');
        const os = require('os');
        const path = require('path');

        beforeEach(() => {
            (mockDrive as any).downloadFile = jest.fn();
        });

        it('descarga desde Drive usando metadata.driveFileId', async () => {
            (mockDrive as any).downloadFile.mockResolvedValue(Buffer.from('docx'));
            const res = await (service as any).resolverAdjuntoArchivo(
                { id: 'a1', rutaArchivo: 'https://docs.google.com/document/d/XYZ/edit', metadata: { driveFileId: 'META1', originalName: 'inf.docx', mimetype: 'application/x' } },
                marea
            );
            expect((mockDrive as any).downloadFile).toHaveBeenCalledWith('META1');
            expect(res).toEqual({ filename: 'inf.docx', content: expect.any(Buffer), contentType: 'application/x' });
        });

        it('extrae el ID de una URL docs.google.com si no hay metadata', async () => {
            (mockDrive as any).downloadFile.mockResolvedValue(Buffer.from('docx'));
            await (service as any).resolverAdjuntoArchivo(
                { id: 'a1', rutaArchivo: 'https://docs.google.com/document/d/ABC_123-x/edit?usp=drivesdk', metadata: {} },
                marea
            );
            expect((mockDrive as any).downloadFile).toHaveBeenCalledWith('ABC_123-x');
        });

        it('descarga directamente usando la URL de referencia remota si no hay driveFileId', async () => {
            (mockDrive as any).downloadFile.mockResolvedValue(Buffer.from('docx-remoto'));
            const res = await (service as any).resolverAdjuntoArchivo(
                { id: 'a1', rutaArchivo: 'https://servidor-externo.inidep.edu.ar/archivos/informe.docx', metadata: {} },
                marea
            );
            expect((mockDrive as any).downloadFile).toHaveBeenCalledWith('https://servidor-externo.inidep.edu.ar/archivos/informe.docx');
            expect(res.content).toEqual(Buffer.from('docx-remoto'));
        });

        it('adjunta por path si el archivo es local y existe', async () => {
            const tmp = path.join(os.tmpdir(), `sigma-test-${Date.now()}.docx`);
            fs.writeFileSync(tmp, 'x');
            try {
                const res = await (service as any).resolverAdjuntoArchivo({ id: 'a1', rutaArchivo: tmp, metadata: null }, marea);
                expect(res.path).toBe(tmp);
                expect((mockDrive as any).downloadFile).not.toHaveBeenCalled();
            } finally {
                fs.unlinkSync(tmp);
            }
        });

        it('usa la copia local como respaldo si falla la descarga de Drive', async () => {
            const tmp = path.join(os.tmpdir(), `sigma-test-fb-${Date.now()}.docx`);
            fs.writeFileSync(tmp, 'x');
            (mockDrive as any).downloadFile.mockRejectedValue(new Error('403'));
            try {
                const res = await (service as any).resolverAdjuntoArchivo(
                    { id: 'a1', rutaArchivo: 'https://drive.google.com/file/d/D1/view', metadata: { driveFileId: 'D1', tempFilePath: tmp } },
                    marea
                );
                expect(res.path).toBe(tmp);
            } finally {
                fs.unlinkSync(tmp);
            }
        });

        it('lanza BadRequest si falla Drive y no hay copia local', async () => {
            (mockDrive as any).downloadFile.mockRejectedValue(new Error('404'));
            await expect((service as any).resolverAdjuntoArchivo(
                { id: 'a1', rutaArchivo: 'https://drive.google.com/file/d/D1/view', metadata: {} }, marea
            )).rejects.toThrow(BadRequestException);
        });

        it('lanza BadRequest si el archivo local no existe', async () => {
            await expect((service as any).resolverAdjuntoArchivo(
                { id: 'a1', rutaArchivo: './uploads/no-existe.docx', metadata: {} }, marea
            )).rejects.toThrow(BadRequestException);
        });
    });

    describe('reemplazarInforme', () => {
        const user = { id: 'u1', fullName: 'Tester' } as any;
        const validFile = {
            originalname: 'informe_nuevo.docx',
            mimetype: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            buffer: Buffer.from('contenido docx')
        } as Express.Multer.File;

        it('lanza BadRequestException si no se adjunta archivo', async () => {
            await expect(service.reemplazarInforme('m1', null as any, 'Motivo', user))
                .rejects.toThrow(BadRequestException);
        });

        it('lanza BadRequestException si la extensión no es .docx', async () => {
            const badFile = { ...validFile, originalname: 'informe.pdf' } as Express.Multer.File;
            await expect(service.reemplazarInforme('m1', badFile, 'Motivo', user))
                .rejects.toThrow(BadRequestException);
        });

        it('lanza BadRequestException si el motivo está vacío', async () => {
            await expect(service.reemplazarInforme('m1', validFile, '   ', user))
                .rejects.toThrow(BadRequestException);
        });

        it('lanza NotFoundException si la marea no existe', async () => {
            mockPrisma.marea.findUnique.mockResolvedValue(null);
            await expect(service.reemplazarInforme('m1', validFile, 'Corrección de errores', user))
                .rejects.toThrow(NotFoundException);
        });

        it('lanza BadRequestException si el estado no es PARA_PROTOCOLIZAR', async () => {
            mockPrisma.marea.findUnique.mockResolvedValue({
                id: 'm1',
                estadoActual: { codigo: 'EN_EJECUCION' },
                archivos: [{ id: 'arch-1', tipoArchivo: 'INFORME_APROBACION' }]
            });
            await expect(service.reemplazarInforme('m1', validFile, 'Corrección de errores', user))
                .rejects.toThrow(BadRequestException);
        });

        it('lanza BadRequestException si no cuenta con informe previo', async () => {
            mockPrisma.marea.findUnique.mockResolvedValue({
                id: 'm1',
                estadoActual: { codigo: 'PARA_PROTOCOLIZAR' },
                archivos: []
            });
            await expect(service.reemplazarInforme('m1', validFile, 'Corrección de errores', user))
                .rejects.toThrow(BadRequestException);
        });

        it('reemplaza exitosamente el informe, limpia en Drive y registra movimiento en la bitácora', async () => {
            const archivoAnterior = {
                id: 'arch-previo',
                tipoArchivo: 'INFORME_APROBACION',
                metadata: {
                    driveFileId: 'drive-file-123',
                    tempFilePath: null
                }
            };

            mockPrisma.marea.findUnique.mockResolvedValue({
                id: 'm1',
                anioMarea: 2026,
                nroMarea: 50,
                tipoMarea: 'COM',
                estadoActualId: 'est-para-prot',
                estadoActual: { codigo: 'PARA_PROTOCOLIZAR' },
                archivos: [archivoAnterior]
            });

            mockPrisma.jobQueue.findMany.mockResolvedValue([
                { id: 'job-1', payload: { mareaArchivoId: 'arch-previo' } }
            ]);
            mockPrisma.jobQueue.deleteMany.mockResolvedValue({ count: 1 });

            const nuevoMovimiento = { id: 'mov-reemplazo' };
            const nuevoArchivo = {
                id: 'arch-nuevo',
                mareaId: 'm1',
                tipoArchivo: 'INFORME_APROBACION',
                version: 'CORREGIDO'
            };

            mockPrisma.$transaction.mockImplementation(async (callback: any) => {
                const tx = {
                    mareaArchivo: {
                        delete: jest.fn().mockResolvedValue({}),
                        create: jest.fn().mockResolvedValue(nuevoArchivo)
                    },
                    mareaMovimiento: {
                        create: jest.fn().mockResolvedValue(nuevoMovimiento)
                    },
                    marea: {
                        update: jest.fn().mockResolvedValue({})
                    },
                    jobQueue: {
                        create: jest.fn().mockResolvedValue({})
                    }
                };
                return await callback(tx);
            });

            const result = await service.reemplazarInforme('m1', validFile, 'Ajuste de resumen en página 2', user);

            expect(mockDrive.deleteFile).toHaveBeenCalledWith('drive-file-123');
            expect(mockPrisma.jobQueue.deleteMany).toHaveBeenCalled();
            expect(result).toEqual(nuevoArchivo);
        });
    });
});
