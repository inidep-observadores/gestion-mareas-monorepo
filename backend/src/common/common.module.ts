import { Module } from '@nestjs/common';
import { APP_FILTER } from '@nestjs/core';
import { JwtModule } from '@nestjs/jwt';
import { HashService } from './services/hash.service';
import { ErrorLogsModule } from './error-logs/error-logs.module';
import { AllExceptionsFilter } from './filters/all-exceptions.filter';

@Module({
    providers: [
        HashService,
        {
            provide: APP_FILTER,
            useClass: AllExceptionsFilter,
        },
    ],
    exports: [HashService],
    imports: [ErrorLogsModule, JwtModule],
})
export class CommonModule { }
