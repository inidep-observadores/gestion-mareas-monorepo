import { Controller, Get, Post, Body, Patch, Param, Query, Request } from '@nestjs/common';
import { AlertsService } from './alerts.service';
import { CreateAlertDto } from './dto/create-alert.dto';
import { UpdateAlertDto } from './dto/update-alert.dto';
import { Auth, GetUser } from '../auth/decorators';
import { User } from '@prisma/client';

@Controller('alerts')
@Auth()
export class AlertsController {
    constructor(private readonly alertsService: AlertsService) { }

    @Post()
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
    update(
        @Param('id') id: string,
        @Body() updateAlertDto: UpdateAlertDto,
        @GetUser() user: User
    ) {
        return this.alertsService.update(id, updateAlertDto, user);
    }
}
