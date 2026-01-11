"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const path_1 = require("path");
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const prisma_module_1 = require("./prisma/prisma.module");
const serve_static_1 = require("@nestjs/serve-static");
const products_module_1 = require("./products/products.module");
const common_module_1 = require("./common/common.module");
const seed_module_1 = require("./seed/seed.module");
const files_module_1 = require("./files/files.module");
const auth_module_1 = require("./auth/auth.module");
const users_module_1 = require("./users/users.module");
const catalogos_module_1 = require("./catalogos/catalogos.module");
const mareas_module_1 = require("./mareas/mareas.module");
const backup_module_1 = require("./admin/backup/backup.module");
const data_export_module_1 = require("./admin/data-export/data-export.module");
const mail_module_1 = require("./mail/mail.module");
const alerts_module_1 = require("./alerts/alerts.module");
const business_rules_module_1 = require("./common/business-rules/business-rules.module");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot(),
            serve_static_1.ServeStaticModule.forRoot({
                rootPath: (0, path_1.join)(__dirname, '..', 'public'),
            }),
            prisma_module_1.PrismaModule,
            products_module_1.ProductsModule,
            common_module_1.CommonModule,
            business_rules_module_1.BusinessRulesModule,
            seed_module_1.SeedModule,
            files_module_1.FilesModule,
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            catalogos_module_1.CatalogosModule,
            mareas_module_1.MareasModule,
            backup_module_1.BackupModule,
            data_export_module_1.DataExportModule,
            data_export_module_1.DataExportModule,
            mail_module_1.MailModule,
            alerts_module_1.AlertsModule,
        ],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map