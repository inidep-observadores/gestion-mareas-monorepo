// ==========================================  
// 1. MÓDULO DE AUTENTICACIÓN Y USUARIOS  
// ==========================================

Table users {  
id &nbsp;            TEXT (PK)             // @id @default(uuid())  
email           TEXT NOT NULL         // @unique  
password        TEXT NOT NULL         // Contraseña hasheada  
full\_name       TEXT NOT NULL  
is\_active       BOOLEAN NOT NULL      // default true en Prisma  
roles           TEXT\[\] NOT NULL       // Array de roles, ej: \[&#39;user&#39;, &#39;admin&#39;\]  
}

Table password\_reset\_tokens {  
id              TEXT (PK)             // UUID, generado con uuid()  
token           TEXT NOT NULL  
expires\_at      TIMESTAMP NOT NULL    // expira el enlace de reseteo  
used            BOOLEAN NOT NULL      // true = ya fue utilizado  
requested\_ip    TEXT?                 // IP desde donde se solicitó el reseteo  
created\_at      TIMESTAMP NOT NULL    // fecha/hora de creación del token  
user\_id         TEXT NOT NULL         // FK → users.id (ON DELETE CASCADE)  
}

// ==========================================  
// 2. CATÁLOGOS BASE (MAESTRAS)  
// ==========================================

Table buques {  
id              TEXT (PK)

// Identificación  
nombre\_buque    TEXT NOT NULL  
matricula       TEXT NOT NULL (UNIQUE)  
codigo\_interno  INTEGER               // Código interno del INIDEP

// Clasificación estructural  
id\_tipo\_flota   TEXT?                 // FK → tipos\_flota.id  
id\_arte\_habitual      TEXT?           // FK → artes\_pesca.id  
id\_pesqueria\_habitual TEXT?           // FK → pesquerias.id

// Parámetros operativos del buque  
dias\_marea\_estimada INTEGER?  
eslora\_m        NUMERIC(6,2)?         // Eslora en metros  
potencia\_hp     INTEGER?              // Potencia del motor en HP

// Datos administrativos  
id\_puerto\_base  TEXT?                 // FK → puertos.id  
empresa\_nombre  TEXT?  
empresa\_localidad TEXT?  
empresa\_telefono TEXT?  
empresa\_fax     TEXT?  
empresa\_correo\_principal TEXT?  
empresa\_correo\_secundario TEXT?  
armador\_nombre  TEXT?  
armador\_telefono TEXT?  
agencia\_maritima\_nombre TEXT?

// Gestión del catálogo  
activo          BOOLEAN NOT NULL  
fecha\_alta      DATE?  
fecha\_baja      DATE?  
observaciones   TEXT?  
}

Table artes\_pesca {  
id              TEXT (PK)             // UUID interno  
codigo\_numerico INTEGER NOT NULL      // Código oficial o histórico  
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
codigo\_interno  TEXT?                 // Código interno INIDEP  
codigo\_externo  TEXT?                 // Código de otros sistemas (Prefectura, etc.)  
activo          BOOLEAN NOT NULL  
orden           INTEGER?  
observaciones   TEXT?  
}

Table especies {  
 id                TEXT (PK)          // UUID interno

 codigo             TEXT NOT NULL     // Código alfanumérico de 10 dígitos  
                                      // (se guarda como texto para preservar ceros a la izquierda)

 nombre\_cientifico  TEXT NOT NULL     // Ej.: Merluccius hubbsi  
 nombre\_vulgar      TEXT NOT NULL     // Ej.: Merluza común

 activo             BOOLEAN NOT NULL  // Para especies en uso / históricas  
 observaciones      TEXT?  
}

Table observadores {  
id              TEXT (PK)             // UUID interno  
codigo\_interno  INTEGER NOT NULL      // Código interno del INIDEP  
nombre          TEXT NOT NULL  
apellido        TEXT NOT NULL  
foto\_url        TEXT?                 // Ruta/URL de foto del observador  
tipo\_observador TEXT NOT NULL         // &#39;OBSERVADOR&#39; | &#39;TECNICO&#39;  
activo          BOOLEAN NOT NULL      // true = puede embarcar  
observaciones   TEXT?  
}

Table observadores\_bitacora {  
id              TEXT (PK)             // UUID interno  
id\_observador   TEXT NOT NULL         // FK → observadores.id  
id\_marea        TEXT?                 // FK → mareas.id (contexto opcional)  
fecha           TIMESTAMP NOT NULL    // Cuándo se registró la observación

// Clasificación  
tipo            TEXT NOT NULL         // &#39;DESEMPEÑO&#39; | &#39;SALUD&#39; | &#39;ADMINISTRATIVO&#39; | &#39;OTRO&#39;  
severidad       TEXT?                 // &#39;BAJA&#39; | &#39;MEDIA&#39; | &#39;ALTA&#39;

// Contenido  
titulo          TEXT?  
descripcion     TEXT NOT NULL  
id\_usuario\_autor TEXT NOT NULL        // FK lógico → users.id (Autor del registro)  
}

// ==========================================  
// 3. GESTIÓN DE MAREAS (FLUJO Y AUDITORÍA)  
// ==========================================

Table estados\_marea {  
id              TEXT (PK)             // UUID interno  
codigo          TEXT NOT NULL         // Ej.: &#39;DESIGNADA&#39;, &#39;EN\_CORRECCION&#39;  
nombre          TEXT NOT NULL         // Etiqueta visible para usuarios  
descripcion     TEXT?  
categoria       TEXT NOT NULL         // &#39;PENDIENTE&#39; | &#39;EN\_CURSO&#39; | &#39;COMPLETADO&#39; | &#39;CANCELADO&#39;  
orden           INTEGER NOT NULL  
es\_inicial      BOOLEAN NOT NULL      // true solo para DESIGNADA  
es\_final        BOOLEAN NOT NULL      // true para PROTOCOLIZADA / CANCELADA  
permite\_carga\_archivos BOOLEAN NOT NULL  
permite\_correccion BOOLEAN NOT NULL  
permite\_informe BOOLEAN NOT NULL  
activo          BOOLEAN NOT NULL  
}

Table mareas {  
id              TEXT (PK)             // UUID interno

// Identificación básica  
anio\_marea      INTEGER NOT NULL  
nro\_marea       INTEGER NOT NULL      // UNIQUE (anio\_marea, nro\_marea, id\_buque)  
// Relación con buque, estado y pesquería  
id\_buque        TEXT NOT NULL         // FK → buques.id  
id\_pesqueria    TEXT?                 // FK → pesquerias.id (pesquería efectiva)  
id\_arte\_principal TEXT?               // FK → artes\_pesca.id  
id\_estado\_actual TEXT NOT NULL        // FK → estados\_marea.id (Estado actual)

// Fechas y descripción  
fecha\_zarpada\_estimada TIMESTAMP?  
titulo          TEXT?  
descripcion     TEXT?

// Información administrativa  
nro\_protocolización INTEGER  
anio\_protocolización INTEGER

// Gestión y auditoría  
fecha\_creacion  TIMESTAMP NOT NULL  
fecha\_ultima\_actualizacion TIMESTAMP NOT NULL  
activo          BOOLEAN NOT NULL  
observaciones   TEXT?  
}

Table mareas\_etapas {  
id              TEXT (PK)  
id\_marea        TEXT NOT NULL         // FK → mareas.id  
nro\_etapa       INTEGER NOT NULL      // 1, 2, 3...  
id\_puerto\_zarpada TEXT?               // FK → puertos.id  
id\_puerto\_arribo TEXT?                // FK → puertos.id  
fecha\_zarpada   TIMESTAMP?            // Fecha/hora real de salida  
fecha\_arribo    TIMESTAMP?            // Fecha/hora real de arribo  
tipo\_etapa      TEXT NOT NULL         // &#39;COMERCIAL&#39; | &#39;INSTITUCIONAL&#39;  
observaciones   TEXT?  
}

Table mareas\_observadores {  
id              TEXT (PK)             // UUID interno  
id\_marea        TEXT NOT NULL         // FK → mareas.id  
id\_observador   TEXT NOT NULL         // FK → observadores.id  
rol\_en\_marea    TEXT NOT NULL         // &#39;PRINCIPAL&#39; | &#39;ACOMPAÑANTE&#39; | &#39;TECNICO&#39; | &#39;OTRO&#39;  
fecha\_inicio    DATE?                 // Desde cuándo actúa ese observador en la marea  
fecha\_fin       DATE?                 // Hasta cuándo  
observaciones   TEXT?  
}

Table mareas\_movimientos {  
id              TEXT (PK)  
id\_marea        TEXT NOT NULL         // FK → mareas.id  
fecha\_hora      TIMESTAMP NOT NULL  
id\_usuario      TEXT?                 // Usuario que registró el evento (FK → users.id)  
tipo\_evento     TEXT NOT NULL         // &#39;CAMBIO\_ESTADO&#39; | &#39;RECEPCION\_DATOS&#39; | &#39;ENTREGA\_OTOLITOS&#39;, etc.  
id\_estado\_desde TEXT?                 // FK → estados\_marea.id  
id\_estado\_hasta TEXT?                 // FK → estados\_marea.id  
cantidad\_muestras\_otolitos INTEGER?   // Solo si tipo\_evento = &#39;ENTREGA\_OTOLITOS&#39;  
detalle         TEXT?                 // Comentario libre  
}

Table mareas\_archivos {  
id              TEXT (PK)  
id\_marea        TEXT NOT NULL         // FK → mareas.id  
id\_movimiento\_origen TEXT?            // FK → mareas\_movimientos.id  
tipo\_archivo    TEXT NOT NULL         // &#39;DATOS\_OBSERVADOR&#39; | &#39;INFORME\_MAREA&#39;, etc.  
formato         TEXT?                 // &#39;DBF&#39; | &#39;XLS&#39; | &#39;PDF&#39;, etc.  
version         TEXT?                 // &#39;ORIGINAL&#39; | &#39;CORREGIDO&#39; | &#39;FINAL&#39;  
ruta\_archivo    TEXT NOT NULL         // Path interno o URL al storage  
fecha\_subida    TIMESTAMP NOT NULL  
id\_usuario\_subio TEXT?                // Quién lo subió (FK → users.id)  
descripcion     TEXT?  
}

// ==========================================  
// 4. TABLAS DE DATOS DE MUESTREO (OBS)  
// ==========================================

Table Lance {  
lance\_id              TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
marea\_id              TEXT NOT NULL                  // FK → mareas.id  
numero\_lance          INTEGER NOT NULL               // UNIQUE (marea\_id, numero\_lance)  
fecha                 DATE NOT NULL  
cod\_arte\_pesca        INTEGER NOT NULL               // FK a artes\_pesca.codigo\_numerico  
tipo\_arte\_pesca       INTEGER  
hora\_inicio           REAL  
lat\_inicio            REAL  
long\_inicio           REAL  
prof\_inicio           INTEGER  
hora\_final            REAL  
lat\_final             REAL  
long\_final            REAL  
prof\_final            INTEGER  
rumbo                 INTEGER  
distancia\_red         REAL  
velocidad\_arrastre    REAL  
tiempo\_red            INTEGER  
estacion\_gral         INTEGER  
calador               TEXT  
fondo\_min             INTEGER  
fondo\_max             INTEGER  
tamiz                 TEXT  
area\_barrida          REAL  
captura\_total\_kg      REAL  
descarte\_total\_kg     REAL  
observaciones\_lance   TEXT  
mus                   INTEGER  
fuente\_dato           INTEGER  
}

Table Captura {  
captura\_id            TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
lance\_id              TEXT NOT NULL                  // FK → Lance.lance\_id  
especie\_id            TEXT NOT NULL                  // FK → Especie  
kg\_captura            REAL NOT NULL  
kg\_descarte           REAL NOT NULL  
observaciones\_captura TEXT  
indice\_original       INTEGER NOT NULL               // UNIQUE (lance\_id, especie\_id)  
}

Table Muestra {  
muestra\_cabecera\_id   TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
lance\_id              TEXT NOT NULL                  // FK → Lance.lance\_id  
especie\_id            TEXT NOT NULL                  // FK → Especie   
tipo\_muestra          TEXT NOT NULL                  // &#39;CAPTURA&#39; | &#39;DESCARTE&#39;. UNIQUE (lance\_id, especie\_id, tipo\_muestra)  
peso\_muestra\_kg       REAL  
fact\_ponderacion      REAL  
unidad\_largo          TEXT NOT NULL                  // &#39;mm&#39; | &#39;cm&#39;  
primera\_talla         INTEGER  
ultima\_talla          INTEGER  
intervalo\_mm          INTEGER  
total\_mediciones      INTEGER  
observaciones         TEXT  
}

Table Muestra\_Detalle\_Talla {  
muestra\_detalle\_id    TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
muestra\_cabecera\_id   TEXT NOT NULL                  // FK → Muestra.muestra\_cabecera\_id  
talla\_mm              INTEGER NOT NULL               // UNIQUE (muestra\_cabecera\_id, talla\_mm)  
cantidad\_machos       INTEGER NOT NULL  
cantidad\_hembras      INTEGER NOT NULL  
cantidad\_indet        INTEGER NOT NULL  
cantidad\_total        INTEGER NOT NULL  
indice\_original       INTEGER NOT NULL  
}

Table Submuestras {  
ejemplar\_id           TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
muestra\_cabecera\_id   TEXT NOT NULL                  // FK → Muestra.muestra\_cabecera\_id  
numero\_ejemplar       INTEGER NOT NULL               // UNIQUE (muestra\_cabecera\_id, numero\_ejemplar)  
largo\_total           INTEGER  
largo\_estandar        INTEGER  
peso\_total\_g          REAL  
peso\_gonadas\_g        REAL  
sexo                  INTEGER  
estadio\_madurez       INTEGER  
replecion             INTEGER  
contenido\_estomacal   TEXT  
observaciones\_ejemplar TEXT  
}

Table Produccion {  
produccion\_id         TEXT PRIMARY KEY NOT NULL UNIQUE // UUID interno  
marea\_id              TEXT NOT NULL                  // FK → mareas.id  
especie\_id            TEXT NOT NULL                  // FK → Especie (asume catálogo)  
fecha                 DATE NOT NULL                  // UNIQUE (marea\_id, especie\_id, fecha, producto, categoria)  
producto              TEXT  
categoria             TEXT  
factor\_conversion     REAL  
kg\_produccion         REAL NOT NULL  
operarios             INTEGER  
}