import { Controller, Get, Param, Post, Query, Body, Patch } from '@nestjs/common';
import { MareasService } from './mareas.service';
import { Auth, GetUser } from '../auth/decorators';
import { User } from '@prisma/client';
import { CreateMareaDto } from './dto/create-marea.dto';
import { UpdateMareaDto } from './dto/update-marea.dto';

@Controller('mareas')
@Auth()
export class MareasController {
    constructor(private readonly mareasService: MareasService) { }

    @Get('operativo')
    getDashboardOperativo(@Query('year') year?: string) {
        return this.mareasService.getDashboardOperativo(year ? Number(year) : undefined);
    }

    @Get('kpis')
    getDashboardKpis(@Query('year') year?: string) {
        return this.mareasService.getDashboardKpis(year ? Number(year) : undefined);
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

    @Get('search')
    search(@Query('q') q: string) {
        return this.mareasService.search(q);
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
    executeAction(
        @Param('id') id: string,
        @Param('actionKey') actionKey: string,
        @GetUser() user: User,
        @Body() payload: any
    ) {
        return this.mareasService.executeAction(id, actionKey, user, payload);
    }

    @Post()
    createMarea(
        @Body() createMareaDto: CreateMareaDto,
        @GetUser() user: User
    ) {
        return this.mareasService.create(createMareaDto, user);
    }
}
