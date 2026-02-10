import { Controller, Post } from '@nestjs/common';
import { Auth } from '../auth/decorators/auth.decorator';
import { ValidRoles } from '../auth/interfaces/valid-roles';
import { PnaTrackingService } from './pna-tracking.service';

@Controller('pna-api')
export class PnaApiController {
    constructor(private readonly pnaTrackingService: PnaTrackingService) { }

    @Post('sync-tracking')
    @Auth(ValidRoles.admin)
    async triggerTrackingSync() {
        return this.pnaTrackingService.scheduleSynchronization();
    }
}
