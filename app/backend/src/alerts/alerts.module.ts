import { Module, forwardRef } from '@nestjs/common';
import { AlertsService } from './alerts.service';
import { AlertsController } from './alerts.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { AlertAutomationService } from './alert-automation.service';
import { MareasModule } from '../mareas/mareas.module';

@Module({
    imports: [
        PrismaModule,
        AuthModule,
        forwardRef(() => MareasModule)
    ],
    controllers: [AlertsController],
    providers: [AlertsService, AlertAutomationService],
    exports: [AlertsService, AlertAutomationService]
})
export class AlertsModule { }
