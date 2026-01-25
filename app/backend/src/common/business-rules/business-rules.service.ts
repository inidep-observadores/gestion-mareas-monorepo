import { Injectable, Logger } from '@nestjs/common';

export type BusinessRules = {
    DIAS_NAVEGADOS_ANUALES: number;
    DIAS_DESCANSO_POST_MAREA: number;
    DIAS_EXCESO_TIERRA: number;
    PLAZO_ENTREGA_DATOS: number;
    PLAZO_CONFECCION_INFORME: number;
    PLAZO_PROTOCOLIZACION: number;
    PLAZO_RECHECK_CORTO: number;
    PLAZO_RECHECK_MEDIO: number;
    PLAZO_RECHECK_LARGO: number;
    UMBRAL_FATIGA_ANUAL_PORCENTAJE: number;
    ALERTA_DIAS_CORRIDOS: number;
};

@Injectable()
export class BusinessRulesService {
    private readonly logger = new Logger(BusinessRulesService.name);

    private readonly rules: BusinessRules = {
        DIAS_NAVEGADOS_ANUALES: 180,
        DIAS_DESCANSO_POST_MAREA: 15,
        DIAS_EXCESO_TIERRA: 60,
        PLAZO_ENTREGA_DATOS: 15,
        PLAZO_CONFECCION_INFORME: 7,
        PLAZO_PROTOCOLIZACION: 15,
        PLAZO_RECHECK_CORTO: 3,
        PLAZO_RECHECK_MEDIO: 7,
        PLAZO_RECHECK_LARGO: 15,
        UMBRAL_FATIGA_ANUAL_PORCENTAJE: 0.9,
        ALERTA_DIAS_CORRIDOS: 60,
    };

    getRules(): BusinessRules {
        this.logger.log('Entrega de reglas de negocio (in-memory)');
        return this.rules;
    }
}
