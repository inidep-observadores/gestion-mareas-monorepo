import { Controller, Get, Body, Patch, UseGuards, Post, Delete, Param } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';

import { UsersService } from './users.service';
import { GetUser, Auth } from '../auth/decorators';
import { User } from '@prisma/client';
import { UpdateUserDto, ChangePasswordDto, CreateUserDto, AdminUpdateUserDto } from './dto';
import { ValidRoles } from '../auth/interfaces';
import { AuditEvent } from '../audit/decorators/audit-event.decorator';
import { AuditCategoria } from '../audit/enums/audit.enums';

@Controller('users')
@UseGuards(AuthGuard())
export class UsersController {
    constructor(
        private readonly usersService: UsersService,
        private readonly configService: ConfigService,
    ) { }

    @Get('me')
    getProfile(@GetUser() user: User) {
        return user;
    }

    @Patch('me')
    updateProfile(
        @GetUser() user: User,
        @Body() updateUserDto: UpdateUserDto
    ) {
        return this.usersService.updateProfile(user, updateUserDto);
    }

    @Patch('me/password')
    changePassword(
        @GetUser() user: User,
        @Body() changePasswordDto: ChangePasswordDto
    ) {
        return this.usersService.changePassword(user, changePasswordDto);
    }

    @Get()
    @Auth(ValidRoles.admin, ValidRoles.tecnico, ValidRoles.coordinador)
    findAll() {
        return this.usersService.findAll();
    }

    @Post()
    @Auth(ValidRoles.admin)
    create(@Body() createUserDto: CreateUserDto) {
        return this.usersService.create(createUserDto);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin)
    update(
        @Param('id') id: string,
        @Body() adminUpdateUserDto: AdminUpdateUserDto,
        @GetUser() user: User
    ) {
        return this.usersService.update(id, adminUpdateUserDto, user);
    }

    @Patch(':id/toggle-status')
    @Auth(ValidRoles.admin)
    @AuditEvent({
        tipoEvento: 'CAMBIAR_ESTADO_USUARIO',
        categoria: AuditCategoria.USUARIOS,
        descripcion: 'Activación/Desactivación de cuenta de usuario por administrador'
    })
    toggleStatus(
        @Param('id') id: string,
        @GetUser() user: User
    ) {
        return this.usersService.toggleStatus(id, user);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    @AuditEvent({
        tipoEvento: 'ELIMINAR_USUARIO',
        categoria: AuditCategoria.USUARIOS,
        descripcion: 'Eliminación permanente de usuario del sistema'
    })
    remove(
        @Param('id') id: string,
        @GetUser() user: User
    ) {
        return this.usersService.remove(id, user);
    }
}
