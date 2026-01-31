import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { AuditService } from '../services/audit.service';
import { AuditQueryDto } from '../dto/audit-query.dto';
import { AuthGuard } from '@nestjs/passport';
// Import RolesGuard if available, otherwise just use AuthGuard for now
// import { RolesGuard } from '../../auth/guards/roles.guard';
// import { Roles } from '../../auth/decorators/roles.decorator';

@Controller('audit')
// @UseGuards(AuthGuard('jwt'), RolesGuard)
@UseGuards(AuthGuard('jwt'))
export class AuditController {
    constructor(private readonly auditService: AuditService) { }

    @Get('api')
    // @Roles('admin')
    async getApiLogs(@Query() query: AuditQueryDto) {
        return this.auditService.findApiLogs(query);
    }

    @Get('entidades')
    // @Roles('admin')
    async getEntityLogs(@Query() query: AuditQueryDto) {
        return this.auditService.findEntityLogs(query);
    }

    @Get('eventos')
    // @Roles('admin')
    async getEventLogs(@Query() query: AuditQueryDto) {
        return this.auditService.findEventLogs(query);
    }
}
