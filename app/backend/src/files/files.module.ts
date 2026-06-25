import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { FilesService } from './files.service';
import { FilesController } from './files.controller';
import { DriveStorageService } from './drive-storage.service';

@Global()
@Module({
  controllers: [FilesController],
  providers: [FilesService, DriveStorageService],
  imports: [
    ConfigModule
  ],
  exports: [FilesService, DriveStorageService]
})
export class FilesModule {}
