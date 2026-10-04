import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\backend\src\planificacion\planificacion.controller.ts"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

replacement = """  @Put('simulador/escenarios/:id')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async updateEscenario(
    @Param('id') id: string, 
    @Body() dto: UpdateEscenarioDto,
    @GetUser() user: JwtPayload
  ) {
    if (dto.tabId) {
      await this.planificacionService.validateLockForUpdate(id, user.id, dto.tabId);
    }
    return this.planificacionService.updateEscenario(id, dto);
  }"""

content = re.sub(
    r"@Put\('simulador/escenarios/:id'\)\s*@Auth\(ValidRoles.admin, ValidRoles.planificador\)\s*async updateEscenario\(@Param\('id'\) id: string, @Body\(\) dto: UpdateEscenarioDto\) \{\s*return this.planificacionService.updateEscenario\(id, dto\);\s*\}",
    replacement,
    content,
    flags=re.MULTILINE
)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
