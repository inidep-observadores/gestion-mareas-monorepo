export enum TipoMarea {
  MC = 'MC',
  CI = 'CI',
}

export enum TipoEtapa {
  EC = 'EC',
  EI = 'EI',
  EP = 'EP',
}

export const TIPO_MAREA_DESC: Record<TipoMarea, string> = {
  [TipoMarea.MC]: 'Marea comercial',
  [TipoMarea.CI]: 'Marea institucional'
}

export const TIPO_ETAPA_DESC: Record<TipoEtapa, string> = {
  [TipoEtapa.EC]: 'Etapa comercial',
  [TipoEtapa.EI]: 'Etapa institucional',
  [TipoEtapa.EP]: 'Etapa de prospección'
}
