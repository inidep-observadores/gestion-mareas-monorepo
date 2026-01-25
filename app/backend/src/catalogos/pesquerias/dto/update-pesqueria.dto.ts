import { PartialType } from '@nestjs/mapped-types';
import { CreatePesqueriaDto } from './create-pesqueria.dto';

export class UpdatePesqueriaDto extends PartialType(CreatePesqueriaDto) { }
