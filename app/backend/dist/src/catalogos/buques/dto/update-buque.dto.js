"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateBuqueDto = void 0;
const mapped_types_1 = require("@nestjs/mapped-types");
const create_buque_dto_1 = require("./create-buque.dto");
class UpdateBuqueDto extends (0, mapped_types_1.PartialType)(create_buque_dto_1.CreateBuqueDto) {
}
exports.UpdateBuqueDto = UpdateBuqueDto;
//# sourceMappingURL=update-buque.dto.js.map