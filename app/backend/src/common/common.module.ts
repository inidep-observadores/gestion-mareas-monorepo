import { Module } from '@nestjs/common';
import { APP_FILTER } from '@nestjs/core';
import { JwtModule } from '@nestjs/jwt';
import { HashService } from './services/hash.service';
import { ErrorLogsModule } from './error-logs/error-logs.module';
import { AllExceptionsFilter } from './filters/all-exceptions.filter';
import { EventCorrelationService } from './services/event-correlation.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
    providers: [
        HashService,
        EventCorrelationService,
        {
            provide: APP_FILTER,
            useClass: AllExceptionsFilter,
        },
    ],
    exports: [HashService, EventCorrelationService],
    imports: [ErrorLogsModule, JwtModule, PrismaModule],
})
export class CommonModule { }
