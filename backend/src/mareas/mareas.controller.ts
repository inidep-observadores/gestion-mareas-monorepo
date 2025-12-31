import { Controller, Get, Param, Post, Query, Body } from '@nestjs/common';
import { MareasService } from './mareas.service';
import { Auth, GetUser } from '../auth/decorators';
import { User } from '@prisma/client';
import { CreateMareaDto } from './dto/create-marea.dto';

@Controller('mareas')
@Auth()
export class MareasController {
    constructor(private readonly mareasService: MareasService) { }

    @Get('operativo')
    getDashboardOperativo() {
        return this.mareasService.getDashboardOperativo();
    }

    @Get(':id/context')
    getMareaContext(@Param('id') id: string) {
        return this.mareasService.getMareaContext(id);
    }

    @Get('search')
    search(@Query('q') q: string) {
        return this.mareasService.search(q);
    }

    @Post(':id/actions/:actionKey')
    executeAction(
        @Param('id') id: string,
        @Param('actionKey') actionKey: string,
        @GetUser() user: User
    ) {
        return this.mareasService.executeAction(id, actionKey, user);
    }

    @Post()
    createMarea(
        @Body() createMareaDto: CreateMareaDto,
        @GetUser() user: User
    ) {
        return this.mareasService.create(createMareaDto, user);
    }
}
