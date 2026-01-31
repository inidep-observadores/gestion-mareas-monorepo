import { Controller, Get, Param, Post, Query, Body, Patch, Res } from '@nestjs/common';
import { Response } from 'express';
import { MareasService } from './mareas.service';
import { DateUtils } from '../common/utils/date.utils';
import { Auth, GetUser } from '../auth/decorators';
import { User } from '@prisma/client';
import { CreateMareaDto } from './dto/create-marea.dto';
import { UpdateMareaDto } from './dto/update-marea.dto';

import { ClaimMareaDto } from './dto/claim-marea.dto';
import { ExportMareaDto } from './dto/export-marea.dto';
import { AuditEvent } from '../audit/decorators/audit-event.decorator';
import { AuditCategoria } from '../audit/enums/audit.enums';

@Controller('mareas')
@Auth()
export class MareasController {
    constructor(private readonly mareasService: MareasService) { }

    @Post('claim')
    sendClaim(
        @Body() dto: ClaimMareaDto,
        @GetUser() user: User
    ) {
        return this.mareasService.sendClaim(dto, user);
    }

    @Get('operativo')
    getDashboardOperativo(
        @Query('year') year?: string,
        @Query('showAll') showAll?: string
    ) {
        return this.mareasService.getDashboardOperativo(
            year ? Number(year) : undefined,
            showAll === 'true'
        );
    }

    @Get('kpis')
    getDashboardKpis(@Query('year') year?: string) {
        return this.mareasService.getDashboardKpis(year ? Number(year) : undefined);
    }

    @Get('inbox')
    getInbox(
        @Query('year') year: string,
        @GetUser() user: User
    ) {
        return this.mareasService.getInbox(year ? Number(year) : undefined, user);
    }

    @Get('flota-por-pesqueria')
    getFleetDistribution(@Query('year') year?: string) {
        return this.mareasService.getFleetDistributionByFishery(year ? Number(year) : undefined);
    }

    @Get('workforce/status')
    getWorkforceStatus(@Query('year') year?: string) {
        return this.mareasService.getWorkforceStatus(year ? Number(year) : undefined);
    }

    @Get('alertas/personal-fatiga')
    getFatigueAlerts(@Query('year') year?: string) {
        return this.mareasService.getFatigueAlerts(year ? Number(year) : undefined);
    }

    @Get('alertas/retrasos-criticos')
    getCriticalDelays(@Query('year') year?: string) {
        return this.mareasService.getCriticalDelays(year ? Number(year) : undefined);
    }

    @Get('alertas/informes-demorados')
    getReportDelays(@Query('year') year?: string) {
        return this.mareasService.getReportDelays(year ? Number(year) : undefined);
    }

    @Get('calendar/events')
    getCalendarEvents(@Query('year') year?: string) {
        return this.mareasService.getCalendarEvents(year ? Number(year) : undefined);
    }

    @Get('search')
    search(@Query('q') q: string) {
        return this.mareasService.search(q);
    }

    @Get('movimientos-recientes')
    getRecentMovements(@Query('days') days?: string) {
        return this.mareasService.getRecentMovements(days ? Number(days) : 7);
    }

    @Post('export/excel')
    async exportExcel(
        @Body() dto: ExportMareaDto,
        @Res() res: Response
    ) {
        const workbook = await this.mareasService.exportToExcel(
            dto.year || DateUtils.getNow().getFullYear(),
            dto.searchQuery,
            dto.ids
        );

        res.setHeader(
            'Content-Type',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        );
        res.setHeader(
            'Content-Disposition',
            `attachment; filename=MAREAS_${dto.year || DateUtils.getNow().getFullYear()}.xlsx`,
        );

        await workbook.xlsx.write(res);
        res.end();
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.mareasService.findOne(id);
    }

    @Patch(':id')
    update(@Param('id') id: string, @Body() updateMareaDto: UpdateMareaDto) {
        return this.mareasService.update(id, updateMareaDto);
    }

    @Get(':id/context')
    getMareaContext(@Param('id') id: string) {
        return this.mareasService.getMareaContext(id);
    }

    @Post(':id/actions/:actionKey')
    @AuditEvent({
        tipoEvento: 'EJECUTAR_ACCION_FLUJO',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Ejecución de acción de cambio de estado en marea'
    })
    executeAction(
        @Param('id') id: string,
        @Param('actionKey') actionKey: string,
        @GetUser() user: User,
        @Body() payload: any
    ) {
        return this.mareasService.executeAction(id, actionKey, user, payload);
    }

    @Post()
    @AuditEvent({
        tipoEvento: 'CREAR_MAREA',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Creación de una nueva marea en el sistema'
    })
    createMarea(
        @Body() createMareaDto: CreateMareaDto,
        @GetUser() user: User
    ) {
        return this.mareasService.create(createMareaDto, user);
    }
}
