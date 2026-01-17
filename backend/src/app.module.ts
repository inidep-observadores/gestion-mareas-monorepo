import { join } from 'path';

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module';
import { ServeStaticModule } from '@nestjs/serve-static';

import { ProductsModule } from './products/products.module';
import { CommonModule } from './common/common.module';
import { SeedModule } from './seed/seed.module';
import { FilesModule } from './files/files.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { CatalogosModule } from './catalogos/catalogos.module';
import { MareasModule } from './mareas/mareas.module';
import { BackupModule } from './admin/backup/backup.module';
import { DataExportModule } from './admin/data-export/data-export.module';
import { MailModule } from './mail/mail.module';
import { AlertsModule } from './alerts/alerts.module';
import { BusinessRulesModule } from './common/business-rules/business-rules.module';
import { AccessImportModule } from './access-import/access-import.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      expandVariables: true,
    }),



    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'public'),
    }),

    PrismaModule,

    ProductsModule,

    CommonModule,
    BusinessRulesModule,

    SeedModule,

    FilesModule,

    AuthModule,

    UsersModule,

    CatalogosModule,
    MareasModule,
    BackupModule,
    DataExportModule,
    MailModule,
    AlertsModule,
    AccessImportModule,
  ],
})
export class AppModule { }
