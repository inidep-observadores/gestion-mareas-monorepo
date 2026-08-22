import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { FilesService } from './files.service';
import { FilesController } from './files.controller';
import { DriveStorageService } from './drive-storage.service';
import { GotenbergService } from './gotenberg.service';
import { ErrorLogsModule } from '../common/error-logs/error-logs.module';

@Global()
@Module({
  controllers: [FilesController],
  providers: [FilesService, DriveStorageService, GotenbergService],
  imports: [
    ConfigModule,
    ErrorLogsModule
  ],
  exports: [FilesService, DriveStorageService, GotenbergService]
})
export class FilesModule {}
