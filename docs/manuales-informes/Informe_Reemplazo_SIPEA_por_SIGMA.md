# Informe: Fundamentos del reemplazo del sistema SIPEA por el sistema SIGMA

**Instituto Nacional de Investigación y Desarrollo Pesquero (INIDEP) — Programa de Observadores a Bordo**
**Estado del documento:** Segundo borrador, sujeto a revisión
**Destinatarios:** Dirección y autoridades institucionales

---

## 1. Resumen

Durante varios años, el Instituto utilizó el sistema **SIPEA** (Sistema de Inteligencia y Planificación del Esfuerzo Pesquero) para organizar el trabajo de los Observadores a Bordo, registrar sus embarques y justificar sus días de actividad. SIPEA cumplió su función, pero presentaba limitaciones que ponían en riesgo la continuidad y la confiabilidad de la información.

Como respuesta se desarrolló **SIGMA** (Sistema Integral de Gestión de Mareas). Su desarrollo comenzó en diciembre de 2025, entró en uso real en febrero de 2026, convivió durante varios meses con SIPEA y, desde principios de julio de 2026, es el **sistema principal de gestión de mareas**; SIPEA dejó de utilizarse.

Este informe documenta los motivos del reemplazo y muestra que SIGMA:

- **Cubre las funciones sustantivas que ofrecía SIPEA** (sección 4).
- **Resuelve sus problemas de fondo**: permite que varias personas trabajen a la vez sin errores, desde cualquier oficina con acceso autorizado.
- **Incorpora numerosas funciones nuevas** (mapa en vivo, calendario de observadores, control de documentación de embarque, lectura asistida de correos, paneles de control, registro de toda actividad, entre otras).

---

## 2. Situación anterior: el sistema SIPEA

SIPEA era un programa instalado en computadoras con Windows que tomaba su información de un único archivo compartido en la red interna del Instituto. Según su documentación, funcionaba en una red local de **6 computadoras**, aisladas de internet.

Cubría, entre otras tareas:

- Seguimiento de la situación de cada observador (en tierra, designado o navegando).
- Registro de designaciones a buques y de las mareas realizadas.
- Consulta automática a Prefectura Naval Argentina (PNA) para detectar zarpadas y arribos, basándose únicamente en los eventos de zarpada y arribo informados por PNA, sin considerar la información de seguimiento satelital de los buques.
- Libro de asistencias y novedades para Recursos Humanos.
- Mensajería interna, calificación de la tarea de los observadores y gráficos de actividad.

### 2.1. Limitaciones que motivaron el reemplazo

| Limitación de SIPEA | Qué significaba en la práctica |
|---|---|
| **Tecnología antigua.** Base de datos en un formato de archivo (Access, .mdb) que ya no evoluciona. | Riesgo creciente de fallas, dificultad para conseguir soporte y compatibilidad cada vez menor con equipos y sistemas nuevos. |
| **Pensado para un solo usuario.** El archivo estaba compartido en la red, pero no preparado para uso simultáneo. | Cuando dos o más personas trabajaban a la vez se producían errores, bloqueos y riesgo de deterioro de la información. |
| **Instalación en cada computadora.** | Mayor trabajo de mantenimiento y riesgo de versiones distintas entre equipos. |
| **Acceso solo desde las 6 computadoras habilitadas.** | No era posible consultar información desde otras oficinas ni de forma remota. |
| **Copias de seguridad dependientes de computadoras de la red.** | Si esos equipos fallaban, se corría riesgo de perder información histórica. |
| **Planillas de Excel como parte del proceso oficial.** | Un archivo dañado o modificado por error afectaba el registro de asistencias. |
| **Difícil de ampliar.** | Cada mejora implicaba modificar y reinstalar el programa en cada equipo. |

---

## 3. La solución: el sistema SIGMA

SIGMA es una aplicación **web**: se utiliza desde un navegador de internet (como Chrome o Edge), igual que se ingresa a un sitio institucional o al correo electrónico. No requiere instalar programas en cada computadora.

Sus datos se guardan en un **servidor central** con tecnología actual y de uso profesional, diseñada para que muchas personas trabajen al mismo tiempo. Cada usuario ingresa con su propio correo y contraseña, y ve únicamente lo que su perfil le permite.

SIGMA es una herramienta de **gestión administrativa**: la utiliza el personal de las distintas oficinas del Instituto. No está pensada para uso a bordo ni en puerto por parte de los observadores.

---

## 4. Correspondencia entre las funciones de SIPEA y de SIGMA

> **Referencia:** ✅ Cubierta e incluso mejorada · 🔄 Cubierta con un enfoque diferente · ⏳ Prevista a futuro · ➖ Decisión de no implementar

### 4.1. Gestión de asistencia y novedades

| Función en SIPEA | Equivalente en SIGMA | Estado |
|-------------------------|----------------------------------------------------------------------|-----|
| Acceso con usuario y contraseña | Ingreso con correo y contraseña personal, con perfiles diferenciados (administrador, coordinador, planificador, técnico, visitante, etc.) | ✅ |
| Recepción de correos de ZARPADA y ARRIBO | Ya no es necesario el aviso del observador: zarpadas y arribos se determinan automáticamente con la información de PNA. Para otros puertos (distintos de Mar del Plata), el sistema recibe por correo los pasajes de cada marea y los procesa de forma automática, con asistencia de inteligencia artificial | 🔄 |
| Marcación automática del estado "Navegando" | La situación del observador se calcula automáticamente a partir de las mareas y los viajes registrados | ✅ |
| Registro consolidado de asistencias | **Planilla mensual de presentismo** en pantalla, con feriados, fines de semana y francos compensatorios resaltados | ✅ |
| Carga de novedades oficiales (licencias, francos, vacaciones) | Los PDF de novedades se descargan del sistema GDE y se envían por correo electrónico a la casilla monitoreada por SIGMA, que los procesa con asistencia de inteligencia artificial y los registra como novedades. No requiere conexión directa con GDE | 🔄 |
| Informe mensual para Recursos Humanos | Exportación a Excel de la planilla de presentismo, con notas explicativas en cada celda | ✅ |
| Fichero histórico de documentación | Archivo de documentación en Google Drive con consulta directa desde la aplicación | 🔄 |

### 4.2. Planificación y seguimiento de designaciones y mareas

| Función en SIPEA | Equivalente en SIGMA | Estado |
|-------------------------|----------------------------------------------------------------------|-----|
| Designación con identificador único de marea | Gestión completa de cada marea, con identificador único y diferenciación entre **campañas institucionales (CI)** y **mareas comerciales (MC)** | ✅ |
| Consulta horaria a Prefectura (PNA) | Sincronización automática con Prefectura, con registro de errores. Además, SIGMA realiza una **doble validación**: contrasta las declaraciones de zarpada y arribo con los datos del sistema de monitoreo satelital de la flota, ambos obtenidos de Prefectura. Solo cuando ambas fuentes coinciden se confirma automáticamente el movimiento del buque; si hay diferencias, el sistema genera una alerta para que un usuario autorizado lo confirme o lo descarte manualmente | ✅ |
| Cambio automático de estado de buque y observador al zarpar | Actualización automática del estado de la marea y del observador | ✅ |
| Detección automática de arribos | Idem, con cierre automático de la etapa o finalización automática de la marea, según las condiciones operativas | ✅ |
| Finalización controlada de una designación | Posibilidad de **cancelar** una designación, o **desestimar** una marea, exigiendo siempre una observación que justifique la decisión | ✅ |
| Prospecciones y campañas institucionales | Soportadas como tipos de actividad dentro de la marea | ✅ |
| Cálculo de días navegados y etapas intermedias | Cálculo automático por observador y por etapa | ✅ |

### 4.3. Gestión de observadores

| Función en SIPEA | Equivalente en SIGMA | Estado |
|-------------------------|----------------------------------------------------------------------|-----|
| Estados: En tierra / Designado / Navegando | Línea de tiempo y **calendario de cada observador** con su historial completo | ✅ |
| Prioridad por tiempo sin navegar | **Vista de disponibilidad** con dos niveles y proyección futura, con filtros por estado y tipo de contrato | ✅ |
| Marcado de impedimentos | Novedades que bloquean la disponibilidad; bloqueo automático si la documentación está vencida | ✅ |
| Exportación de listados de agentes a Excel | Exportaciones a Excel con filtros | ✅ |

### 4.4. Análisis, auditoría y calificación

| Función en SIPEA | Equivalente en SIGMA | Estado |
|-------------------------|----------------------------------------------------------------------|-----|
| Gráficos por flota, etapa y especie | Paneles de control y estadísticas con gráficos | ✅ |
| Análisis de asignación por pesquería | Reportes anuales comparativos por pesquería y matriz de experiencia de los observadores | ✅ |
| Exportación analítica a Excel (planillas varias) | Exportaciones de auditoría y de datos de mareas, con diferentes filtros y posibilidades de agrupamiento de la información | ✅ |
| Búsqueda de mareas y novedades | Buscadores y filtros en todas las vistas | ✅ |
| Gestión de buques, empresas y armadores | Actualmente se gestionan los buques y sus características principales, con exportación de la lista en formato compatible con sistemas antiguos (OBS). Está planificado incorporar nuevas funcionalidades que incluyen, entre otras, la gestión de empresas, armadores y agencias marítimas asociadas a cada buque | 🔄 ⏳ |
| Cierre automático de etapa y marea "Verificada" | Estados de la marea con cierre y trazabilidad | ✅ |
| Calificación manual de la tarea del observador por el Revisor | **No se implementó** a propósito: la calificación manual depende del criterio de quien califica, sin reglas claras establecidas, lo que la vuelve subjetiva. Se prevé, a mediano plazo y con baja prioridad, un **módulo de corrección de datos de mareas** que pueda emitir una calificación automática y objetiva a partir del análisis de los datos cargados | ⏳ ➖ |

### 4.5. Comunicación, copias de seguridad y seguridad

| Función en SIPEA | Equivalente en SIGMA | Estado |
|-------------------------|----------------------------------------------------------------------|-----|
| Mensajería interna entre usuarios | **No se implementó**: se determinó que no aporta beneficios significativos a los procesos administrativos que gestiona el sistema. SIGMA sí incluye alertas en pantalla (por ejemplo, novedades pendientes en el tablero) | ➖ |
| Proceso automático que vigila Prefectura 24/7 | Tareas automáticas programadas en el servidor | ✅ |
| Copias de seguridad local y remota | Copias automáticas a intervalos programables (actualmente una por día) y copias manuales a demanda. Se guardan en el servidor y se respaldan periódicamente en la nube (Google Drive). A corto plazo está planificada la **subida automática** de cada copia a Google Drive | 🔄 |
| Red aislada de internet | Servicio protegido con cifrado, base de datos inaccesible desde internet y permisos por perfil | 🔄 |

**Síntesis:** todas las actividades sustantivas de SIPEA tienen su equivalente en SIGMA. Las únicas funciones no replicadas (mensajería interna y calificación manual) responden a decisiones fundadas, no a omisiones.

---

## 5. Funciones nuevas que SIPEA no ofrecía

### 5.1. Seguimiento en vivo de la flota
- **Mapa interactivo** con la ubicación de los buques, clima y viento, puertos y zonas de pesca (langostino, vieira, centolla, etc.).
- **Visualización de la trayectoria de los buques** casi en tiempo real, con una demora aproximada de 15 minutos.
- **Análisis de los buques en operación** mediante búsquedas por pesquería, observador, buque, entre otros criterios.

### 5.2. Mayor control sobre los observadores
- **Control de documentación de embarque** con **alertas de vencimiento** y bloqueo automático de disponibilidad si hay documentación vencida.
- Indicadores del estado documental al asignar un observador a una marea.
- **Observadores secundarios** por etapa, con validaciones.
- Calendario individual que une mareas, viajes, licencias y disponibilidad.

### 5.3. Planificación anticipada
- **Simulador de cobertura** con horizonte de cinco años.
- Proyecciones de disponibilidad.
- Matriz de experiencia de cada observador por pesquería.

### 5.4. Automatización inteligente
- **Lectura asistida de correos con inteligencia artificial**: interpreta el contenido y los adjuntos (por ejemplo, pasajes o PDF de novedades) y propone las novedades correspondientes.
- Respaldo automático de cada correo en PDF.
- Rectificación de novedades con comparación "antes y después".

### 5.5. Trazabilidad y seguridad
- **Registro de auditoría**: queda constancia de quién hizo qué, cuándo y desde dónde. No puede borrarse.
- Contraseñas protegidas de modo que ni el administrador puede conocerlas.
- Perfiles de usuario con permisos diferenciados.
- Comunicación cifrada y base de datos no expuesta a internet.

### 5.6. Paneles de control y reportes
- Tableros con indicadores y alertas.
- Reportes anuales comparativos y exportaciones más completas.

### 5.7. Experiencia de uso
- Diseño moderno, con **modo claro y oscuro**.
- Se adapta a computadoras, tabletas y teléfonos.
- Mensajes y etiquetas íntegramente en español.

---

## 6. Ventajas de la modalidad multiusuario y del acceso web

| Aspecto | SIPEA | SIGMA |
|---|---|---|
| Usuarios simultáneos | Uno por vez (con errores si hay más) | Todos los necesarios, sin conflictos |
| Dónde se usa | 6 computadoras con el programa instalado | Cualquier oficina del Instituto, y ocasionalmente de forma remota para gestión o consulta administrativa |
| Instalación | En cada equipo | Ninguna |
| Actualizaciones | Equipo por equipo | Una sola vez, para todos |
| Información | Archivo compartido, vulnerable a daños | Servidor central con base de datos profesional |
| Copias de seguridad | Dependientes de computadoras de la red | Automáticas diarias, manuales a demanda y respaldo en la nube |
| Registro de actividad | Limitado | Completo e inalterable |
| Permisos | Básicos | Perfiles con permisos específicos |
| Crecimiento futuro | Difícil | Previsto desde el diseño |

En términos concretos: varias personas pueden cargar mareas, novedades y asistencias al mismo tiempo; la información está siempre actualizada para todos; y la Dirección puede consultar tableros y reportes sin depender de una computadora en particular.

---

## 7. Línea de tiempo del reemplazo

| Fecha | Hito |
|---|---|
| Diciembre 2025 | Inicio del desarrollo de SIGMA: diseño de pantallas, tableros y primera versión del mapa |
| Febrero 2026 | Puesta en producción de la primera versión |
| Febrero – junio 2026 | **Uso en paralelo** de SIPEA y SIGMA. Se incorporan la conexión con Prefectura, paneles de control, auditoría y seguridad, observadores, novedades y presentismo, correo electrónico, Google Drive e inteligencia artificial |
| Principios de julio 2026 | **Se discontinúa SIPEA**; SIGMA pasa a ser el sistema principal de gestión de mareas |
| Julio – septiembre 2026 | Calendario del observador, simulador de cobertura, observadores secundarios, rectificación de novedades, vista de disponibilidad y control de documentación de embarque |

El período de uso en paralelo permitió comprobar el funcionamiento de SIGMA con datos reales antes de prescindir del sistema anterior.

---

## 8. Riesgos que se evitan con el reemplazo

1. **Pérdida de información** por fallas del archivo compartido o de los equipos que lo alojaban.
2. **Errores de registro** por uso simultáneo, que afectaban la confiabilidad de los datos de asistencia y días navegados.
3. **Dependencia tecnológica** de una herramienta sin evolución y con cada vez menos personas capacitadas para sostenerla.
4. **Imposibilidad de ampliar** funciones sin reinstalar el programa en cada equipo.
5. **Menor capacidad de auditoría**.

---

## 9. Próximos pasos previstos

- **Subida automática de las copias de seguridad a Google Drive** (corto plazo).
- **Módulo de corrección de datos de mareas**, con posible calificación automática (mediano plazo, baja prioridad).
- Consolidación de la primera versión definitiva (v1.0.0).

---

## 10. Conclusión

SIGMA cubre las funciones esenciales de SIPEA y aporta capacidades que antes no existían: trabajo simultáneo de varios usuarios, acceso desde las distintas oficinas, seguimiento visual de la flota, control documental de los observadores, planificación a futuro y registro completo de toda actividad.

La transición se realizó de manera gradual, con un período de uso en paralelo, y desde julio de 2026 SIGMA es el sistema de referencia. Este informe deja constancia de los fundamentos de esa decisión y de las mejoras que ya se encuentran en uso.
