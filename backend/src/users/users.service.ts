import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateUserDto, ChangePasswordDto } from './dto';
import * as bcrypt from 'bcrypt';
import { User } from '@prisma/client';

@Injectable()
export class UsersService {
    constructor(
        private readonly prisma: PrismaService,
    ) { }

    async updateProfile(user: User, updateUserDto: UpdateUserDto) {
        try {
            const updatedUser = await this.prisma.user.update({
                where: { id: user.id },
                data: {
                    ...updateUserDto
                }
            });

            const { password, ...rest } = updatedUser;
            return rest;
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async changePassword(user: User, changePasswordDto: ChangePasswordDto) {
        const { currentPassword, newPassword } = changePasswordDto;

        // Verify current password
        // We need to fetch the user with password because specific strategies might exclude it, 
        // but here we have the user object coming from the request which typically has the password included from the Strategy 
        // Wait, the JWT strategy usually returns the user WITHOUT the password if we excluded it in the query.
        // Let's check the request user first. If not, we fetch it.

        const contextUser = await this.prisma.user.findUnique({
            where: { id: user.id }
        });

        if (!contextUser) throw new UnauthorizedException('Usuario no encontrado');

        if (!bcrypt.compareSync(currentPassword, contextUser.password)) {
            throw new UnauthorizedException('La contraseña actual es incorrecta');
        }

        const hashedPassword = bcrypt.hashSync(newPassword, 10);

        await this.prisma.user.update({
            where: { id: user.id },
            data: { password: hashedPassword }
        });

        return { message: 'Contraseña actualizada correctamente' };
    }

    async updateAvatar(user: User, avatarUrl: string) {
        const updatedUser = await this.prisma.user.update({
            where: { id: user.id },
            data: { avatarUrl }
        });

        const { password, ...rest } = updatedUser;
        return rest;
    }

    private handleDBErrors(error: any): never {
        if (error.code === 'P2002')
            throw new BadRequestException('Ya existe un registro con ese valor único');

        console.log(error);
        throw new InternalServerErrorException('Por favor revise los logs del servidor');
    }
}
