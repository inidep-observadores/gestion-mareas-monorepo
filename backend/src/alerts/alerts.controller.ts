import { Controller, Get, Post, Body, Patch, Param, Query, UseGuards, Request } from '@nestjs/common';
import { AlertsService } from './alerts.service';
import { CreateAlertDto } from './dto/create-alert.dto';
import { UpdateAlertDto } from './dto/update-alert.dto';
// import { AuthGuard } from '../auth/auth.guard'; // Assuming JWT guard exists

@Controller('alerts')
export class AlertsController {
    constructor(private readonly alertsService: AlertsService) { }

    @Post()
    create(@Body() createAlertDto: CreateAlertDto, @Request() req) {
        return this.alertsService.create(createAlertDto, req.user);
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
    update(@Param('id') id: string, @Body() updateAlertDto: UpdateAlertDto, @Request() req) {
        // Mock user if req.user is undefined during dev
        const user = req.user || { id: 'system', fullName: 'System' };
        return this.alertsService.update(id, updateAlertDto, user);
    }
}
