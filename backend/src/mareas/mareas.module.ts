import { Module } from '@nestjs/common';
import { MareasService } from './mareas.service';
import { MareasController } from './mareas.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { AlertsModule } from '../alerts/alerts.module';

@Module({
    controllers: [MareasController],
    providers: [MareasService],
    imports: [PrismaModule, AuthModule, AlertsModule],
    exports: [MareasService],
})
export class MareasModule { }
