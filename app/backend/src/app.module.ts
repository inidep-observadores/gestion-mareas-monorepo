import { join } from 'path';

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module';
import { ServeStaticModule } from '@nestjs/serve-static';

import { ProductsModule } from './products/products.module';
import { CommonModule } from './common/common.module';
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
import { StatsModule } from './stats/stats.module';
import { AuditModule } from './audit/audit.module';
import { JobsModule } from './jobs/jobs.module';
import { PnaApiModule } from './pna-api/pna-api.module';
import { UserContextMiddleware } from './common/middlewares/user-context.middleware';


import { APP_INTERCEPTOR } from '@nestjs/core';
import { NestModule, MiddlewareConsumer } from '@nestjs/common';
import { AuditInterceptor } from './audit/interceptors/audit.interceptor';
import { AuditEventInterceptor } from './audit/interceptors/audit-event.interceptor';

import { auditConfig } from './common/config/audit.config';
import { PlanificacionModule } from './planificacion/planificacion.module';
import { ReportsModule } from './reports/reports.module';
import { PresentismoModule } from './presentismo/presentismo.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [auditConfig],
      expandVariables: true,
    }),



    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'public'),
    }),

    PrismaModule,

    ProductsModule,

    CommonModule,
    BusinessRulesModule,

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
    StatsModule,
    AuditModule,
    JobsModule,
    PnaApiModule,
    PlanificacionModule,
    ReportsModule,
    PresentismoModule,
  ],

  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: AuditInterceptor,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: AuditEventInterceptor,
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(UserContextMiddleware)
      .forRoutes('*');
  }
}
