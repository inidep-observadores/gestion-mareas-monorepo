import { Test, TestingModule } from '@nestjs/testing';
import { DriveStorageService } from './drive-storage.service';
import { ConfigService } from '@nestjs/config';
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
            ],
        }).compile();

        service = module.get<DriveStorageService>(DriveStorageService);
        configService = module.get<ConfigService>(ConfigService);
    });

    it('debería estar definido', () => {
        expect(service).toBeDefined();
    });

    describe('uploadFile', () => {
        it('debería subir un archivo a Google Drive y devolver el ID y link', async () => {
            // Obtener el mock de la función 'create' de drive.files
            const driveMock = google.drive({ version: 'v3' });
            const mockCreate = driveMock.files.create as jest.Mock;

            // Simular respuesta exitosa de la API de Google Drive
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
            
            // Verificar que drive.files.create fue llamado con los parámetros correctos
            expect(mockCreate).toHaveBeenCalledWith({
                requestBody: {
                    name: 'pasaje.pdf',
                    parents: ['folder-123'], // Debe usar la carpeta definida en config
                },
                media: {
                    mimeType: 'application/pdf',
                    body: expect.any(Object), // Debe ser un stream del buffer
                },
                fields: 'id, webViewLink',
            });
        });
    });
});
