import { Module } from '@nestjs/common';
import { AccessImportController } from './access-import.controller';
import { AccessImportService } from './access-import.service';
import { AccessReaderService } from './access-reader.service';
import { PrismaModule } from '../prisma/prisma.module';
import { AlertsModule } from '../alerts/alerts.module';
import { ErrorLogsModule } from '../common/error-logs/error-logs.module';
import { AuthModule } from '../auth/auth.module';

@Module({
    imports: [PrismaModule, AlertsModule, ErrorLogsModule, AuthModule],
    controllers: [AccessImportController],
    providers: [AccessImportService, AccessReaderService],
    exports: [AccessImportService], // Exportamos por si otros módulos quieren usarlo a futuro
})
export class AccessImportModule { }
