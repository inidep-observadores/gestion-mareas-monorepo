import { PartialType } from '@nestjs/mapped-types';
import { CreateEstadoMareaDto } from './create-estado-marea.dto';

export class UpdateEstadoMareaDto extends PartialType(CreateEstadoMareaDto) { }
