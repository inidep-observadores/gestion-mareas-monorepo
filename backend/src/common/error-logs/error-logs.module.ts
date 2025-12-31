import { Module, forwardRef } from '@nestjs/common';
import { ErrorLogsService } from './error-logs.service';
import { ErrorLogsController } from './error-logs.controller';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/auth/auth.module';

@Module({
    controllers: [ErrorLogsController],
    providers: [ErrorLogsService],
    imports: [PrismaModule, forwardRef(() => AuthModule)],
    exports: [ErrorLogsService],
})
export class ErrorLogsModule { }
