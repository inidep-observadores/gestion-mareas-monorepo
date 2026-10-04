import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\backend\src\planificacion\dto\escenarios.dto.ts"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

dto_code = """
export class AdquirirLockDto {
  @IsString()
  @IsNotEmpty()
  tabId: string;
}
"""

if "AdquirirLockDto" not in content:
    content += dto_code

if "tabId?: string;" not in content:
    content = content.replace(
        "export class UpdateEscenarioDto {",
        "export class UpdateEscenarioDto {\n  @IsString()\n  @IsOptional()\n  tabId?: string;\n"
    )

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
