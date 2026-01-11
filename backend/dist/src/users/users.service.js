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
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const interfaces_1 = require("../auth/interfaces");
const hash_service_1 = require("../common/services/hash.service");
let UsersService = class UsersService {
    constructor(prisma, hashService) {
        this.prisma = prisma;
        this.hashService = hashService;
    }
    async updateProfile(user, updateUserDto) {
        try {
            const updatedUser = await this.prisma.user.update({
                where: { id: user.id },
                data: {
                    ...updateUserDto
                }
            });
            const { password, ...rest } = updatedUser;
            return rest;
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async changePassword(user, changePasswordDto) {
        const { currentPassword, newPassword } = changePasswordDto;
        const contextUser = await this.prisma.user.findUnique({
            where: { id: user.id }
        });
        if (!contextUser)
            throw new common_1.UnauthorizedException('Usuario no encontrado');
        if (!this.hashService.compare(currentPassword, contextUser.password)) {
            throw new common_1.UnauthorizedException('La contraseña actual es incorrecta');
        }
        const hashedPassword = this.hashService.hash(newPassword);
        await this.prisma.user.update({
            where: { id: user.id },
            data: { password: hashedPassword }
        });
        return { message: 'Contraseña actualizada correctamente' };
    }
    async updateAvatar(user, avatarUrl) {
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
    async create(createUserDto) {
        try {
            const { password, ...userData } = createUserDto;
            const user = await this.prisma.user.create({
                data: {
                    ...userData,
                    password: this.hashService.hash(password),
                }
            });
            const { password: _, ...rest } = user;
            return rest;
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async update(id, adminUpdateUserDto, currentUser) {
        const { password, ...data } = adminUpdateUserDto;
        if (id === currentUser.id) {
            if (data.roles && !data.roles.includes(interfaces_1.ValidRoles.admin)) {
                throw new common_1.BadRequestException('No puedes quitarte el rol de administrador a ti mismo');
            }
            if (data.isActive === false) {
                throw new common_1.BadRequestException('No puedes desactivarte a ti mismo');
            }
        }
        try {
            const updateData = { ...data };
            if (password) {
                updateData.password = this.hashService.hash(password);
            }
            const user = await this.prisma.user.update({
                where: { id },
                data: updateData
            });
            const { password: _, ...rest } = user;
            return rest;
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async toggleStatus(id, currentUser) {
        if (id === currentUser.id) {
            throw new common_1.BadRequestException('No puedes desactivarte a ti mismo');
        }
        const user = await this.prisma.user.findUnique({ where: { id } });
        if (!user)
            throw new common_1.NotFoundException('Usuario no encontrado');
        return this.prisma.user.update({
            where: { id },
            data: { isActive: !user.isActive }
        });
    }
    async remove(id, currentUser) {
        if (id === currentUser.id) {
            throw new common_1.BadRequestException('No puedes eliminarte a ti mismo');
        }
        try {
            return await this.prisma.user.delete({ where: { id } });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    handleDBErrors(error) {
        if (error.code === 'P2002')
            throw new common_1.BadRequestException('Ya existe un registro con ese valor único');
        console.log(error);
        throw new common_1.InternalServerErrorException('Por favor revise los logs del servidor');
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        hash_service_1.HashService])
], UsersService);
//# sourceMappingURL=users.service.js.map