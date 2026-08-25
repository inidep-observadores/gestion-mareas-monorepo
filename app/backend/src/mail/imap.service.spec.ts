import { Test, TestingModule } from '@nestjs/testing';
import { ImapService } from './imap.service';
import { ConfigService } from '@nestjs/config';
import { ImapFlow } from 'imapflow';
import * as mailparser from 'mailparser';

// Mocking dependencies
jest.mock('imapflow');
jest.mock('mailparser');

describe('ImapService', () => {
    let service: ImapService;
    let configService: ConfigService;
    
    // Mock instance of ImapFlow
    const mockImapClient = {
        connect: jest.fn(),
        logout: jest.fn(),
        getMailboxLock: jest.fn(),
        mailboxOpen: jest.fn(),
        fetch: jest.fn(),
        fetchOne: jest.fn(),
        search: jest.fn(),
        messageFlagsAdd: jest.fn(),
        messageMove: jest.fn(),
    };

    beforeEach(async () => {
        // Clear mocks before each test
        jest.clearAllMocks();
        
        // Mock constructor implementation
        (ImapFlow as unknown as jest.Mock).mockImplementation(() => mockImapClient);

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                ImapService,
                {
                    provide: ConfigService,
                    useValue: {
                        get: jest.fn((key: string) => {
                            const config = {
                                'IMAP_HOST': 'imap.gmail.com',
                                'IMAP_PORT': 993,
                                'SMTP_USER': 'test@example.com',
                                'SMTP_PASS': 'password123',
                            };
                            return config[key];
                        }),
                    },
                },
            ],
        }).compile();

        service = module.get<ImapService>(ImapService);
        configService = module.get<ConfigService>(ConfigService);
    });

    it('debería estar definido', () => {
        expect(service).toBeDefined();
    });

    describe('Conexión y Autenticación', () => {
        it('debería conectar y autenticar exitosamente usando la configuración', async () => {
            mockImapClient.connect.mockResolvedValue(true);
            
            await service.connect();
            
            expect(ImapFlow).toHaveBeenCalledWith({
                host: 'imap.gmail.com',
                port: 993,
                secure: true,
                auth: {
                    user: 'test@example.com',
                    pass: 'password123',
                },
                logger: false
            });
            expect(mockImapClient.connect).toHaveBeenCalled();
        });
    });

    describe('Lectura de Correos', () => {
        it('debería obtener los correos no leídos y parsearlos', async () => {
            await service.connect();
            // Configurar el mock de ImapFlow
            mockImapClient.getMailboxLock.mockResolvedValue({ release: jest.fn() });
            
            // Simular un mensaje devuelto por fetch
            const mockMessage = {
                uid: 1,
                source: Buffer.from('Email content raw')
            };
            
            // Mock async generator para fetch
            mockImapClient.fetch.mockImplementation(async function* () {
                yield mockMessage;
            });

            // Mock de mailparser
            const parsedEmail = {
                messageId: '12345',
                subject: 'Novedad de viaje',
                text: 'Hola, adjunto mi pasaje.',
                attachments: []
            };
            (mailparser.simpleParser as jest.Mock).mockResolvedValue(parsedEmail);

            const result = await service.fetchUnprocessedEmails();

            expect(mockImapClient.getMailboxLock).toHaveBeenCalledWith('INBOX');
            expect(mockImapClient.fetch).toHaveBeenCalledWith({ unKeyword: 'Procesado_SIGMA' }, { source: true, uid: true });
            expect(mailparser.simpleParser).toHaveBeenCalledWith(mockMessage.source);
            
            expect(result).toHaveLength(1);
            expect(result[0]).toEqual({
                uid: 1,
                messageId: '12345',
                subject: 'Novedad de viaje',
                text: 'Hola, adjunto mi pasaje.',
                from: '',
                to: '',
                date: undefined,
                attachments: []
            });
        });
    });

    describe('Etiquetado / Movimiento de Correos', () => {
        it('debería añadir la etiqueta de Procesado_SIGMA al correo', async () => {
            await service.connect();
            mockImapClient.messageFlagsAdd.mockResolvedValue(true);
            
            // Para ImapFlow, las "etiquetas" personalizadas se añaden como flags o moviendo a carpetas. 
            // Evaluaremos primero añadiendo un label si el servidor lo soporta.
            await service.markAsProcessed(1);
            
            expect(mockImapClient.messageFlagsAdd).toHaveBeenCalledWith(1, ['Procesado_SIGMA'], { uid: true });
        });
    });

    describe('Búsqueda de Correo por Message-ID', () => {
        it('debería buscar y devolver un correo específico por su messageId', async () => {
            await service.connect();
            mockImapClient.getMailboxLock.mockResolvedValue({ release: jest.fn() });
            
            const mockMessage = {
                uid: 42,
                source: Buffer.from('Raw email source')
            };
            mockImapClient.fetch.mockImplementation(async function* () {
                yield mockMessage;
            });

            const parsedEmail = {
                messageId: '<msg-123@example.com>',
                subject: 'Asunto de prueba',
                text: 'Cuerpo de prueba',
                from: { text: 'remitente@example.com' },
                attachments: []
            };
            (mailparser.simpleParser as jest.Mock).mockResolvedValue(parsedEmail);

            const result = await service.fetchEmailByMessageId('<msg-123@example.com>');

            expect(mockImapClient.getMailboxLock).toHaveBeenCalledWith('INBOX');
            expect(mockImapClient.fetch).toHaveBeenCalledWith({ all: true }, { source: true, uid: true });
            expect(result).toEqual({
                uid: 42,
                messageId: '<msg-123@example.com>',
                subject: 'Asunto de prueba',
                text: 'Cuerpo de prueba',
                from: 'remitente@example.com',
                to: '',
                date: undefined,
                attachments: []
            });
        });

        it('debería retornar null si el correo no se encuentra en IMAP', async () => {
            await service.connect();
            mockImapClient.getMailboxLock.mockResolvedValue({ release: jest.fn() });
            mockImapClient.fetch.mockImplementation(async function* () {});

            const result = await service.fetchEmailByMessageId('<inexistente@example.com>');

            expect(result).toBeNull();
        });
    });
});
