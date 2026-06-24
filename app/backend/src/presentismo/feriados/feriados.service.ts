import { Injectable, Logger, HttpException, HttpStatus } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateFeriadoDto } from './dto/create-feriado.dto';

@Injectable()
export class FeriadosService {
  private readonly logger = new Logger(FeriadosService.name);

  constructor(private readonly prisma: PrismaService) {}

  async findAll() {
    return this.prisma.feriado.findMany({
      orderBy: { fecha: 'asc' },
    });
  }

  async findByYear(year: number) {
    const startOfYear = new Date(`${year}-01-01T00:00:00Z`);
    const endOfYear = new Date(`${year}-12-31T23:59:59Z`);

    return this.prisma.feriado.findMany({
      where: {
        fecha: {
          gte: startOfYear,
          lte: endOfYear,
        },
      },
      orderBy: { fecha: 'asc' },
    });
  }

  async create(createFeriadoDto: CreateFeriadoDto) {
    return this.prisma.feriado.create({
      data: {
        fecha: new Date(createFeriadoDto.fecha),
        nombre: createFeriadoDto.nombre,
        tipo: createFeriadoDto.tipo,
        origen: createFeriadoDto.origen || 'MANUAL',
      },
    });
  }

  async update(fecha: string, updateFeriadoDto: Partial<CreateFeriadoDto>) {
    return this.prisma.feriado.update({
      where: { fecha: new Date(fecha) },
      data: {
        nombre: updateFeriadoDto.nombre,
        tipo: updateFeriadoDto.tipo,
        origen: updateFeriadoDto.origen,
      },
    });
  }

  async delete(fecha: string) {
    return this.prisma.feriado.delete({
      where: { fecha: new Date(fecha) },
    });
  }

  async sincronizarConApi(year: number) {
    try {
      this.logger.log(`Sincronizando feriados del año ${year} desde API externa...`);
      const response = await fetch(`https://api.argentinadatos.com/v1/feriados/${year}`);

      if (!response.ok) {
        throw new HttpException(`Error al consultar API: ${response.statusText}`, HttpStatus.BAD_GATEWAY);
      }

      const feriadosApi = await response.json();
      let sincronizados = 0;

      for (const f of feriadosApi) {
        await this.prisma.feriado.upsert({
          where: { fecha: new Date(f.fecha) },
          update: {
            nombre: f.nombre,
            tipo: f.tipo,
            origen: 'API',
          },
          create: {
            fecha: new Date(f.fecha),
            nombre: f.nombre,
            tipo: f.tipo,
            origen: 'API',
          },
        });
        sincronizados++;
      }

      this.logger.log(`Sincronización completada. ${sincronizados} feriados procesados para ${year}.`);
      return { message: 'Sincronización exitosa', count: sincronizados, year };
    } catch (error) {
      this.logger.error(`Error sincronizando feriados: ${error.message}`, error.stack);
      throw error;
    }
  }
}
