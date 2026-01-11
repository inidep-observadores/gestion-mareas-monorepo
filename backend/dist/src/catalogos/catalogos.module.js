"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CatalogosModule = void 0;
const common_1 = require("@nestjs/common");
const tipos_flota_controller_1 = require("./tipos-flota/tipos-flota.controller");
const tipos_flota_service_1 = require("./tipos-flota/tipos-flota.service");
const artes_pesca_controller_1 = require("./artes-pesca/artes-pesca.controller");
const artes_pesca_service_1 = require("./artes-pesca/artes-pesca.service");
const pesquerias_controller_1 = require("./pesquerias/pesquerias.controller");
const pesquerias_service_1 = require("./pesquerias/pesquerias.service");
const puertos_controller_1 = require("./puertos/puertos.controller");
const puertos_service_1 = require("./puertos/puertos.service");
const especies_controller_1 = require("./especies/especies.controller");
const especies_service_1 = require("./especies/especies.service");
const observadores_controller_1 = require("./observadores/observadores.controller");
const observadores_service_1 = require("./observadores/observadores.service");
const estados_marea_controller_1 = require("./estados-marea/estados-marea.controller");
const estados_marea_service_1 = require("./estados-marea/estados-marea.service");
const buques_controller_1 = require("./buques/buques.controller");
const buques_service_1 = require("./buques/buques.service");
const auth_module_1 = require("../auth/auth.module");
let CatalogosModule = class CatalogosModule {
};
exports.CatalogosModule = CatalogosModule;
exports.CatalogosModule = CatalogosModule = __decorate([
    (0, common_1.Module)({
        imports: [auth_module_1.AuthModule],
        controllers: [
            tipos_flota_controller_1.TiposFlotaController,
            artes_pesca_controller_1.ArtesPescaController,
            pesquerias_controller_1.PesqueriasController,
            puertos_controller_1.PuertosController,
            especies_controller_1.EspeciesController,
            observadores_controller_1.ObservadoresController,
            estados_marea_controller_1.EstadosMareaController,
            buques_controller_1.BuquesController,
        ],
        providers: [
            tipos_flota_service_1.TiposFlotaService,
            artes_pesca_service_1.ArtesPescaService,
            pesquerias_service_1.PesqueriasService,
            puertos_service_1.PuertosService,
            especies_service_1.EspeciesService,
            observadores_service_1.ObservadoresService,
            estados_marea_service_1.EstadosMareaService,
            buques_service_1.BuquesService,
        ]
    })
], CatalogosModule);
//# sourceMappingURL=catalogos.module.js.map