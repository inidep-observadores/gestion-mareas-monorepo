import { Module, Global } from '@nestjs/common';
import { BullModule } from '@nestjs/bull';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuditService } from './services/audit.service';
import { AuditQueueProcessor } from './processors/audit.processor';
import { PrismaModule } from '../prisma/prisma.module';
import { AuditController } from './controllers/audit.controller';

@Global()
@Module({
    imports: [
        PrismaModule,
        BullModule.registerQueueAsync({
            name: 'audit',
            imports: [ConfigModule],
            useFactory: async (configService: ConfigService) => ({
                redis: {
                    host: configService.get('REDIS_HOST', 'localhost'),
                    port: configService.get('REDIS_PORT', 6379),
                },
            }),
            inject: [ConfigService],
        }),
    ],
    controllers: [AuditController],
    providers: [AuditService, AuditQueueProcessor],
    exports: [AuditService],
})
export class AuditModule { }
