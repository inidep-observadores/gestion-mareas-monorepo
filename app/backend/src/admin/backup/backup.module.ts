import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { BackupService } from './backup.service';
import { BackupController } from './backup.controller';
import { AuthModule } from '../../auth/auth.module';

@Module({
    imports: [ConfigModule, AuthModule],
    controllers: [BackupController],
    providers: [BackupService],
})
export class BackupModule { }
