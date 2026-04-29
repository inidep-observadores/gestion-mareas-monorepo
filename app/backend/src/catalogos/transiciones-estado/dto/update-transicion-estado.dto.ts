import { PartialType } from '@nestjs/mapped-types';
import { CreateTransicionEstadoDto } from './create-transicion-estado.dto';

export class UpdateTransicionEstadoDto extends PartialType(CreateTransicionEstadoDto) { }
