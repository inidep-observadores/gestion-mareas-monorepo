import { Module } from '@nestjs/common';
import { AlertsService } from './alerts.service';
import { AlertsController } from './alerts.controller';
import { PrismaModule } from '../prisma/prisma.module';
// import { AuthModule } from '../auth/auth.module'; // If needed for guards

@Module({
    imports: [PrismaModule],
    controllers: [AlertsController],
    providers: [AlertsService],
    exports: [AlertsService]
})
export class AlertsModule { }
