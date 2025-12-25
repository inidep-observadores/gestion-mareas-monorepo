// ==========================================  
// 1. MÓDULO DE AUTENTICACIÓN Y USUARIOS  
// ==========================================

Table users {  
id &nbsp;            TEXT (PK)             // @id @default(uuid())  
email           TEXT NOT NULL         // @unique  
password        TEXT NOT NULL         // Contraseña hasheada  
full_name       TEXT NOT NULL  
is_active       BOOLEAN NOT NULL      // default true en Prisma  
roles           TEXT\[\] NOT NULL       // Array de roles, ej: \[&#39;user&#39;, &#39;admin&#39;\]  
}

Table password_reset_tokens {  
id              TEXT (PK)             // UUID, generado con uuid()  
token           TEXT NOT NULL  
expires_at      TIMESTAMP NOT NULL    // expira el enlace de reseteo  
used            BOOLEAN NOT NULL      // true = ya fue utilizado  
requested_ip    TEXT?                 // IP desde donde se solicitó el reseteo  
created_at      TIMESTAMP NOT NULL    // fecha/hora de creación del token  
user_id         TEXT NOT NULL         // FK → users.id (ON DELETE CASCADE)  
}

// ==========================================  
// 2. CATÁLOGOS BASE (MAESTRAS)  
// ==========================================

Table buques {  
id              TEXT (PK)

// Identificación  
nombre_buque    TEXT NOT NULL  
matricula       TEXT NOT NULL (UNIQUE)  
codigo_interno  INTEGER               // Código interno del INIDEP

// Clasificación estructural  
id_tipo_flota   TEXT?                 // FK → tipos_flota.id  
id_arte_habitual      TEXT?           // FK → artes_pesca.id  
id_pesqueria_habitual TEXT?           // FK → pesquerias.id

// Parámetros operativos del buque  
dias_marea_estimada INTEGER?  
eslora_m        NUMERIC(6,2)?         // Eslora en metros  
potencia_hp     INTEGER?              // Potencia del motor en HP

// Datos administrativos  
id_puerto_base  TEXT?                 // FK → puertos.id  
empresa_nombre  TEXT?  
empresa_localidad TEXT?  
empresa_telefono TEXT?  
empresa_fax     TEXT?  
empresa_correo_principal TEXT?  
empresa_correo_secundario TEXT?  
armador_nombre  TEXT?  
armador_telefono TEXT?  
agencia_maritima_nombre TEXT?

// Gestión del catálogo  
activo          BOOLEAN NOT NULL  
fecha_alta      DATE?  
fecha_baja      DATE?  
observaciones   TEXT?  
}

Table artes_pesca {  
id              TEXT (PK)             // UUID interno  
codigo_numerico INTEGER NOT NULL      // Código oficial o histórico  
descripcion     TEXT NOT NULL         // Ej.: Arrastre de fondo, Tangones, Poteras, etc.  
activo          BOOLEAN NOT NULL      // Para habilitar/deshabilitar valores  
}

Table pesquerias {  
id              TEXT (PK)             // UUID interno  
codigo          TEXT NOT NULL         // Código corto: MERLUZA, LANGOSTINO, CENTOLLA...  
nombre          TEXT NOT NULL         // Nombre oficial de la pesquería  
descripcion     TEXT?  
grupo           TEXT?                 // Peces, Crustáceos, Moluscos, etc.  
orden           INTEGER?              // Para ordenar en listados  
activo          BOOLEAN NOT NULL      // true = visible / usable  
}

Table puertos {  
id              TEXT (PK)             // UUID interno  
nombre          TEXT NOT NULL         // Ej.: Mar del Plata, Ushuaia, Puerto Madryn  
provincia       TEXT?  
pais            TEXT?  
codigo_interno  TEXT?                 // Código interno INIDEP  
codigo_externo  TEXT?                 // Código de otros sistemas (Prefectura, etc.)  
activo          BOOLEAN NOT NULL  
orden           INTEGER?  
observaciones   TEXT?  
}

Table especies {  
 id                TEXT (PK)          // UUID interno

codigo             TEXT NOT NULL     // Código alfanumérico de 10 dígitos  
                                      // (se guarda como texto para preservar ceros a la izquierda)

nombre_cientifico  TEXT NOT NULL     // Ej.: Merluccius hubbsi  
 nombre_vulgar      TEXT NOT NULL     // Ej.: Merluza común

activo             BOOLEAN NOT NULL  // Para especies en uso / históricas  
 observaciones      TEXT?  
}

Table observadores {  
id              TEXT (PK)             // UUID interno  
codigo_interno  INTEGER NOT NULL      // Código interno del INIDEP  
nombre          TEXT NOT NULL  
apellido        TEXT NOT NULL  
foto_url        TEXT?                 // Ruta/URL de foto del observador  
tipo_observador TEXT NOT NULL         // &#39;OBSERVADOR&#39; | &#39;TECNICO&#39;  
activo          BOOLEAN NOT NULL      // true = puede embarcar  
observaciones   TEXT?  
}

Table observadores_bitacora {  
id              TEXT (PK)             // UUID interno  
id_observador   TEXT NOT NULL         // FK → observadores.id  
id_marea        TEXT?                 // FK → mareas.id (contexto opcional)  
fecha           TIMESTAMP NOT NULL    // Cuándo se registró la observación

// Clasificación  
tipo            TEXT NOT NULL         // &#39;DESEMPEÑO&#39; | &#39;SALUD&#39; | &#39;ADMINISTRATIVO&#39; | &#39;OTRO&#39;  
severidad       TEXT?                 // &#39;BAJA&#39; | &#39;MEDIA&#39; | &#39;ALTA&#39;

// Contenido  
titulo          TEXT?  
descripcion     TEXT NOT NULL  
id_usuario_autor TEXT NOT NULL        // FK lógico → users.id (Autor del registro)  
}

// ==========================================  
// 3. GESTIÓN DE MAREAS (FLUJO Y AUDITORÍA)  
// ==========================================

Table estados_marea {  
id              TEXT (PK)             // UUID interno  
codigo          TEXT NOT NULL         // Ej.: &#39;DESIGNADA&#39;, &#39;EN_CORRECCION&#39;  
nombre          TEXT NOT NULL         // Etiqueta visible para usuarios  
descripcion     TEXT?  
categoria       TEXT NOT NULL         // &#39;PENDIENTE&#39; | &#39;EN_CURSO&#39; | &#39;COMPLETADO&#39; | &#39;CANCELADO&#39;  
orden           INTEGER NOT NULL  
es_inicial      BOOLEAN NOT NULL      // true solo para DESIGNADA  
es_final        BOOLEAN NOT NULL      // true para PROTOCOLIZADA / CANCELADA  
permite_carga_archivos BOOLEAN NOT NULL  
permite_correccion BOOLEAN NOT NULL  
permite_informe BOOLEAN NOT NULL  
activo          BOOLEAN NOT NULL  
}

Table mareas {  
id              TEXT (PK)             // UUID interno

// Identificación básica  
anio_marea      INTEGER NOT NULL  
nro_marea       INTEGER NOT NULL      // UNIQUE (anio_marea, nro_marea, id_buque)  
// Relación con buque, estado y pesquería  
id_buque        TEXT NOT NULL         // FK → buques.id  
id_pesqueria    TEXT?                 // FK → pesquerias.id (pesquería efectiva)  
id_arte_principal TEXT?               // FK → artes_pesca.id  
id_estado_actual TEXT NOT NULL        // FK → estados_marea.id (Estado actual)

// Fechas y descripción  
fecha_zarpada_estimada TIMESTAMP?  
titulo          TEXT?  
descripcion     TEXT?

// Información administrativa  
nro_protocolización INTEGER? //Dato administrativo  
anio_protocolización INTEGER? //Dato administrativo  
fecha_protocolización TIMESTAMP? //Fecha en que se protocolizó

// Gestión y auditoría  
fecha_creacion TIMESTAMP NOT NULL  
fecha_ultima_actualizacion TIMESTAMP NOT NULL  
activo BOOLEAN NOT NULL  
observaciones   TEXT?  
}

Table mareas_etapas {  
id              TEXT (PK)  
id_marea        TEXT NOT NULL         // FK → mareas.id  
nro_etapa       INTEGER NOT NULL      // 1, 2, 3...  
id_puerto_zarpada TEXT?               // FK → puertos.id  
id_puerto_arribo TEXT?                // FK → puertos.id  
fecha_zarpada   TIMESTAMP?            // Fecha/hora real de salida  
fecha_arribo    TIMESTAMP?            // Fecha/hora real de arribo  
tipo_etapa      TEXT NOT NULL         // &#39;COMERCIAL&#39; | &#39;INSTITUCIONAL&#39;  
observaciones   TEXT?  
}

Table mareas_observadores {  
id              TEXT (PK)             // UUID interno  
id_marea        TEXT NOT NULL         // FK → mareas.id  
id_observador   TEXT NOT NULL         // FK → observadores.id  
rol_en_marea    TEXT NOT NULL         // &#39;PRINCIPAL&#39; | &#39;ACOMPAÑANTE&#39; | &#39;TECNICO&#39; | &#39;OTRO&#39;  
fecha_inicio    DATE?                 // Desde cuándo actúa ese observador en la marea  
fecha_fin       DATE?                 // Hasta cuándo  
observaciones   TEXT?  
}

Table mareas_movimientos {  
id              TEXT (PK)  
id_marea        TEXT NOT NULL         // FK → mareas.id  
fecha_hora      TIMESTAMP NOT NULL  
id_usuario      TEXT?                 // Usuario que registró el evento (FK → users.id)  
tipo_evento     TEXT NOT NULL         // &#39;CAMBIO_ESTADO&#39; | &#39;RECEPCION_DATOS&#39; | &#39;ENTREGA_OTOLITOS&#39;, etc.  
id_estado_desde TEXT?                 // FK → estados_marea.id  
id_estado_hasta TEXT?                 // FK → estados_marea.id  
cantidad_muestras_otolitos INTEGER?   // Solo si tipo_evento = &#39;ENTREGA_OTOLITOS&#39;  
detalle         TEXT?                 // Comentario libre  
}

Table mareas_archivos {  
id              TEXT (PK)  
id_marea        TEXT NOT NULL         // FK → mareas.id  
id_movimiento_origen TEXT?            // FK → mareas_movimientos.id  
tipo_archivo    TEXT NOT NULL         // &#39;DATOS_OBSERVADOR&#39; | &#39;INFORME_MAREA&#39;, etc.  
formato         TEXT?                 // &#39;DBF&#39; | &#39;XLS&#39; | &#39;PDF&#39;, etc.  
version         TEXT?                 // &#39;ORIGINAL&#39; | &#39;CORREGIDO&#39; | &#39;FINAL&#39;  
ruta_archivo    TEXT NOT NULL         // Path interno o URL al storage  
fecha_subida    TIMESTAMP NOT NULL  
id_usuario_subio TEXT?                // Quién lo subió (FK → users.id)  
descripcion     TEXT?  
}

// ==========================================  
// 4. TABLAS DE DATOS DE MUESTREO (OBS)  
// ==========================================

Table Lance {  
lance_id              TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
marea_id              TEXT NOT NULL                  // FK → mareas.id  
numero_lance          INTEGER NOT NULL               // UNIQUE (marea_id, numero_lance)  
fecha                 DATE NOT NULL  
cod_arte_pesca        INTEGER NOT NULL               // FK a artes_pesca.codigo_numerico  
tipo_arte_pesca       INTEGER  
hora_inicio           REAL  
lat_inicio            REAL  
long_inicio           REAL  
prof_inicio           INTEGER  
hora_final            REAL  
lat_final             REAL  
long_final            REAL  
prof_final            INTEGER  
rumbo                 INTEGER  
distancia_red         REAL  
velocidad_arrastre    REAL  
tiempo_red            INTEGER  
estacion_gral         INTEGER  
calador               TEXT  
fondo_min             INTEGER  
fondo_max             INTEGER  
tamiz                 TEXT  
area_barrida          REAL  
captura_total_kg      REAL  
descarte_total_kg     REAL  
observaciones_lance   TEXT  
mus                   INTEGER  
fuente_dato           INTEGER  
}

Table Captura {  
captura_id            TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
lance_id              TEXT NOT NULL                  // FK → Lance.lance_id  
especie_id            TEXT NOT NULL                  // FK → Especie  
kg_captura            REAL NOT NULL  
kg_descarte           REAL NOT NULL  
observaciones_captura TEXT  
indice_original       INTEGER NOT NULL               // UNIQUE (lance_id, especie_id)  
}

Table Muestra {  
muestra_cabecera_id   TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
lance_id              TEXT NOT NULL                  // FK → Lance.lance_id  
especie_id            TEXT NOT NULL                  // FK → Especie   
tipo_muestra          TEXT NOT NULL                  // &#39;CAPTURA&#39; | &#39;DESCARTE&#39;. UNIQUE (lance_id, especie_id, tipo_muestra)  
peso_muestra_kg       REAL  
fact_ponderacion      REAL  
unidad_largo          TEXT NOT NULL                  // &#39;mm&#39; | &#39;cm&#39;  
primera_talla         INTEGER  
ultima_talla          INTEGER  
intervalo_mm          INTEGER  
total_mediciones      INTEGER  
observaciones         TEXT  
}

Table Muestra_Detalle_Talla {  
muestra_detalle_id    TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
muestra_cabecera_id   TEXT NOT NULL                  // FK → Muestra.muestra_cabecera_id  
talla_mm              INTEGER NOT NULL               // UNIQUE (muestra_cabecera_id, talla_mm)  
cantidad_machos       INTEGER NOT NULL  
cantidad_hembras      INTEGER NOT NULL  
cantidad_indet        INTEGER NOT NULL  
cantidad_total        INTEGER NOT NULL  
indice_original       INTEGER NOT NULL  
}

Table Submuestras {  
ejemplar_id           TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
muestra_cabecera_id   TEXT NOT NULL                  // FK → Muestra.muestra_cabecera_id  
numero_ejemplar       INTEGER NOT NULL               // UNIQUE (muestra_cabecera_id, numero_ejemplar)  
largo_total           INTEGER  
largo_estandar        INTEGER  
peso_total_g          REAL  
peso_gonadas_g        REAL  
sexo                  INTEGER  
estadio_madurez       INTEGER  
replecion             INTEGER  
contenido_estomacal   TEXT  
observaciones_ejemplar TEXT  
}

Table Produccion {  
produccion_id         TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
marea_id              TEXT NOT NULL                  // FK → mareas.id  
especie_id            TEXT NOT NULL                  // FK → Especie (asume catálogo)  
fecha                 DATE NOT NULL                  // UNIQUE (marea_id, especie_id, fecha, producto, categoria)  
producto              TEXT  
categoria             TEXT  
factor_conversion     REAL  
kg_produccion         REAL NOT NULL  
operarios             INTEGER  
}
