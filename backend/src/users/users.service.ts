import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateUserDto, ChangePasswordDto, CreateUserDto, AdminUpdateUserDto } from './dto';
import { ValidRoles } from '../auth/interfaces';
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

    async findAll() {
        return this.prisma.user.findMany({
            orderBy: { fullName: 'asc' }
        });
    }

    async create(createUserDto: CreateUserDto) {
        try {
            const { password, ...userData } = createUserDto;

            const user = await this.prisma.user.create({
                data: {
                    ...userData,
                    password: bcrypt.hashSync(password, 10),
                }
            });

            const { password: _, ...rest } = user;
            return rest;
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async update(id: string, adminUpdateUserDto: AdminUpdateUserDto, currentUser: User) {
        const { password, ...data } = adminUpdateUserDto;

        // Protections
        if (id === currentUser.id) {
            // Admin cannot remove 'admin' role from themselves
            if (data.roles && !data.roles.includes(ValidRoles.admin)) {
                throw new BadRequestException('No puedes quitarte el rol de administrador a ti mismo');
            }
            // Admin cannot deactivate themselves (though this is usually handled in toggleStatus, checks here for safety)
            if (data.isActive === false) {
                throw new BadRequestException('No puedes desactivarte a ti mismo');
            }
        }

        try {
            const updateData: any = { ...data };
            if (password) {
                updateData.password = bcrypt.hashSync(password, 10);
            }

            const user = await this.prisma.user.update({
                where: { id },
                data: updateData
            });

            const { password: _, ...rest } = user;
            return rest;
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async toggleStatus(id: string, currentUser: User) {
        if (id === currentUser.id) {
            throw new BadRequestException('No puedes desactivarte a ti mismo');
        }

        const user = await this.prisma.user.findUnique({ where: { id } });
        if (!user) throw new NotFoundException('Usuario no encontrado');

        return this.prisma.user.update({
            where: { id },
            data: { isActive: !user.isActive }
        });
    }

    async remove(id: string, currentUser: User) {
        if (id === currentUser.id) {
            throw new BadRequestException('No puedes eliminarte a ti mismo');
        }

        // Extra check: Check if user exists before deleting? Prisma throws if not found usually.
        try {
            return await this.prisma.user.delete({ where: { id } });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    private handleDBErrors(error: any): never {
        if (error.code === 'P2002')
            throw new BadRequestException('Ya existe un registro con ese valor único');

        console.log(error);
        throw new InternalServerErrorException('Por favor revise los logs del servidor');
    }
}
