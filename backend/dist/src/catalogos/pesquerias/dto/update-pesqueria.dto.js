"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdatePesqueriaDto = void 0;
const mapped_types_1 = require("@nestjs/mapped-types");
const create_pesqueria_dto_1 = require("./create-pesqueria.dto");
class UpdatePesqueriaDto extends (0, mapped_types_1.PartialType)(create_pesqueria_dto_1.CreatePesqueriaDto) {
}
exports.UpdatePesqueriaDto = UpdatePesqueriaDto;
//# sourceMappingURL=update-pesqueria.dto.js.map