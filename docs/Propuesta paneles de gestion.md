# Propuesta de implementación de paneles de gestión

Hallazgos clave en /docs

Modelo de marea basado en entidad + bitácora de eventos (mareas_movimientos), estados catalogados y archivos clasificados; el estado actual se deriva del último CAMBIO_ESTADO.
Fechas globales (estimada, inicio/fin observador) + etapas (zarpada/arribo por puerto) + alertas externas confirmables; cálculos de días navegados y días de marea dependen de etapas y puertos locales.
UX definida en dos niveles: formulario completo para creación/edición global; acciones contextuales rápidas para el día a día (registrar zarpada/arribo, notas, carga de datos, cambios de estado, etc.). Catálogo de eventos se genera automáticamente; el usuario no elige tipo de evento.
Vistas previstas: Panel operativo (en curso y previo a informe, con KPIs y lista “tipo vuelos”), Bandeja/Inbox (work items accionables con acciones permitidas calculadas por backend), Kanban de estados, y vista estadística anual.
Directrices de diseño: tema “Deep Ocean” en landing/login y “Professional Clean” en paneles internos, tokens de color (sin hardcode), dark mode por clase, FlyonUI como librería base, rutas nombradas, toasts con vue-sonner, Headless UI para modales.
Opciones de UX para registrar/buscar/editar mareas

Panel operativo como puerta de entrada: listado principal con CTA “Registrar marea”, filtros rápidos y panel lateral de contexto; acciones contextuales en cada fila según estado/permiso. Pros: un solo lugar, prioriza urgencias. Contras: puede saturarse si no hay buen filtrado.
Inbox central con creación guiada: botón global “Registrar nueva marea” + “Registrar hecho” (zarpada, arribo, carga de datos) que abre flujos cortos; cada acción genera items accionables y deja trazabilidad. Pros: alineado a modelo de work items y permisos; Contras: requiere backend de inbox listo.
Detalle de marea con command palette contextual (atajo “Ctrl/Cmd+K”): acciones rápidas (registrar etapa, cargar datos, nota, cambiar estado) sin salir de la vista; respeta el principio “formulario completo solo para edición avanzada”. Pros: velocidad; Contras: curva de aprendizaje inicial.
Kanban de estados con creación rápida: columna inicial con “+ Designar marea” y tarjetas con acciones de arrastre para cambios de estado validados por backend. Pros: visual para coordinadores; Contras: menos óptimo para carga masiva o búsqueda precisa.
Propuesta recomendada (enfocada en registro/búsqueda/edición)

Entrada principal en Panel operativo con tres CTA: “Registrar marea”, “Captura rápida” (zarpada/arribo/datos), “Buscar marea”.
Panel lateral persistente (detalle) al seleccionar una fila: ficha resumida, timeline corto, alertas activas, acciones contextuales (“Registrar zarpada”, “Registrar arribo”, “Cargar datos”, “Cambiar estado”, “Agregar nota”, “Abrir formulario completo”).
Formulario completo (modal ancho o vista dedicada) solo para creación y edición global; mantiene tabs para: Identificación (buque, año, número), Fechas globales, Etapas, Observador(es), Pesquería/arte, Descripción/observaciones.
Integración con Inbox: cada acción rápida crea/actualiza un work item (si aplica) y muestra badge de pendientes por marea; acceso directo “Ver pendientes” desde la ficha lateral.
Búsqueda unificada (spotlight): buque, número de marea, observador, estado; permite abrir la marea o lanzar una acción rápida directamente (“Registrar arribo en Marea 2025-034 – B/P Atlántico”).
Validaciones guiadas: backend expone actionsAvailable con enabled/blockedReason; frontend muestra solo acciones permitidas y explica bloqueos (“No puede cambiar a ‘Protocolizada’ sin informe aprobado”).
UI y estilo: modo claro por defecto “Professional Clean”, tipografía legible sin stack genérico (ej. Space Grotesk/Manrope + escala); botones FlyonUI, modales Headless UI, toasts vue-sonner (“Acción realizada. Sus datos se han guardado correctamente.”). Tokens de color brand-*/gray-* con bg-skin-* semántico; dark mode via useDarkMode.
Contratos backend iniciales a habilitar para esta fase

GET /dashboard/mareas?scope=operativo → KPIs + lista paginada con estado operativo, flags (alertas, bloqueada), acciones disponibles, últimos movimientos.
POST /mareas / PUT /mareas/{id} → creación/edición global (DTO completo).
Acciones rápidas (todas generan eventos automáticamente):
POST /mareas/{id}/registrar-inicio-observador (fecha)
POST /mareas/{id}/registrar-fin-observador (fecha)
POST /mareas/{id}/etapas (crear/cerrar con puertos/fechas)
POST /mareas/{id}/cambio-estado (estado destino, motivo)
POST /mareas/{id}/carga-datos (origen: original/externo/corregido, archivos)
POST /mareas/{id}/notas (administrativa/técnica)
GET /mareas/{id}/timeline y GET /mareas/{id}/actions para pintar timeline corto y habilitar botones.
GET /inbox/items?mareaId=… y POST /inbox/items (solo manuales: solicitudes, notas especiales) para enlazar con Bandeja.
Próximos pasos sugeridos

Acordar la combinación Panel operativo + Acciones rápidas + Formulario completo como flujo principal y dejar Inbox como soporte transversal.
Cerrar DTOs/contratos anteriores con backend (acciones rápidas + dashboard operativo) y seed de estados/acciones permitidas.
Definir UX detallado de Panel operativo (layout, columnas, CTA, panel lateral) y de los modales de captura rápida (zarpada, arribo, carga de datos).
Ajustar tokens de tema y componentes FlyonUI específicos (botones, tabs, tablas, modales) para prototipo.
Crear wireframes/high-fidelity para estas vistas y validarlos antes de codificar.




# Análisis de la propuesta

## 1. Modelo + UX: están bien acoplados (esto es clave)

El corazón del sistema —**entidad Marea + bitácora de eventos + estado derivado**— está perfectamente reflejado en la UX que proponen:

* Que el **estado actual se derive del último CAMBIO_ESTADO** y no sea editable “a mano” se traduce muy bien en:

  * acciones disponibles calculadas por backend
  * timeline como fuente de verdad
  * UI que *explica por qué algo no se puede hacer*

Esto evita uno de los males clásicos: formularios que permiten cosas que después el backend rechaza sin contexto. Acá pasa lo contrario: la UI **narra el estado del sistema**.

👉 Punto fuerte. No lo aflojen.

---

## 2. Separar “edición completa” de “acciones del día a día” es la decisión correcta

Esta distinción es, para mí, el mayor acierto conceptual:

* **Formulario completo**

  * solo para creación y edición global
  * con tabs claros y densidad alta
  * pensado para *pensar* la marea

* **Acciones rápidas contextuales**

  * pensadas para *operar*
  * cortas, con validación inmediata
  * trazables, siempre generan eventos

Esto replica cómo trabaja la gente en la práctica: nadie quiere abrir un formulario gigante para registrar una zarpada a las 3 AM.

Si mezclaban ambas cosas, el sistema se volvía pesado o peligroso. Acá no.

---

## 3. Evaluación de las opciones de entrada (panel / inbox / kanban / command palette)

### Panel operativo como puerta de entrada

✔️ **Correcto como default**

* Es natural para usuarios operativos.
* Permite priorizar urgencias.
* Escala bien si:

  * hay filtros rápidos
  * hay columnas bien pensadas
  * el panel lateral existe (y existe)

⚠️ Riesgo real: **ruido visual**
Solución:

* 5–7 columnas máximo
* badges y flags, no texto largo
* KPIs arriba muy sintéticos (3–4)

---

### Inbox central

✔️ Bien como **capa transversal**, no como entrada principal.

Coincido 100 % con dejarlo como soporte:

* depende mucho de backend listo
* introduce una abstracción más
* es ideal para:

  * pendientes
  * solicitudes
  * cosas “que alguien tiene que hacer”

Pero no lo pondría como home inicial. Buena decisión.

---

### Command palette (Ctrl/Cmd+K)

✔️ Súper bien como **acelerador**, no como dependencia.

Esto es un *luxury feature* bien entendida:

* usuarios avanzados la van a amar
* no rompe a los demás
* mantiene todo en una vista

Recomendación concreta:

* documentarla con tooltip sutil (“Acciones rápidas ⌘K”)
* no esconder acciones solo ahí

---

### Kanban

✔️ Útil para coordinadores
❌ No como flujo principal

Tal cual lo plantean:

* visual
* estratégico
* poco preciso para búsqueda y carga

Yo lo dejaría como vista secundaria desde el panel operativo (“Ver Kanban”).

---

## 4. La propuesta recomendada es coherente y ejecutable

La combinación final que proponen es sólida:

* **Panel operativo** → entrada
* **Panel lateral persistente** → contexto y acción
* **Formulario completo** → solo cuando hace falta
* **Inbox** → seguimiento
* **Búsqueda unificada** → navegación rápida

Esto tiene una virtud enorme:
👉 **no obliga a elegir un único modo mental**. El usuario puede:

* operar desde la lista
* profundizar desde el detalle
* saltar vía búsqueda
* revisar pendientes cuando quiere

Es flexible sin ser caótico.

---

## 5. Validaciones guiadas desde backend: imprescindible

El patrón `actionsAvailable + blockedReason` es exactamente el camino correcto.

Esto les permite:

* no duplicar reglas en frontend
* explicar el porqué, no solo bloquear
* mantener coherencia cuando cambien reglas operativas

Ejemplo que citan:

> “No puede cambiar a ‘Protocolizada’ sin informe aprobado”

Eso es UX madura. No hay nada peor que un botón gris sin explicación.

---

## 6. Diseño visual y stack UI

Todo lo que proponen acá es razonable y consistente:

* **FlyonUI + Headless UI**: buen balance entre velocidad y control.
* **Tokens semánticos**: clave si el sistema va a crecer.
* **Dark mode por clase**: perfecto, sin magia.
* **vue-sonner**: bien elegido, discreto.

Solo una advertencia:
⚠️ no se enamoren demasiado del tema visual en esta fase.
Primero:

* densidad
* jerarquía
* legibilidad
  Después, fine tuning estético.

---

## 7. Contratos backend: están bien pensados para arrancar

Los endpoints que listan son exactamente los que la UI necesita para no hacer malabares:

* dashboard operativo ya viene “cocinado”
* acciones rápidas son explícitas
* timeline separado
* acciones disponibles separadas

Eso permite un frontend **declarativo**, no reactivo a errores.

---

## 8. Qué ajustaría o reforzaría antes de codificar

Te marco 5 ajustes finos:

1. **Definir muy bien las columnas del panel operativo**
   Antes de codear:

   * nombre exacto
   * orden
   * qué es badge, qué es texto

2. **Especificar el contenido mínimo del panel lateral**
   Qué se ve *siempre*, qué es colapsable.

3. **Decidir si el formulario completo es modal ancho o vista**
   Yo prefiero:

   * creación → vista
   * edición → modal ancho
     Pero decídanlo ahora.

4. **Definir microcopy estándar**
   Mensajes de éxito, error, bloqueo. Uno solo, coherente.

5. **Wireframes antes de código**
   No salteen esto. Les va a ahorrar refactors caros.

---

## Opinión final (sin vueltas)

La propuesta es **sólida, madura y muy bien alineada con el dominio**. No está sobre–diseñada, pero tampoco es naïf. Prioriza operación real, trazabilidad y control, sin castigar velocidad.

Si avanzan con:

* Panel operativo + panel lateral
* acciones rápidas bien delimitadas
* backend mandando la lógica

van a tener una UI que envejece bien, incluso cuando el sistema crezca y se complique.

Cuando quieran, el próximo paso lógico es:
👉 **bajar esto a wireframes concretos** y ahí sí empezar a discutir píxeles, no ideas.


## Decisiones tomadas respecto al punto 8

---

## 1) Columnas del Panel Operativo (definición cerrada)

### Objetivo

Que en **una pantalla** puedas: *encontrar*, *priorizar*, *actuar*.

### Decisión

Máximo **7 columnas**, con ancho controlado y prioridad a señales rápidas.

**Columnas (orden y contenido):**

1. **Marea**

   * `AÑO-NNN` (ej. `2025-034`)
   * debajo, *pesquería/arte* en texto chico (si entra)
2. **Buque**

   * Nombre corto (sin razón social)
   * tooltip con matrícula / MMSI si aplica
3. **Estado**

   * pill/badge con color semántico (no arcoíris)
   * opcional: subestado operativo si existe (ej. “En navegación”)
4. **Etapa actual**

   * `Zarpada: dd/mm` o `Arribo: dd/mm` según corresponda
   * si no hay etapas: “Sin etapas”
5. **Observador**

   * apellido, nombre (o inicial)
   * badge si “Sin observador” (alerta operativa)
6. **Pendientes / Alertas**

   * 2 badges máximo:

     * `Pend: X` (work items abiertos)
     * `⚠ Y` (alertas activas)
7. **Acciones**

   * botón primario contextual (solo 1): “Registrar arribo” / “Cargar datos” / “Cambiar estado”
   * menú “⋯” con acciones secundarias

**Qué NO meto en columnas:**

* puertos completos (van al panel lateral)
* descripciones largas
* timeline completo

**Regla UX:** scroll horizontal prohibido. Si no entra, se recorta y tooltip.

---

## 2) Panel lateral persistente (contenido mínimo + qué es colapsable)

### Decisión

Panel lateral fijo al seleccionar fila. Tres bloques: **Resumen**, **Acciones**, **Actividad**.

**A. Resumen (siempre visible)**

* Título: `Marea 2025-034` + Buque
* Estado actual (badge)
* Chips: Pesquería/arte, Observador, Puerto actual (si aplica)
* Métricas mini:

  * `Días marea` / `Días navegados` (si ya calculable)
  * si no, mostrar “—” sin inventar

**B. Acciones (siempre visible)**
Lista de 4–6 botones máximo, calculados por backend:

* Acción primaria destacada (1)
* 3–5 secundarias

Cuando está bloqueada:

* botón disabled + `blockedReason` visible al hover y como helper text.

**C. Actividad (colapsable)**

* “Timeline corto” de últimos 5–8 eventos
* Link “Ver timeline completo”
* Alertas activas (si las hay), con CTA “Confirmar / Descartar”

**Notas**

* “Ver pendientes” como link si `Pend > 0`.

---

## 3) Formulario completo: modal ancho vs vista dedicada

### Decisión final (para mí, la mejor):

* **Crear marea → vista dedicada** (`/mareas/nueva`)
* **Editar global → vista dedicada** (`/mareas/:id/editar`)
* **Edición rápida jamás toca el formulario completo.**

**Por qué vista y no modal ancho:**

* formularios grandes + tabs + validaciones + uploads → modal se vuelve frágil
* mejor navegación, back/forward, recarga, deep link
* más fácil de testear y mantener

**Modal ancho lo dejo solo para:**

* Captura rápida (zarpada/arribo/carga de datos/notas)
* Confirmaciones
* Pequeños “pickers”

---

## 4) Microcopy estándar (toasts, errores, bloqueos)

### Decisión

Un set cerrado, consistente, sin tecnicismos.

**Toasts de éxito (1 línea, siempre igual de tono):**

* “Acción registrada correctamente.”
* “Los cambios se guardaron correctamente.”
* “Archivo cargado correctamente.”

**Errores (1 línea + opcional detalle plegable):**

* “No se pudo completar la acción. Intente nuevamente.”
* Link “Ver detalle” si es útil (y ahí sí mostrar el mensaje del backend)

**Bloqueos (siempre explicativos, sin culpar):**

* Prefijo fijo: “No disponible: …”
* Ej: “No disponible: falta registrar zarpada.”

**Confirmaciones (siempre verbos claros):**

* “Confirmar arribo”
* “Descartar alerta”
* “Cancelar cambios”
* “Guardar”

Y regla: nada de “Operación realizada con éxito” (suena a sistema viejo del 98).

---

## 5) Wireframes: qué producir antes de escribir una línea de UI

### Decisión

No hago “wireframes de todo”. Hago **4 pantallas clave** y **3 modales**, high-fidelity liviano.

**Wireframes (4):**

1. Panel operativo (tabla + KPIs + filtros)
2. Panel operativo con fila seleccionada (panel lateral abierto)
3. Vista detalle de marea (timeline completo + tabs de lectura)
4. Formulario completo (create/edit) con tabs

**Modales (3):**

1. Captura rápida – Zarpada
2. Captura rápida – Arribo
3. Carga de datos (con origen + archivo)

**Plus opcional:** Spotlight search (1 mock) si lo van a implementar temprano.

---

## Bonus: una regla de oro para que no se les desmadre

**Todo lo que sea “acción rápida” tiene que:**

1. durar menos de 20–30 segundos
2. terminar con toast
3. dejar un evento en timeline
4. refrescar `actionsAvailable` al volver

Si no cumple, no es “rápida”: es formulario.

