"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdatePuertoDto = void 0;
const mapped_types_1 = require("@nestjs/mapped-types");
const create_puerto_dto_1 = require("./create-puerto.dto");
class UpdatePuertoDto extends (0, mapped_types_1.PartialType)(create_puerto_dto_1.CreatePuertoDto) {
}
exports.UpdatePuertoDto = UpdatePuertoDto;
//# sourceMappingURL=update-puerto.dto.js.map