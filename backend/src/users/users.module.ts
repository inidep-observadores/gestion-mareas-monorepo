import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { FilesModule } from '../files/files.module'; // To reuse file upload logic if needed, or I might implement it here

@Module({
    controllers: [UsersController],
    providers: [UsersService],
    imports: [
        PrismaModule,
        AuthModule, // To access Auth guards and decorators
        FilesModule, // If I want to reuse specific file logic, though I might just use the Service
        ConfigModule
    ],
    exports: [UsersService]
})
export class UsersModule { }
