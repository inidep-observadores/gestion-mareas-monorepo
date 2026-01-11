"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateObservadorDto = void 0;
const mapped_types_1 = require("@nestjs/mapped-types");
const create_observador_dto_1 = require("./create-observador.dto");
class UpdateObservadorDto extends (0, mapped_types_1.PartialType)(create_observador_dto_1.CreateObservadorDto) {
}
exports.UpdateObservadorDto = UpdateObservadorDto;
//# sourceMappingURL=update-observador.dto.js.map