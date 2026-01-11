"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const mailer_1 = require("@nestjs-modules/mailer");
const crypto = require("crypto");
const prisma_service_1 = require("../prisma/prisma.service");
const hash_service_1 = require("../common/services/hash.service");
let AuthService = class AuthService {
    constructor(prisma, jwtService, mailerService, hashService) {
        this.prisma = prisma;
        this.jwtService = jwtService;
        this.mailerService = mailerService;
        this.hashService = hashService;
    }
    async create(createUserDto) {
        try {
            const { password, ...userData } = createUserDto;
            const user = await this.prisma.user.create({
                data: {
                    ...userData,
                    email: userData.email.toLowerCase().trim(),
                    password: this.hashService.hash(password),
                },
            });
            const { password: _, ...result } = user;
            return {
                user: result,
                token: this.getJwtToken({ id: user.id, email: user.email }),
                refreshToken: this.getRefreshJwtToken({ id: user.id, email: user.email }),
            };
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async login(loginUserDto) {
        const { password, email } = loginUserDto;
        const user = await this.prisma.user.findUnique({
            where: { email: email.toLowerCase().trim() },
        });
        if (!user)
            throw new common_1.UnauthorizedException('Credenciales inválidas');
        if (!this.hashService.compare(password, user.password))
            throw new common_1.UnauthorizedException('Credenciales inválidas');
        const { password: _, ...result } = user;
        return {
            user: result,
            token: this.getJwtToken({ id: user.id, email: user.email }),
            refreshToken: this.getRefreshJwtToken({ id: user.id, email: user.email }),
        };
    }
    async checkAuthStatus(user) {
        const { password, ...rest } = user;
        return {
            user: rest,
            token: this.getJwtToken({ id: user.id, email: user.email }),
        };
    }
    getJwtToken(payload) {
        const token = this.jwtService.sign(payload);
        return token;
    }
    handleDBErrors(error) {
        if (error.code === 'P2002')
            throw new common_1.BadRequestException('Conflicto: El recurso ya existe (clave duplicada)');
        console.log(error);
        throw new common_1.InternalServerErrorException('Error interno; por favor, revise los logs del servidor');
    }
    async forgotPassword(email) {
        const user = await this.prisma.user.findUnique({ where: { email } });
        if (!user || !user.isActive) {
            return {
                message: 'Si el correo existe y está activo, se enviaron instrucciones',
            };
        }
        const token = crypto.randomBytes(32).toString('hex');
        const expiresAt = new Date();
        expiresAt.setMinutes(expiresAt.getMinutes() + 30);
        await this.prisma.passwordResetToken.create({
            data: {
                userId: user.id,
                token,
                expiresAt: expiresAt,
                used: false,
            },
        });
        const resetLink = `${process.env.FRONTEND_URL}?token=${token}`;
        try {
            await this.mailerService.sendMail({
                to: user.email,
                subject: 'Recuperación de contraseña',
                html: `
          <h1>Recuperación de contraseña</h1>
          <p>Hola ${user.fullName},</p>
          <p>Usted ha solicitado restablecer su contraseña. Haga clic en el siguiente enlace para continuar:</p>
          <a href="${resetLink}">Restablecer contraseña</a>
          <p>Este enlace expirará en 30 minutos.</p>
          <p>Si usted no solicitó esto, ignore este correo.</p>
        `,
            });
        }
        catch (error) {
            console.error('Error sending email:', error);
        }
        return {
            message: 'Si el correo existe y está activo, se enviaron instrucciones',
        };
    }
    async validateResetToken(token) {
        const resetToken = await this.prisma.passwordResetToken.findFirst({
            where: { token },
            include: { user: true },
        });
        if (!resetToken) {
            throw new common_1.BadRequestException('Token inválido');
        }
        if (resetToken.used) {
            throw new common_1.BadRequestException('Token ya utilizado');
        }
        if (resetToken.expiresAt < new Date()) {
            throw new common_1.BadRequestException('Token expirado');
        }
        return { valid: true, email: resetToken.user.email };
    }
    async resetPassword(resetPasswordDto) {
        const { token, newPassword } = resetPasswordDto;
        const resetToken = await this.prisma.passwordResetToken.findFirst({
            where: { token },
            include: { user: true },
        });
        if (!resetToken) {
            throw new common_1.BadRequestException('Token inválido');
        }
        if (resetToken.used) {
            throw new common_1.BadRequestException('Token ya utilizado');
        }
        if (resetToken.expiresAt < new Date()) {
            throw new common_1.BadRequestException('Token expirado');
        }
        const newHash = this.hashService.hash(newPassword);
        await this.prisma.$transaction([
            this.prisma.user.update({
                where: { id: resetToken.userId },
                data: { password: newHash },
            }),
            this.prisma.passwordResetToken.update({
                where: { id: resetToken.id },
                data: { used: true },
            }),
        ]);
        return { message: 'Contraseña actualizada correctamente' };
    }
    getRefreshJwtToken(payload) {
        const token = this.jwtService.sign(payload, {
            expiresIn: '7d',
        });
        return token;
    }
    async refreshAuth(refreshToken) {
        try {
            const payload = this.jwtService.verify(refreshToken);
            const user = await this.prisma.user.findUnique({
                where: { id: payload.id },
            });
            if (!user)
                throw new common_1.UnauthorizedException('Usuario no encontrado');
            if (!user.isActive)
                throw new common_1.UnauthorizedException('Usuario no activo');
            const { password: _, ...rest } = user;
            return {
                user: rest,
                token: this.getJwtToken({ id: user.id, email: user.email }),
                refreshToken: this.getRefreshJwtToken({ id: user.id, email: user.email }),
            };
        }
        catch (error) {
            throw new common_1.UnauthorizedException('Token de refresco inválido o expirado');
        }
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        jwt_1.JwtService,
        mailer_1.MailerService,
        hash_service_1.HashService])
], AuthService);
//# sourceMappingURL=auth.service.js.map