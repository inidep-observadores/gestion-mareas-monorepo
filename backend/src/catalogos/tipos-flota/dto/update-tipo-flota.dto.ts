import { PartialType } from '@nestjs/mapped-types';
import { CreateTipoFlotaDto } from './create-tipo-flota.dto';

export class UpdateTipoFlotaDto extends PartialType(CreateTipoFlotaDto) { }
