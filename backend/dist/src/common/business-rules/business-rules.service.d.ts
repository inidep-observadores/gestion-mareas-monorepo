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
export declare class BusinessRulesService {
    private readonly logger;
    private readonly rules;
    getRules(): BusinessRules;
}
