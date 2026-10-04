import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\backend\src\planificacion\planificacion.controller.ts"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Add HttpException to imports
content = content.replace("import { Controller, Get, Param, ParseIntPipe, Post, Body, Query, Put, Delete, Res } from '@nestjs/common';",
                          "import { Controller, Get, Param, ParseIntPipe, Post, Body, Query, Put, Delete, Res, HttpException, HttpStatus } from '@nestjs/common';")
content = content.replace("import { Auth } from '../auth/decorators';", "import { Auth, GetUser } from '../auth/decorators';")
content = content.replace("import { ValidRoles } from '../auth/interfaces';", "import { ValidRoles, JwtPayload } from '../auth/interfaces';")
content = content.replace("import { CreateEscenarioDto, UpdateEscenarioDto, CloneEscenarioDto, ExportEscenarioDto } from './dto/escenarios.dto';",
                          "import { CreateEscenarioDto, UpdateEscenarioDto, CloneEscenarioDto, ExportEscenarioDto, AdquirirLockDto } from './dto/escenarios.dto';")


lock_endpoints = """
  @Post('simulador/escenarios/:id/lock')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async adquirirLock(
    @Param('id') id: string,
    @Body() dto: AdquirirLockDto,
    @GetUser() user: JwtPayload,
  ) {
    const result = await this.planificacionService.adquirirLock(id, user.id, user.nombre || user.email, dto.tabId);
    if (!result.success) {
      throw new HttpException(
        { message: `El escenario está siendo modificado por ${result.lockedBy}.`, lockedBy: result.lockedBy },
        HttpStatus.LOCKED,
      );
    }
    return { success: true };
  }

  @Delete('simulador/escenarios/:id/lock')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async liberarLock(
    @Param('id') id: string,
    @Query('tabId') tabId: string,
    @GetUser() user: JwtPayload,
  ) {
    if (!tabId) return { success: true }; // ignore if no tabId
    await this.planificacionService.liberarLock(id, user.id, tabId);
    return { success: true };
  }
"""

if "simulador/escenarios/:id/lock" not in content:
    # insert before @Delete('simulador/escenarios/:id')
    content = content.replace("  @Delete('simulador/escenarios/:id')", lock_endpoints + "\n  @Delete('simulador/escenarios/:id')")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
