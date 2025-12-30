import { Controller, Get, Body, Patch, UseGuards, UseInterceptors, UploadedFile, BadRequestException, Post } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { FileInterceptor } from '@nestjs/platform-express';
import { ConfigService } from '@nestjs/config';
import { diskStorage } from 'multer';

import { UsersService } from './users.service';
import { GetUser } from '../auth/decorators';
import { User } from '@prisma/client';
import { UpdateUserDto, ChangePasswordDto } from './dto';
import { fileFilter, fileNamer } from '../files/helpers';

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


}
