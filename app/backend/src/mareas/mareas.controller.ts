import { Controller, Get, Param, Post, Query, Body, Patch, Res, UseInterceptors, UploadedFiles, Delete } from '@nestjs/common';
import { AnyFilesInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import { MareasService } from './mareas.service';
import { DateUtils } from '../common/utils/date.utils';
import { Auth, GetUser } from '../auth/decorators';
import { User } from '@prisma/client';
import { ValidRoles } from '../auth/interfaces';
import { CreateMareaDto } from './dto/create-marea.dto';
import { UpdateMareaDto } from './dto/update-marea.dto';
import { MareaEstado } from './mareas.constants';

import { ClaimMareaDto } from './dto/claim-marea.dto';
import { ExportMareaDto } from './dto/export-marea.dto';
import { AuditEvent } from '../audit/decorators/audit-event.decorator';
import { AuditCategoria } from '../audit/enums/audit.enums';
import { EnviarProtocolizacionDto } from './dto/enviar-protocolizacion.dto';
import { ConfirmarProtocolizacionDto } from './dto/confirmar-protocolizacion.dto';
import { ParseJsonPipe } from '../common/pipes/parse-json.pipe';
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

    @Get('por-observador/:observadorId')
    getMareasByObservador(@Param('observadorId') observadorId: string) {
        return this.mareasService.getMareasByObservador(observadorId);
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.mareasService.findOne(id);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    @UseInterceptors(AnyFilesInterceptor())
    update(
        @Param('id') id: string,
        @Body(ParseJsonPipe) updateMareaDto: UpdateMareaDto,
        @UploadedFiles() files: Array<Express.Multer.File>,
        @GetUser() user: User
    ) {
        return this.mareasService.update(id, updateMareaDto, files, user);
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
    @UseInterceptors(AnyFilesInterceptor())
    @AuditEvent({
        tipoEvento: 'EJECUTAR_ACCION_FLUJO',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Ejecución de acción de cambio de estado en marea'
    })
    executeAction(
        @Param('id') id: string,
        @Param('actionKey') actionKey: string,
        @GetUser() user: User,
        @Body() payload: any,
        @UploadedFiles() files?: Array<Express.Multer.File>
    ) {
        return this.mareasService.executeAction(id, actionKey, user, payload, files);
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

    @Post('protocolizacion/enviar')
    @Auth(ValidRoles.admin, ValidRoles.coordinador)
    @UseInterceptors(AnyFilesInterceptor())
    @AuditEvent({
        tipoEvento: 'ENVIAR_PROTOCOLIZACION',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Envío en lote de mareas a protocolizar'
    })
    enviarAProtocolizacion(
        @Body() dto: EnviarProtocolizacionDto,
        @UploadedFiles() files: Array<Express.Multer.File>,
        @GetUser() user: User
    ) {
        return this.mareasService.enviarAProtocolizacion(dto, files, user);
    }

    @Post('protocolizacion/confirmar/:id')
    @Auth(ValidRoles.admin, ValidRoles.coordinador)
    @AuditEvent({
        tipoEvento: 'CONFIRMAR_PROTOCOLIZACION',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Confirmación de datos de protocolización de marea'
    })
    confirmarProtocolizacion(
        @Param('id') id: string,
        @Body() dto: ConfirmarProtocolizacionDto,
        @GetUser() user: User
    ) {
        return this.mareasService.confirmarProtocolizacion(id, dto, user);
    }

    @Get('protocolizacion/pendientes')
    @Auth(ValidRoles.admin, ValidRoles.coordinador)
    getProtocolizacionPendientes() {
        return this.mareasService.getProtocolizacionPorEstado(MareaEstado.PARA_PROTOCOLIZAR);
    }

    @Get('protocolizacion/en-espera')
    @Auth(ValidRoles.admin, ValidRoles.coordinador)
    async getProtocolizacionEnEspera() {
        return this.mareasService.getProtocolizacionPorEstado(MareaEstado.ESPERANDO_PROTOCOLIZACION);
    }

    @Get('protocolizacion/completas')
    @Auth(ValidRoles.admin, ValidRoles.coordinador)
    async getProtocolizacionCompletas(@Query('year') year?: string) {
        return this.mareasService.getProtocolizacionPorEstado(MareaEstado.PROTOCOLIZADA, year ? Number(year) : undefined);
    }

    @Get('protocolizacion/lotes')
    @Auth(ValidRoles.admin, ValidRoles.coordinador)
    async getProtocolizacionLotes(@Query('year') year?: string) {
        return this.mareasService.getProtocolizacionLotes(year ? Number(year) : undefined);
    }

    @Get('protocolizacion/lotes/:id')
    @Auth(ValidRoles.admin, ValidRoles.coordinador)
    async getProtocolizacionLoteDetalle(@Param('id') id: string) {
        return this.mareasService.getProtocolizacionLoteDetalle(id);
    }

    @Post(':id/archivos/pasajes')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    @UseInterceptors(AnyFilesInterceptor())
    @AuditEvent({
        tipoEvento: 'SUBIR_PASAJE',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Subida de pasaje a la marea y proceso de IA'
    })
    uploadPasajes(
        @Param('id') id: string,
        @UploadedFiles() files: Array<Express.Multer.File>,
        @GetUser() user: User
    ) {
        return this.mareasService.uploadPasajes(id, files, user);
    }

    @Delete(':id/archivos/:archivoId')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    @AuditEvent({
        tipoEvento: 'ELIMINAR_ARCHIVO',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Eliminación de archivo de marea'
    })
    deleteArchivo(
        @Param('id') id: string,
        @Param('archivoId') archivoId: string,
        @GetUser() user: User
    ) {
        return this.mareasService.deleteArchivo(id, archivoId, user);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // OBSERVADORES SECUNDARIOS
    // ─────────────────────────────────────────────────────────────────────────

    @Patch(':id/observadores-secundarios')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    @AuditEvent({
        tipoEvento: 'ACTUALIZAR_OBSERVADORES_SECUNDARIOS',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Actualizacion del borrador de observadores secundarios planificados'
    })
    updateObservadoresSecundarios(
        @Param('id') id: string,
        @Body('observadoresSecundariosPlanificados') observadoresSecundariosPlanificados: any[],
        @GetUser() user: User
    ) {
        return this.mareasService.updateObservadoresSecundarios(id, observadoresSecundariosPlanificados ?? [], user);
    }

    @Patch(':id/etapas/:etapaId/observadores')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    @AuditEvent({
        tipoEvento: 'AGREGAR_OBSERVADOR_ETAPA',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Asignacion de observador secundario a una etapa existente'
    })
    addObservadorEtapa(
        @Param('id') id: string,
        @Param('etapaId') etapaId: string,
        @Body('observadorId') observadorId: string,
        @Body('aplicarASiguientesEtapas') aplicarASiguientesEtapas: boolean,
        @GetUser() user: User
    ) {
        return this.mareasService.addObservadorEtapa(id, etapaId, observadorId, aplicarASiguientesEtapas ?? false, user);
    }

    @Delete(':id/etapas/:etapaId/observadores/:observadorId')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    @AuditEvent({
        tipoEvento: 'QUITAR_OBSERVADOR_ETAPA',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Remocion de observador secundario de una etapa'
    })
    removeObservadorEtapa(
        @Param('id') id: string,
        @Param('etapaId') etapaId: string,
        @Param('observadorId') observadorId: string,
        @GetUser() user: User
    ) {
        return this.mareasService.removeObservadorEtapa(id, etapaId, observadorId, user);
    }

    @Patch(':id/etapas/:etapaId/observadores/:observadorId')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    @AuditEvent({
        tipoEvento: 'ACTUALIZAR_OBSERVADOR_ETAPA',
        categoria: AuditCategoria.MAREAS,
        descripcion: 'Actualizacion o reemplazo de observador secundario de una etapa'
    })
    updateObservadorEtapa(
        @Param('id') id: string,
        @Param('etapaId') etapaId: string,
        @Param('observadorId') observadorId: string,
        @Body('nuevoObservadorId') nuevoObservadorId: string,
        @GetUser() user: User
    ) {
        return this.mareasService.updateObservadorEtapa(id, etapaId, observadorId, nuevoObservadorId, user);
    }
}


