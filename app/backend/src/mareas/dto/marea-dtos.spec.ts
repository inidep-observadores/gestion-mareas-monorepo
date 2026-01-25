import 'reflect-metadata';
import { validate } from 'class-validator';
import { CreateMareaDto } from './create-marea.dto';
import { MareaEtapaDto } from './marea-etapa.dto';
import { TipoEtapa, TipoMarea } from '../mareas.constants';

describe('Mareas DTOs', () => {
  describe('CreateMareaDto', () => {
    it('should fail if required fields are missing', async () => {
      const dto = new CreateMareaDto();
      const errors = await validate(dto);
      
      const errorProperties = errors.map(e => e.property);
      expect(errorProperties).toContain('buqueId');
      expect(errorProperties).toContain('anioMarea');
      expect(errorProperties).toContain('nroMarea');
      expect(errorProperties).toContain('pesqueriaId');
      expect(errorProperties).toContain('observadorId');
      expect(errorProperties).toContain('fechaZarpadaEstimada'); // Validating user request
    });

    it('should fail if anioMarea is out of range', async () => {
      const dto = new CreateMareaDto();
      dto.buqueId = '550e8400-e29b-41d4-a716-446655440000';
      dto.anioMarea = 1999;
      dto.nroMarea = 1;
      dto.pesqueriaId = '550e8400-e29b-41d4-a716-446655440001';
      dto.observadorId = '550e8400-e29b-41d4-a716-446655440002';
      dto.fechaZarpadaEstimada = '2025-01-01';

      const errors = await validate(dto);
      expect(errors.find(e => e.property === 'anioMarea')).toBeDefined();
    });

    it('should validate correctly with all required fields', async () => {
      const dto = new CreateMareaDto();
      dto.buqueId = '550e8400-e29b-41d4-a716-446655440000';
      dto.anioMarea = 2025;
      dto.nroMarea = 123;
      dto.pesqueriaId = '550e8400-e29b-41d4-a716-446655440001';
      dto.observadorId = '550e8400-e29b-41d4-a716-446655440002';
      dto.fechaZarpadaEstimada = '2025-01-22T00:00:00Z';
      dto.tipoMarea = TipoMarea.MC;

      const errors = await validate(dto);
      expect(errors.length).toBe(0);
    });
  });

  describe('MareaEtapaDto', () => {
    it('should fail if nroEtapa is missing', async () => {
      const dto = new MareaEtapaDto();
      dto.tipoEtapa = TipoEtapa.MC;
      const errors = await validate(dto);
      expect(errors.find(e => e.property === 'nroEtapa')).toBeDefined();
    });

    it('should fail if tipoEtapa is missing', async () => {
        const dto = new MareaEtapaDto();
        dto.nroEtapa = 1;
        const errors = await validate(dto);
        expect(errors.find(e => e.property === 'tipoEtapa')).toBeDefined();
      });

    it('should validate correctly with valid data', async () => {
      const dto = new MareaEtapaDto();
      dto.nroEtapa = 1;
      dto.tipoEtapa = TipoEtapa.MC;
      dto.fechaZarpada = '2025-01-22T10:00:00Z';
      
      const errors = await validate(dto);
      expect(errors.length).toBe(0);
    });
  });
});
