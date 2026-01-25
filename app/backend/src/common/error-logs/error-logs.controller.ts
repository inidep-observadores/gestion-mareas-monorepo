import { Controller, Get, Param } from '@nestjs/common';
import { ErrorLogsService } from './error-logs.service';
import { Auth } from 'src/auth/decorators/auth.decorator';
import { ValidRoles } from 'src/auth/interfaces';

@Controller('error-logs')
@Auth(ValidRoles.admin)
export class ErrorLogsController {
    constructor(private readonly errorLogsService: ErrorLogsService) { }

    @Get()
    findAll() {
        return this.errorLogsService.findAll();
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.errorLogsService.findOne(id);
    }
}
