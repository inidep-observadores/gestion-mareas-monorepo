import { PipeTransform, Injectable, ArgumentMetadata, BadRequestException } from '@nestjs/common';

@Injectable()
export class ParseJsonPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    if (!value) return value;
    
    // If it's multipart/form-data, the JSON might be in a field called 'payload'
    if (value.payload && typeof value.payload === 'string') {
      try {
        return JSON.parse(value.payload);
      } catch (e) {
        throw new BadRequestException('El campo payload no es un JSON válido');
      }
    }

    // Otherwise, assume the body itself is the JSON payload
    return value;
  }
}
