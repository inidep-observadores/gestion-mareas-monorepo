# Estructura de datos (pseudocodigo para Prisma)

## 1. Modulo de autenticacion y usuarios

Table users {
  id TEXT (PK) // @id @default(uuid())
  email TEXT NOT NULL // @unique
  password TEXT NOT NULL // Contrasena hasheada
  fullName TEXT NOT NULL
  isActive BOOLEAN NOT NULL // @default(true)
  roles TEXT[] NOT NULL // Array de roles, ej: ['user', 'admin']; @default(['user'])
  themePreference TEXT NOT NULL // @default('system')
  avatarUrl TEXT?

  UNIQUE(email)
}

Table password_reset_tokens {
  id TEXT (PK) // UUID, generado con uuid()
  token TEXT NOT NULL
  expires_at TIMESTAMP NOT NULL // expira el enlace de reseteo
  used BOOLEAN NOT NULL // true = ya fue utilizado
  requested_ip TEXT? // IP desde donde se solicito el reseteo
  created_at TIMESTAMP NOT NULL // fecha/hora de creacion del token
  user_id TEXT NOT NULL // FK -> users.id (ON DELETE CASCADE)
}

## 2. Catalogos base (maestras)

Table tipos_flota {
  id TEXT (PK) // UUID interno
  codigo TEXT NOT NULL // Codigo corto
  nombre TEXT NOT NULL
  descripcion TEXT?
  orden INTEGER?
  activo BOOLEAN NOT NULL

  UNIQUE(codigo)
}

Table buques {
  id TEXT (PK)

  // Identificacion
  nombre_buque TEXT NOT NULL
  matricula TEXT NOT NULL // @unique
  codigo_interno INTEGER? // Codigo interno del INIDEP

  // Clasificacion estructural
  id_tipo_flota TEXT? // FK -> tipos_flota.id
  id_arte_habitual TEXT? // FK -> artes_pesca.id
  id_pesqueria_habitual TEXT? // FK -> pesquerias.id

  // Parametros operativos del buque
  dias_marea_estimada INTEGER?
  eslora_m NUMERIC(6,2)?
  potencia_hp INTEGER?

  // Datos administrativos
  id_puerto_base TEXT? // FK -> puertos.id
  empresa_nombre TEXT?
  empresa_localidad TEXT?
  empresa_telefono TEXT?
  empresa_fax TEXT?
  empresa_correo_principal TEXT?
  empresa_correo_secundario TEXT?
  armador_nombre TEXT?
  armador_telefono TEXT?
  agencia_maritima_nombre TEXT?

  // Gestion del catalogo
  activo BOOLEAN NOT NULL
  fecha_alta DATE?
  fecha_baja DATE?
  observaciones TEXT?

  UNIQUE(matricula)
}

Table artes_pesca {
  id TEXT (PK) // UUID interno
  codigo_numerico INTEGER NOT NULL // Codigo oficial o historico
  descripcion TEXT NOT NULL // Ej.: Arrastre de fondo, Tangones, Poteras, etc.
  activo BOOLEAN NOT NULL // Para habilitar/deshabilitar valores

  UNIQUE(codigo_numerico)
}

Table pesquerias {
  id TEXT (PK) // UUID interno
  codigo TEXT NOT NULL // Codigo corto: MERLUZA, LANGOSTINO, CENTOLLA...
  nombre TEXT NOT NULL // Nombre oficial de la pesqueria
  descripcion TEXT?
  grupo TEXT? // Peces, Crustaceos, Moluscos, etc.
  orden INTEGER? // Para ordenar en listados
  activo BOOLEAN NOT NULL // true = visible / usable

  UNIQUE(codigo)
}

Table puertos {
  id TEXT (PK) // UUID interno
  nombre TEXT NOT NULL // Ej.: Mar del Plata, Ushuaia, Puerto Madryn
  provincia TEXT?
  pais TEXT?
  codigo_interno TEXT? // Codigo interno INIDEP
  codigo_externo TEXT? // Codigo de otros sistemas (Prefectura, etc.)
  es_local BOOLEAN NOT NULL // Identifica si se trata del puerto local (Mar del Plata)
  activo BOOLEAN NOT NULL
  orden INTEGER?
  observaciones TEXT?
}

Table especies {
  id TEXT (PK) // UUID interno
  codigo TEXT NOT NULL // Codigo alfanumerico de 10 digitos (se guarda como texto para preservar ceros)
  nombre_cientifico TEXT NOT NULL // Ej.: Merluccius hubbsi
  nombre_vulgar TEXT NOT NULL // Ej.: Merluza comun
  activo BOOLEAN NOT NULL // Para especies en uso / historicas
  observaciones TEXT?

  UNIQUE(codigo)
}

Table observadores {
  id TEXT (PK) // UUID interno
  codigo_interno INTEGER NOT NULL // Codigo interno del INIDEP
  nombre TEXT NOT NULL
  apellido TEXT NOT NULL
  foto_url TEXT? // Ruta/URL de foto del observador

  tipo_observador TEXT NOT NULL // 'OBSERVADOR' | 'TECNICO'
  tipo_contrato TEXT NOT NULL // 'LEY MARCO' | 'MONOTRIBUTISTA' | 'PLANTA PERMANENTE'

  activo BOOLEAN NOT NULL // true = no esta dado de baja
  disponible BOOLEAN NOT NULL // true = puede ser llamado a embarcar (no licencia/impedimento)

  fecha_proxima_disponibilidad TIMESTAMP? // Declarada por el observador (administrativa)

  observaciones TEXT?
}

Table observador_pesquerias {
  id TEXT (PK) // UUID interno
  id_observador TEXT NOT NULL // FK -> observadores.id
  id_pesqueria TEXT NOT NULL // FK -> pesquerias.id

  modo TEXT NOT NULL // 'WHITELIST' | 'BLACKLIST'
  activo BOOLEAN NOT NULL // permite deshabilitar sin borrar
  motivo TEXT? // razon o comentario
  fecha_desde TIMESTAMP? // opcional (si queres vigencias)
  fecha_hasta TIMESTAMP? // opcional

  UNIQUE(id_observador, id_pesqueria, modo)
  INDEX(id_observador)
  INDEX(id_pesqueria)
}

## 3. Gestion de mareas (flujo y auditoria)

Table estados_marea {
  id TEXT (PK) // UUID interno
  codigo TEXT NOT NULL // Ej.: 'DESIGNADA', 'EN_CORRECCION'
  nombre TEXT NOT NULL // Etiqueta visible para usuarios
  descripcion TEXT?
  categoria TEXT NOT NULL // 'PENDIENTE' | 'EN_CURSO' | 'COMPLETADO' | 'CANCELADO'
  orden INTEGER NOT NULL
  es_inicial BOOLEAN NOT NULL // true solo para DESIGNADA
  es_final BOOLEAN NOT NULL // true para PROTOCOLIZADA / CANCELADA
  permite_carga_archivos BOOLEAN NOT NULL
  permite_correccion BOOLEAN NOT NULL
  permite_informe BOOLEAN NOT NULL
  activo BOOLEAN NOT NULL

  UNIQUE(codigo)
}

Table mareas {
  id TEXT (PK) // UUID interno

  // Identificacion basica
  anio_marea INTEGER NOT NULL
  nro_marea INTEGER NOT NULL // UNIQUE (anio_marea, nro_marea, id_buque)

  // Relacion con buque, estado y pesqueria
  id_buque TEXT NOT NULL // FK -> buques.id
  id_arte_principal TEXT? // FK -> artes_pesca.id
  id_estado_actual TEXT NOT NULL // FK -> estados_marea.id (Estado actual)

  // Fechas clave (administrativas / marco del observador)
  fecha_zarpada_estimada TIMESTAMP? // Tentativa (cargada al designar)
  fecha_inicio_observador TIMESTAMP? // Inicio del trabajo del observador (incluye viaje si no es puerto local)
  fecha_fin_observador TIMESTAMP? // Fin del trabajo del observador (incluye regreso si no es puerto local)

  // Zona Austral (dato derivado/materializado)
  dias_zona_austral INTEGER? // Dias navegados con latitud < -50 grados (solo entre etapas; sin dias de puerto)
  tipo_calculo_zona_austral TEXT NOT NULL // 'AUTOMATICO' | 'MANUAL'

  // Descripcion
  titulo TEXT?
  descripcion TEXT?

  // Informacion administrativa
  nro_protocolizacion INTEGER?
  anio_protocolizacion INTEGER?
  fecha_protocolizacion TIMESTAMP?

  // Gestion y auditoria
  fecha_creacion TIMESTAMP NOT NULL
  fecha_ultima_actualizacion TIMESTAMP NOT NULL
  activo BOOLEAN NOT NULL
  observaciones TEXT?

  UNIQUE(anio_marea, nro_marea, id_buque)
}

Table mareas_etapas {
  id TEXT (PK)
  id_marea TEXT NOT NULL // FK -> mareas.id
  nro_etapa INTEGER NOT NULL // 1, 2, 3...
  id_pesqueria TEXT? // FK -> pesquerias.id (pesqueria efectiva)
  id_puerto_zarpada TEXT? // FK -> puertos.id
  id_puerto_arribo TEXT? // FK -> puertos.id
  fecha_zarpada TIMESTAMP?
  fecha_arribo TIMESTAMP?
  tipo_etapa TEXT NOT NULL // 'COMERCIAL' | 'INSTITUCIONAL'
  observaciones TEXT?

  UNIQUE(id_marea, nro_etapa)
  INDEX(id_marea)
}

Table mareas_movimientos {
  id TEXT (PK)
  id_marea TEXT NOT NULL // FK -> mareas.id
  fecha_hora TIMESTAMP NOT NULL
  id_usuario TEXT? // Usuario que registro el evento (FK -> users.id)
  tipo_evento TEXT NOT NULL // 'CAMBIO_ESTADO' | 'RECEPCION_DATOS' | 'ENTREGA_OTOLITOS', etc.
  id_estado_desde TEXT? // FK -> estados_marea.id
  id_estado_hasta TEXT? // FK -> estados_marea.id
  cantidad_muestras_otolitos INTEGER? // Solo si tipo_evento = 'ENTREGA_OTOLITOS'
  detalle TEXT? // Comentario libre

  INDEX(id_marea)
}

Table mareas_archivos {
  id TEXT (PK)
  id_marea TEXT NOT NULL // FK -> mareas.id
  id_movimiento_origen TEXT? // FK -> mareas_movimientos.id
  tipo_archivo TEXT NOT NULL // 'DATOS_OBSERVADOR' | 'INFORME_MAREA', etc.
  formato TEXT? // 'DBF' | 'XLS' | 'PDF', etc.
  version TEXT? // 'ORIGINAL' | 'CORREGIDO' | 'FINAL'
  ruta_archivo TEXT NOT NULL // Path interno o URL al storage
  fecha_subida TIMESTAMP NOT NULL
  id_usuario_subio TEXT? // Quien lo subio (FK -> users.id)
  descripcion TEXT?

  INDEX(id_marea)
}

## 4. Tablas de datos de muestreo (OBS)

Table lances {
  id TEXT (PK) // UUID interno
  etapa_id TEXT NOT NULL // FK -> mareas_etapas.id
  numero_lance INTEGER NOT NULL // UNIQUE (etapa_id, numero_lance)
  fecha DATE NOT NULL
  cod_arte_pesca INTEGER NOT NULL // FK a artes_pesca.codigo_numerico
  tipo_arte_pesca INTEGER?
  hora_inicio REAL?
  lat_inicio REAL?
  long_inicio REAL?
  prof_inicio INTEGER?
  hora_final REAL?
  lat_final REAL?
  long_final REAL?
  prof_final INTEGER?
  rumbo INTEGER?
  distancia_red REAL?
  velocidad_arrastre REAL?
  tiempo_red INTEGER?
  estacion_gral INTEGER?
  calador TEXT?
  fondo_min INTEGER?
  fondo_max INTEGER?
  tamiz TEXT?
  area_barrida REAL?
  captura_total_kg REAL?
  descarte_total_kg REAL?
  observaciones_lance TEXT?
  mus INTEGER?
  fuente_dato INTEGER?

  UNIQUE(etapa_id, numero_lance)
  INDEX(etapa_id)
}

Table capturas {
  id TEXT (PK) // UUID interno
  lance_id TEXT NOT NULL // FK -> lances.id
  especie_id TEXT NOT NULL // FK -> especies.id
  kg_captura REAL NOT NULL
  kg_descarte REAL NOT NULL
  observaciones_captura TEXT?
  indice_original INTEGER NOT NULL // UNIQUE (lance_id, especie_id)

  UNIQUE(lance_id, especie_id)
  INDEX(lance_id)
}

Table muestras {
  id TEXT (PK) // UUID interno
  lance_id TEXT NOT NULL // FK -> lances.id
  especie_id TEXT NOT NULL // FK -> especies.id
  tipo_muestra TEXT NOT NULL // 'CAPTURA' | 'DESCARTE'
  peso_muestra_kg REAL?
  fact_ponderacion REAL?
  unidad_largo TEXT NOT NULL // 'mm' | 'cm'
  primera_talla INTEGER?
  ultima_talla INTEGER?
  intervalo_mm INTEGER?
  total_mediciones INTEGER?
  observaciones TEXT?

  UNIQUE(lance_id, especie_id, tipo_muestra)
  INDEX(lance_id)
}

Table muestras_detalle_talla {
  id TEXT (PK) // UUID interno
  muestra_id TEXT NOT NULL // FK -> muestras.id
  talla_mm INTEGER NOT NULL // UNIQUE (muestra_id, talla_mm)
  cantidad_machos INTEGER NOT NULL
  cantidad_hembras INTEGER NOT NULL
  cantidad_indet INTEGER NOT NULL
  cantidad_total INTEGER NOT NULL
  indice_original INTEGER NOT NULL

  UNIQUE(muestra_id, talla_mm)
  INDEX(muestra_id)
}

Table submuestras {
  id TEXT (PK) // UUID interno
  muestra_id TEXT NOT NULL // FK -> muestras.id
  numero_ejemplar INTEGER NOT NULL // UNIQUE (muestra_id, numero_ejemplar)
  largo_total INTEGER?
  largo_estandar INTEGER?
  peso_total_g REAL?
  peso_gonadas_g REAL?
  sexo INTEGER?
  estadio_madurez INTEGER?
  replecion INTEGER?
  contenido_estomacal TEXT?
  observaciones_ejemplar TEXT?

  UNIQUE(muestra_id, numero_ejemplar)
  INDEX(muestra_id)
}

Table producciones {
  id TEXT (PK) // UUID interno
  marea_id TEXT NOT NULL // FK -> mareas.id
  especie_id TEXT NOT NULL // FK -> especies.id
  fecha DATE NOT NULL // UNIQUE (marea_id, especie_id, fecha, producto, categoria)
  producto TEXT?
  categoria TEXT?
  factor_conversion REAL?
  kg_produccion REAL NOT NULL
  operarios INTEGER?

  UNIQUE(marea_id, especie_id, fecha, producto, categoria)
  INDEX(marea_id)
}

## 5. Tablas de procesamiento geografico (GIS)

Table buque_trayectorias {
  id TEXT (PK) // UUID
  buque_id TEXT NOT NULL // FK -> buques.id

  fecha_desde TIMESTAMPTZ? // Cobertura minima registrada para el buque
  fecha_hasta TIMESTAMPTZ? // Cobertura maxima registrada para el buque
  cantidad_puntos INT NOT NULL

  origen TEXT? // 'SEGUIMIENTO_SATELITAL'
  metadata JSONB?

  UNIQUE(buque_id)
  INDEX(buque_id)
}

Table buque_trayectoria_puntos {
  id TEXT (PK) // UUID
  trayectoria_id TEXT NOT NULL // FK -> buque_trayectorias.id
  buque_id TEXT NOT NULL // FK -> buques.id (optimiza queries y upsert)

  timestamp TIMESTAMPTZ NOT NULL
  lat DOUBLE NOT NULL
  lon DOUBLE NOT NULL
  velocidad DOUBLE?
  rumbo INT?
  geom GEOGRAPHY(Point, 4326)? // PostGIS; en Prisma usar Unsupported("geography")

  // Upsert incremental por buque, evita duplicar puntos al reimportar
  UNIQUE(buque_id, timestamp)
  INDEX(trayectoria_id, timestamp)
  INDEX(buque_id, timestamp)
  INDEX(geom)
}

// Para obtener la ruta de una marea, filtrar por buque_id y el rango
// fecha_zarpada_estimada/fecha_inicio_observador -> fecha_fin_observador.
