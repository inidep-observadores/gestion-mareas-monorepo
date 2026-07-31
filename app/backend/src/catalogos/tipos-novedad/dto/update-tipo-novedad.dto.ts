import { PartialType } from '@nestjs/mapped-types';
import { CreateTipoNovedadDto } from './create-tipo-novedad.dto';

export class UpdateTipoNovedadDto extends PartialType(CreateTipoNovedadDto) {}
