import { PartialType } from '@nestjs/mapped-types';
import { CreateArtePescaDto } from './create-arte-pesca.dto';

export class UpdateArtePescaDto extends PartialType(CreateArtePescaDto) { }
