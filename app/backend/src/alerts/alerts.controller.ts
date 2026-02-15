import { Controller, Get, Post, Body, Patch, Param, Query, Request } from '@nestjs/common';
import { AlertsService } from './alerts.service';
import { CreateAlertDto } from './dto/create-alert.dto';
import { UpdateAlertDto } from './dto/update-alert.dto';
import { AlertAutomationService } from './alert-automation.service';
import { Auth, GetUser } from '../auth/decorators';
import { User } from '@prisma/client';

import { ValidRoles } from '../auth/interfaces';

@Controller('alerts')
@Auth()
export class AlertsController {
    constructor(
        private readonly alertsService: AlertsService,
        private readonly automationService: AlertAutomationService
    ) { }

    @Post()
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    create(@Body() createAlertDto: CreateAlertDto, @GetUser() user: User) {
        return this.alertsService.create(createAlertDto, user);
    }

    @Get()
    findAll(@Query() query: any) {
        return this.alertsService.findAll(query);
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.alertsService.findOne(id);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    update(
        @Param('id') id: string,
        @Body() updateAlertDto: UpdateAlertDto,
        @GetUser() user: User
    ) {
        return this.alertsService.update(id, updateAlertDto, user);
    }

    @Post('automation/batch')
    @Auth(ValidRoles.admin)
    processBatch() {
        return this.automationService.processBatch();
    }
}
