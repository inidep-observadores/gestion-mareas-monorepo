import { Test, TestingModule } from '@nestjs/testing';
import { DriveStorageService } from './drive-storage.service';
import { ConfigService } from '@nestjs/config';
import { ErrorLogsService } from '../common/error-logs/error-logs.service';
import { google } from 'googleapis';

// Mockeamos la API de Google Drive
jest.mock('googleapis', () => ({
    google: {
        auth: {
            GoogleAuth: jest.fn().mockImplementation(() => ({
                getClient: jest.fn().mockResolvedValue({}),
            })),
        },
        drive: jest.fn().mockReturnValue({
            files: {
                create: jest.fn(),
                delete: jest.fn(),
            },
            permissions: {
                create: jest.fn().mockResolvedValue({}),
            },
        }),
    },
}));

describe('DriveStorageService', () => {
    let service: DriveStorageService;
    let configService: ConfigService;
    let errorLogsService: ErrorLogsService;

    const mockErrorLogsService = {
        create: jest.fn().mockResolvedValue({ id: 'log-123' }),
    };

    beforeEach(async () => {
        jest.clearAllMocks();

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                DriveStorageService,
                {
                    provide: ConfigService,
                    useValue: {
                        get: jest.fn((key: string) => {
                            if (key === 'GOOGLE_CLIENT_ID') return undefined;
                            if (key === 'GOOGLE_CLIENT_SECRET') return undefined;
                            if (key === 'GOOGLE_REFRESH_TOKEN') return undefined;
                            if (key === 'GOOGLE_DRIVE_NOVEDADES_FOLDER_ID') return 'folder-123';
                            return null;
                        }),
                    },
                },
                {
                    provide: ErrorLogsService,
                    useValue: mockErrorLogsService,
                },
            ],
        }).compile();

        service = module.get<DriveStorageService>(DriveStorageService);
        configService = module.get<ConfigService>(ConfigService);
        errorLogsService = module.get<ErrorLogsService>(ErrorLogsService);
    });

    it('debería estar definido', () => {
        expect(service).toBeDefined();
    });

    describe('uploadFile', () => {
        it('debería subir un archivo a Google Drive y devolver el ID y link', async () => {
            const driveMock = google.drive({ version: 'v3' });
            const mockCreate = driveMock.files.create as jest.Mock;

            mockCreate.mockResolvedValue({
                data: {
                    id: 'fake-file-id-456',
                    webViewLink: 'https://drive.google.com/file/d/fake-file-id-456/view',
                },
            });

            const buffer = Buffer.from('contenido del pdf');
            const result = await service.uploadFile('pasaje.pdf', 'application/pdf', buffer);

            expect(result).toBeDefined();
            expect(result.fileId).toBe('fake-file-id-456');
            expect(result.webViewLink).toBe('https://drive.google.com/file/d/fake-file-id-456/view');
            
            expect(mockCreate).toHaveBeenCalledWith({
                requestBody: {
                    name: 'pasaje.pdf',
                    parents: ['folder-123'],
                },
                media: {
                    mimeType: 'application/pdf',
                    body: expect.any(Object),
                },
                fields: 'id, webViewLink',
            });
        });

        it('debería registrar en ErrorLog y relanzar la excepción si falla la subida', async () => {
            const driveMock = google.drive({ version: 'v3' });
            const mockCreate = driveMock.files.create as jest.Mock;

            mockCreate.mockRejectedValue(new Error('Google API Error 500'));

            const buffer = Buffer.from('contenido del pdf');

            await expect(service.uploadFile('pasaje.pdf', 'application/pdf', buffer)).rejects.toThrow('Google API Error 500');

            expect(mockErrorLogsService.create).toHaveBeenCalledWith(expect.objectContaining({
                level: 'ERROR',
                source: 'GOOGLE_DRIVE',
                context: 'DriveStorageService.uploadFile',
                message: expect.stringContaining('Google API Error 500'),
            }));
        });
    });

    describe('deleteFile', () => {
        it('debería eliminar el archivo de Google Drive exitosamente', async () => {
            const driveMock = google.drive({ version: 'v3' });
            const mockDelete = driveMock.files.delete as jest.Mock;
            mockDelete.mockResolvedValue({});

            await service.deleteFile('file-to-delete');

            expect(mockDelete).toHaveBeenCalledWith({ fileId: 'file-to-delete' });
            expect(mockErrorLogsService.create).not.toHaveBeenCalled();
        });

        it('debería ignorar errores 404 al borrar', async () => {
            const driveMock = google.drive({ version: 'v3' });
            const mockDelete = driveMock.files.delete as jest.Mock;
            mockDelete.mockRejectedValue({ code: 404, message: 'File not found' });

            await service.deleteFile('file-not-found');

            expect(mockDelete).toHaveBeenCalledWith({ fileId: 'file-not-found' });
            expect(mockErrorLogsService.create).not.toHaveBeenCalled();
        });

        it('debería registrar en ErrorLog errores que no sean 404 al borrar', async () => {
            const driveMock = google.drive({ version: 'v3' });
            const mockDelete = driveMock.files.delete as jest.Mock;
            mockDelete.mockRejectedValue(new Error('Unauthorized 401'));

            await service.deleteFile('file-unauthorized');

            expect(mockDelete).toHaveBeenCalledWith({ fileId: 'file-unauthorized' });
            expect(mockErrorLogsService.create).toHaveBeenCalledWith(expect.objectContaining({
                level: 'ERROR',
                source: 'GOOGLE_DRIVE',
                context: 'DriveStorageService.deleteFile',
                message: expect.stringContaining('Unauthorized 401'),
            }));
        });
    });
});
