export class PlanillaMensualResponseDto {
  year: number;
  month: number;
  diasMes: number;
  feriados: Record<number, string>;
  matriz: ObservadorRowDto[];
}

export class ObservadorRowDto {
  observador: {
    id: string;
    nombre: string;
    apellido: string;
    codigoInterno: number;
    tipoObservador: string;
    tipoContrato: string;
  };
  dias: Record<number, DiaEstadoDto>;
  totales: {
    navegando: number;
    puerto: number;
    novedades: number;
    libres: number;
    feriadosFinSemana: number;
    conflictos: number;
    esperandoZarpada: number;
  };
}

export class DiaEstadoDto {
  estado: 'NAVEGANDO' | 'PUERTO' | 'NOVEDAD' | 'FERIADO' | 'FIN_SEMANA' | 'LIBRE' | 'CONFLICTO' | 'VIAJE' | 'ESPERANDO_ZARPADA';
  estadoSecundario?: 'VIAJE' | 'PUERTO' | 'ESPERANDO_ZARPADA' | 'NOVEDAD';
  detalle?: string;
  conflictoDetalle?: string;
  referenciaId?: string;
  codigoCorto?: string;
  computaFranco?: boolean;
}
