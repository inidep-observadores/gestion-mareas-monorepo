# Módulo de Administración de Observadores y Novedades

Este documento describe la arquitectura, flujo de datos y modelo operativo del módulo "Sistema de Observadores", el cual centraliza la gestión del personal (observadores), la administración de sus ausencias o novedades (licencias, francos, partes médicos) mediante automatizaciones, la gestión de feriados y el complejo cálculo de la planilla mensual de presentismo.

## 1. Arquitectura de Datos (Modelos Impactados)

El módulo interactúa principalmente con las siguientes tablas en la base de datos (esquema `public` a través de Prisma):

- **`Observador`**: Tabla maestra que contiene el padrón de observadores. Almacena datos personales, tipo de contrato, código interno (legajo), disponibilidad e impedimentos.
- **`ObservadorNovedad`**: Tabla transaccional que registra las "novedades" o ausencias (licencias, partes de enfermedad, francos compensatorios, etc.). Controla fechas de inicio y fin, motivo, estado de aprobación (`PENDIENTE`, `APROBADA`, `RECHAZADA`) y el origen de la novedad (`MANUAL`, `EMAIL`, `AUTOMATICO`).
- **`ObservadorNovedadArchivo`**: Tabla que vincula una novedad con los archivos adjuntos (certificados médicos, notas) que respaldan la ausencia. Estos archivos se suben y persisten físicamente en Google Drive, guardando en esta tabla el ID (`driveFileId`) y la ruta pública.
- **`Feriado`**: Registro de feriados nacionales o locales (días no laborables) requeridos para el correcto cálculo del presentismo.
- **`Marea`, `MareaEtapa`, `MareaEtapaObservador`**: Tablas periféricas del core de viajes fundamentales para determinar de forma retrospectiva y en tiempo real cuándo un observador se encuentra navegando o en un puerto externo.

## 2. Automatización y Cron de Novedades

La gestión de novedades cuenta con un sistema de sincronización automatizado vía correo electrónico, evitando la carga manual constante. Este flujo es gestionado por un Cron Job en segundo plano (`NOVEDADES_EMAIL_SYNC`).

### Flujo Técnico del Cron (Job Queue)
1. **Ejecución**: El programador de tareas (`SchedulerService`) gatilla periódicamente un trabajo del tipo `NOVEDADES_EMAIL_SYNC`, encolándolo de manera segura en el `JobQueue`.
2. **Procesamiento IMAP**: El worker `NovedadesEmailProcessor` toma la tarea y se conecta vía IMAP (`ImapService`) a la casilla de correo configurada.
3. **Extracción mediante Inteligencia Artificial**: Se extraen los correos no leídos y el texto o asunto se pasa por un analizador de IA (`NovedadesAiService`). Este servicio aplica procesamiento de lenguaje natural para inferir:
   - Nombre del observador o CUIL.
   - Tipo de novedad abstracta (`estadoDisponibilidad`).
   - Fechas exactas de (Inicio y Fin).
   - Motivo / Justificación.
4. **Inserción Inteligente**: Si el servicio logra emparejar el remitente/cuerpo del correo con un observador existente en la base de datos, inserta de manera automática un registro en la tabla `ObservadorNovedad` con origen `EMAIL` y dejándolo bajo el estado `PENDIENTE`.
5. **Gestión de Adjuntos con Google Drive**: Si el correo incluye archivos adjuntos (por ej. un PDF de un certificado médico), estos se suben automáticamente a Google Drive mediante la API de Google (`DriveStorageService`) y se registran en `ObservadorNovedadArchivo` vinculados a la novedad generada, permitiendo al administrador visualizarlos sin descargar nada.
6. **Cierre**: Se marca el correo como procesado en la casilla para no duplicar el trabajo en el futuro.

*Nota: Al igual que el cron de posiciones (PNA/Tracking), este proceso deja una traza en la tabla `JobQueue`, y los errores o métricas se pueden auditar visualmente en el panel de Gestión de Tareas del administrador (`/admin/jobs`).*

## 3. Lógica y Motor de Presentismo

El presentismo es una de las vistas analíticas más pesadas. **No se basa en el llenado manual o registros estáticos diarios de "asistencia"**, sino que se calcula de forma puramente dinámica y algorítmica al vuelo cada vez que se consulta un mes específico (`PresentismoService`).

La lógica cruza las tablas arriba mencionadas para cada día del mes y cada observador activo aplicando un árbol de prioridad:

1. **Futuro**: Si el día de la matriz iterado es mayor al día de hoy, se descarta y se marca automáticamente como `LIBRE`.
2. **Conflictos Críticos**: Si el observador registra más de un "estado duro" para un mismo día (por ejemplo, el registro de etapas dice que está `NAVEGANDO` pero a la vez existe una `NOVEDAD` de licencia por enfermedad aprobada), el sistema alerta marcando el día en color rojo oscuro como `CONFLICTO`.
3. **Navegando (`NAVEGANDO`)**: Revisa cada viaje. Si en el día en cuestión, el observador está activo en un viaje, cruzando las fechas de zarpada y arribo de las `MareaEtapa`, se marca el día en color verde vibrante.
4. **Puerto / Viaje (`PUERTO` / `VIAJE`)**: Si el cruce de etapas evidencia que el observador se bajó del buque pero en un puerto no local o está en tránsito previo o posterior, asume día de puerto o traslado.
5. **Novedad (`NOVEDAD`)**: Superadas las jerarquías de viaje, evalúa si la fecha intersecta con una `ObservadorNovedad` que posea estado explícito de `APROBADA`.
6. **Feriados y Fines de Semana (`FERIADO`, `FIN_SEMANA`)**: Cruza con la tabla `Feriado` y analiza matemáticamente si es Sábado o Domingo. Destacablemente, si el observador estaba navegando o en un puerto lejano durante un feriado o fin de semana, el servicio lo etiqueta como "Computa Franco" (En la exportación final de Excel, la celda recibe un borde rojo distintivo).
7. **Libre (`LIBRE`)**: Día base por descarte absoluto.

## 4. Flujo de Trabajo Habitual del Usuario (Administrador / Coordinador)

El flujo diario y mensual estándar para un usuario interactuando con este módulo se resume en los siguientes pasos:

1. **Ingreso y Diagnóstico (`/sistema/observadores/dashboard`)**
   - Panel de control de alto nivel donde el coordinador monitoriza indicadores generales, observadores inactivos o tareas pendientes.

2. **Auditoría Diaria de Novedades (`/sistema/observadores/novedades`)** 
   - El administrador entra periódicamente a esta vista.
   - Observará las novedades que ingresó manualmente, pero más importante aún, encontrará las licencias ingresadas automáticamente por el **Cron de Emails** marcadas como `PENDIENTE` y con origen `EMAIL`.
   - Revisa el resumen y hace clic en el documento adjunto (que abrirá en el navegador gracias a la integración con Google Drive).
   - Con base en la validez del parte, hace clic en **Aprobar** o **Rechazar**.
   - *Consideración vital: Solo las novedades marcadas como Aprobadas tendrán peso en el motor de presentismo.*

3. **Mantenimiento Calendario (`/sistema/observadores/feriados`)**
   - Una o dos veces al año, el encargado configura los días festivos locales y nacionales asegurando la robustez contable del sistema.

4. **Cierre de Ciclo de Asistencia (`/sistema/observadores/presentismo`)**
   - Al inicio del mes siguiente, el coordinador accede a la Matriz de Presentismo.
   - Realiza un barrido visual en busca de días rojos (`CONFLICTO`). Si los halla, soluciona la inconsistencia subyacente (arreglando una etapa de marea sin cerrar o un error de fechas en una novedad).
   - Una vez la matriz no presenta conflictos, utiliza el botón de **"Exportar a Excel"**.
   - El sistema le provee de una planilla corporativa, con un diseño pulido, totales contables y marcas en colores, lista para entregar al Departamento de Recursos Humanos.
