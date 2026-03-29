import { Controller, Get, Param, Post, Query, Body, Patch, Res } from '@nestjs/common';
import { Response } from 'express';
import { MareasService } from './mareas.service';
import { DateUtils } from '../common/utils/date.utils';
import { Auth, GetUser } from '../auth/decorators';
import { User } from '@prisma/client';
import { ValidRoles } from '../auth/interfaces';
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
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
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
    getWorkforceStatus(
        @Query('year') year?: string,
        @Query('role') role?: string
    ) {
        return this.mareasService.getWorkforceStatus(year ? Number(year) : undefined, role);
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
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    update(
        @Param('id') id: string,
        @Body() updateMareaDto: UpdateMareaDto,
        @GetUser() user: User
    ) {
        return this.mareasService.update(id, updateMareaDto, user);
    }

    @Get(':id/context')
    getMareaContext(@Param('id') id: string) {
        return this.mareasService.getMareaContext(id);
    }

    @Get(':id/zona-austral')
    getZonaAustral(@Param('id') id: string) {
        return this.mareasService.getZonaAustralDays(id);
    }

    @Get('valida/buque/:id')
    async validarBuque(@Param('id') id: string) {
        return this.mareasService.checkVesselAvailability(id);
    }

    @Get('valida/observador/:id')
    async validarObservador(@Param('id') id: string) {
        return this.mareasService.checkObserverAvailability(id);
    }

    @Get('config/proximo-numero')
    getNextMareaNumber(
        @Query('year') year: string,
        @Query('tipo') tipo: string
    ) {
        return this.mareasService.getNextMareaNumber(Number(year), tipo as any);
    }

    @Post(':id/actions/:actionKey')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
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

    @Patch(':id/etapas/:etapaId/intencion-cierre')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    @AuditEvent({
        tipoEvento: 'ACTUALIZAR_INTENCION_CIERRE',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Modificación de la intención de cierre de marea al arribo'
    })
    setIntencionCierre(
        @Param('id') id: string,
        @Param('etapaId') etapaId: string,
        @Body('activar') activar: boolean,
        @GetUser() user: User
    ) {
        return this.mareasService.setIntencionCierreMarea(id, etapaId, activar, user);
    }

    @Post()
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
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
