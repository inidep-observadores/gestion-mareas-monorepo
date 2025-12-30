import { Module } from '@nestjs/common';
import { TiposFlotaController } from './tipos-flota/tipos-flota.controller';
import { TiposFlotaService } from './tipos-flota/tipos-flota.service';
import { ArtesPescaController } from './artes-pesca/artes-pesca.controller';
import { ArtesPescaService } from './artes-pesca/artes-pesca.service';
import { PesqueriasController } from './pesquerias/pesquerias.controller';
import { PesqueriasService } from './pesquerias/pesquerias.service';
import { PuertosController } from './puertos/puertos.controller';
import { PuertosService } from './puertos/puertos.service';
import { EspeciesController } from './especies/especies.controller';
import { EspeciesService } from './especies/especies.service';
import { ObservadoresController } from './observadores/observadores.controller';
import { ObservadoresService } from './observadores/observadores.service';
import { EstadosMareaController } from './estados-marea/estados-marea.controller';
import { EstadosMareaService } from './estados-marea/estados-marea.service';
import { BuquesController } from './buques/buques.controller';
import { BuquesService } from './buques/buques.service';
import { AuthModule } from '../auth/auth.module';

@Module({
    imports: [AuthModule],
    controllers: [
        TiposFlotaController,
        ArtesPescaController,
        PesqueriasController,
        PuertosController,
        EspeciesController,
        ObservadoresController,
        EstadosMareaController,
        BuquesController,
    ],
    providers: [
        TiposFlotaService,
        ArtesPescaService,
        PesqueriasService,
        PuertosService,
        EspeciesService,
        ObservadoresService,
        EstadosMareaService,
        BuquesService,
    ]
})
export class CatalogosModule { }
