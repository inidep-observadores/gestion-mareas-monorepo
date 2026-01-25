import { Controller, Get, Logger } from '@nestjs/common';
import { BusinessRulesService } from './business-rules.service';

@Controller('config')
export class BusinessRulesController {
    private readonly logger = new Logger(BusinessRulesController.name);

    constructor(private readonly businessRulesService: BusinessRulesService) { }

    @Get('reglas')
    getBusinessRules() {
        this.logger.log('Solicitud recibida: GET /config/reglas');
        try {
            const rules = this.businessRulesService.getRules();
            this.logger.log('Reglas de negocio entregadas correctamente');
            return rules;
        } catch (error) {
            this.logger.error('Error al obtener reglas de negocio', error as Error);
            throw error;
        }
    }
}
