"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateEspecieDto = void 0;
const mapped_types_1 = require("@nestjs/mapped-types");
const create_especie_dto_1 = require("./create-especie.dto");
class UpdateEspecieDto extends (0, mapped_types_1.PartialType)(create_especie_dto_1.CreateEspecieDto) {
}
exports.UpdateEspecieDto = UpdateEspecieDto;
//# sourceMappingURL=update-especie.dto.js.map