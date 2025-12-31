import { Module } from '@nestjs/common';
import { MareasService } from './mareas.service';
import { MareasController } from './mareas.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';

@Module({
    controllers: [MareasController],
    providers: [MareasService],
    imports: [PrismaModule, AuthModule],
    exports: [MareasService],
})
export class MareasModule { }
