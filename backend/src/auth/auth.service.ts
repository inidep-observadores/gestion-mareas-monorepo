import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { MailerService } from '@nestjs-modules/mailer';
import * as crypto from 'crypto';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { User } from '@prisma/client';
import { LoginUserDto, CreateUserDto, ResetPasswordDto } from './dto';
import { JwtPayload } from './interfaces/jwt-payload.interface';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
    private readonly mailerService: MailerService,
  ) {}

  async create(createUserDto: CreateUserDto) {
    try {
      const { password, ...userData } = createUserDto;

      const user = await this.prisma.user.create({
        data: {
          ...userData,
          email: userData.email.toLowerCase().trim(),
          password: bcrypt.hashSync(password, 10),
        },
      });

      const { password: _, ...result } = user;

      return {
        user: result,
        token: this.getJwtToken({ id: user.id }),
      };
    } catch (error) {
      this.handleDBErrors(error);
    }
  }

  async login(loginUserDto: LoginUserDto) {
    const { password, email } = loginUserDto;

    const user = await this.prisma.user.findUnique({
      where: { email: email.toLowerCase().trim() },
    });

    if (!user) throw new UnauthorizedException('Credenciales inválidas');

    if (!bcrypt.compareSync(password, user.password))
      throw new UnauthorizedException('Credenciales inválidas');

    const { password: _, ...result } = user;

    return {
      user: result,
      token: this.getJwtToken({ id: user.id }),
    };
  }

  async checkAuthStatus(user: User) {
    // Password should be excluded by the strategy or caller
    // But if we receive a raw User from Prisma, it might have password if not excluded.
    // In strict sense, `User` type has password.
    // We assume the user passed here is safe or we filter it just in case.

    const { password, ...rest } = user;

    return {
      user: rest,
      token: this.getJwtToken({ id: user.id }),
    };
  }

  private getJwtToken(payload: JwtPayload) {
    const token = this.jwtService.sign(payload);
    return token;
  }

  private handleDBErrors(error: any): never {
    if (error.code === 'P2002')
      throw new BadRequestException(
        'Conflicto: El recurso ya existe (clave duplicada)',
      );

    console.log(error);
    throw new InternalServerErrorException(
      'Error interno; por favor, revise los logs del servidor',
    );
  }

  async forgotPassword(email: string) {
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
    } catch (error) {
      console.error('Error sending email:', error);
    }

    return {
      message: 'Si el correo existe y está activo, se enviaron instrucciones',
    };
  }

  async validateResetToken(token: string) {
    const resetToken = await this.prisma.passwordResetToken.findFirst({
      where: { token },
      include: { user: true },
    });

    if (!resetToken) {
      throw new BadRequestException('Token inválido');
    }

    if (resetToken.used) {
      throw new BadRequestException('Token ya utilizado');
    }

    if (resetToken.expiresAt < new Date()) {
      throw new BadRequestException('Token expirado');
    }

    return { valid: true };
  }

  async resetPassword(resetPasswordDto: ResetPasswordDto) {
    const { token, newPassword } = resetPasswordDto;

    const resetToken = await this.prisma.passwordResetToken.findFirst({
      where: { token },
      include: { user: true },
    });

    if (!resetToken) {
      throw new BadRequestException('Token inválido');
    }

    if (resetToken.used) {
      throw new BadRequestException('Token ya utilizado');
    }

    if (resetToken.expiresAt < new Date()) {
      throw new BadRequestException('Token expirado');
    }

    const newHash = bcrypt.hashSync(newPassword, 10);

    // Transaction? Ideally yes, but sequential is fine for now
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
}
