import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { AuditService } from '../services/audit.service';
import { AuditQueryDto } from '../dto/audit-query.dto';
import { CreateAuditoriaNavegacionDto } from '../dto/create-auditoria-navegacion.dto';
import { Auth } from '../../auth/decorators/auth.decorator';
import { GetUser } from '../../auth/decorators/get-user.decorator';
import { User } from '@prisma/client';
import { ValidRoles } from '../../auth/interfaces/valid-roles';

@Controller('audit')
@Auth(ValidRoles.admin)
export class AuditController {
    constructor(private readonly auditService: AuditService) { }

    @Get('api')
    async getApiLogs(@Query() query: AuditQueryDto) {
        return this.auditService.findApiLogs(query);
    }

    @Get('entidades')
    async getEntityLogs(@Query() query: AuditQueryDto) {
        return this.auditService.findEntityLogs(query);
    }

    @Get('eventos')
    async getEventLogs(@Query() query: AuditQueryDto) {
        return this.auditService.findEventLogs(query);
    }

    @Get('navegacion')
    async getNavigationLogs(@Query() query: AuditQueryDto) {
        return this.auditService.findNavigationLogs(query);
    }

    @Post('navigation')
    @Auth() // Allow any authenticated user to log their navigation
    async logNavigation(@Body() dto: CreateAuditoriaNavegacionDto, @GetUser() user: User) {
        // Enlazar con el usuario actual si no viene en el DTO
        if (!dto.usuarioId) dto.usuarioId = user.id;
        return this.auditService.logNavegacion(dto);
    }
}
