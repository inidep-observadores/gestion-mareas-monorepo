import { Module } from '@nestjs/common';
import { DataExportService } from './data-export.service';
import { DataExportController } from './data-export.controller';
import { PrismaService } from 'src/prisma/prisma.service';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from '../../auth/auth.module';

import { PrismaModule } from 'src/prisma/prisma.module';

@Module({
    imports: [ConfigModule, AuthModule, PrismaModule],
    controllers: [DataExportController],
    providers: [DataExportService],
})
export class DataExportModule { }
