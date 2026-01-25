import { BusinessRulesService } from './business-rules.service';
export declare class BusinessRulesController {
    private readonly businessRulesService;
    private readonly logger;
    constructor(businessRulesService: BusinessRulesService);
    getBusinessRules(): import("./business-rules.service").BusinessRules;
}
