
import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { PrismaService } from '../prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { MailService } from '../mail/mail.service';
import { HashService } from '../common/services/hash.service';
import { DateUtils } from '../common/utils/date.utils';
import { BadRequestException } from '@nestjs/common';

// Helper for dynamic DateUtils mocking or assume global mock capability
// We will spyOn standard static method.

describe('AuthService', () => {
    let service: AuthService;
    let prisma: PrismaService;

    const mockPrisma = {
        passwordResetToken: {
            findFirst: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
        },
        user: {
            findUnique: jest.fn(),
            update: jest.fn(),
        },
        $transaction: jest.fn((cb) => typeof cb === 'function' ? cb(prisma) : Promise.resolve(cb)), // Simple transaction mock
    };

    const mockJwtService = { sign: jest.fn(), verify: jest.fn() };
    const mockMailService = { sendMail: jest.fn() };
    const mockHashService = { hash: jest.fn(), compare: jest.fn() };

    beforeEach(async () => {
        // Since we are mocking DateUtils.getNow, we just need to ensure the service uses it.
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AuthService,
                { provide: PrismaService, useValue: mockPrisma },
                { provide: JwtService, useValue: mockJwtService },
                { provide: MailService, useValue: mockMailService },
                { provide: HashService, useValue: mockHashService },
            ],
        }).compile();

        service = module.get<AuthService>(AuthService);
        prisma = module.get<PrismaService>(PrismaService);
        jest.clearAllMocks();
    });

    describe('validateResetToken', () => {
        it('should throw if token is expired comparing with DateUtils.getNow(true)', async () => {
            const fixedNow = new Date('2024-01-01T12:00:00Z');
            const expiredDate = new Date('2024-01-01T11:59:00Z'); // Expired 1 min ago

            const getNowSpy = jest.spyOn(DateUtils, 'getNow').mockReturnValue(fixedNow);

            mockPrisma.passwordResetToken.findFirst.mockResolvedValue({
                id: 'tok1',
                token: 'abc',
                used: false,
                expiresAt: expiredDate, // Past
                user: { email: 'test@test.com' }
            });

            await expect(service.validateResetToken('abc')).rejects.toThrow(BadRequestException);
            await expect(service.validateResetToken('abc')).rejects.toThrow('Token expirado');

            expect(getNowSpy).toHaveBeenCalledWith(true);

            getNowSpy.mockRestore();
        });

        it('should pass if token is valid and not expired', async () => {
            const fixedNow = new Date('2024-01-01T12:00:00Z');
            const futureDate = new Date('2024-01-01T12:30:00Z'); // Future

            const getNowSpy = jest.spyOn(DateUtils, 'getNow').mockReturnValue(fixedNow);

            mockPrisma.passwordResetToken.findFirst.mockResolvedValue({
                id: 'tok1',
                token: 'abc',
                used: false,
                expiresAt: futureDate,
                user: { email: 'test@test.com' }
            });

            const result = await service.validateResetToken('abc');
            expect(result.valid).toBe(true);

            getNowSpy.mockRestore();
        });
    });

    describe('forgotPassword', () => {
        const mockUser = {
            id: 'user1',
            email: 'test@test.com',
            fullName: 'Test User',
            isActive: true,
        };

        beforeEach(() => {
            jest.clearAllMocks();
            // Default mock for user found
            mockPrisma.user.findUnique.mockResolvedValue(mockUser);
            mockPrisma.passwordResetToken.create.mockResolvedValue({});
            mockMailService.sendMail.mockResolvedValue(true);
        });

        it('should use default URL if FRONTEND_URL is not set', async () => {
            delete process.env.FRONTEND_URL;
            await service.forgotPassword('test@test.com');

            expect(mockMailService.sendMail).toHaveBeenCalled();
            const emailContent = mockMailService.sendMail.mock.calls[0][2];
            expect(emailContent).toContain('http://localhost:5173/reset-password?token=');
        });

        it('should correctly format URL when FRONTEND_URL has no trailing slash', async () => {
            process.env.FRONTEND_URL = 'https://myapp.com';
            await service.forgotPassword('test@test.com');

            const emailContent = mockMailService.sendMail.mock.calls[0][2];
            expect(emailContent).toContain('https://myapp.com/reset-password?token=');
        });

        it('should remove trailing slash from FRONTEND_URL', async () => {
            process.env.FRONTEND_URL = 'https://myapp.com/';
            await service.forgotPassword('test@test.com');

            const emailContent = mockMailService.sendMail.mock.calls[0][2];
            expect(emailContent).toContain('https://myapp.com/reset-password?token=');
        });

        it('should remove /reset-password from FRONTEND_URL', async () => {
            process.env.FRONTEND_URL = 'https://myapp.com/reset-password';
            await service.forgotPassword('test@test.com');

            const emailContent = mockMailService.sendMail.mock.calls[0][2];
            expect(emailContent).toContain('https://myapp.com/reset-password?token=');
        });

        it('should remove /reset-password/ from FRONTEND_URL', async () => {
            process.env.FRONTEND_URL = 'https://myapp.com/reset-password/';
            await service.forgotPassword('test@test.com');

            const emailContent = mockMailService.sendMail.mock.calls[0][2];
            expect(emailContent).toContain('https://myapp.com/reset-password?token=');
        });

        it('should throw BadRequestException if user is not found', async () => {
            mockPrisma.user.findUnique.mockResolvedValue(null);
            await expect(service.forgotPassword('nonexistent@test.com')).rejects.toThrow(BadRequestException);
            await expect(service.forgotPassword('nonexistent@test.com')).rejects.toThrow('Correo no registrado');
        });

        it('should throw BadRequestException if user is inactive', async () => {
            mockPrisma.user.findUnique.mockResolvedValue({ ...mockUser, isActive: false });
            await expect(service.forgotPassword('inactive@test.com')).rejects.toThrow(BadRequestException);
            await expect(service.forgotPassword('inactive@test.com')).rejects.toThrow('Cuenta inactiva');
        });

        it('should handle mail service failure gracefully', async () => {
            mockMailService.sendMail.mockRejectedValue(new Error('SMTP Error'));
            await expect(service.forgotPassword('test@test.com')).rejects.toThrow('No se pudo enviar el correo de recuperación');
        });
    });
});
