import { Module } from '@nestjs/common';
import { CommonModule } from '../common/common.module';
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
        AuthModule,
        FilesModule,
        ConfigModule,
        CommonModule
    ],
    exports: [UsersService]
})
export class UsersModule { }
