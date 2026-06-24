export interface PlanillaMensualResponse {
  year: number;
  month: number;
  diasMes: number;
  feriados: Record<number, string>;
  matriz: ObservadorRow[];
}

export interface ObservadorRow {
  observador: {
    id: string;
    nombre: string;
    apellido: string;
    codigoInterno: number;
    tipoObservador: string;
    tipoContrato: string;
  };
  dias: Record<number, DiaEstado>;
  totales: {
    navegando: number;
    puerto: number;
    novedades: number;
    libres: number;
    feriadosFinSemana: number;
    conflictos: number;
  };
}

export interface DiaEstado {
  estado: 'NAVEGANDO' | 'PUERTO' | 'NOVEDAD' | 'FERIADO' | 'FIN_SEMANA' | 'LIBRE' | 'CONFLICTO' | 'VIAJE';
  detalle?: string;
  conflictoDetalle?: string;
  referenciaId?: string;
  codigoCorto?: string;
}
