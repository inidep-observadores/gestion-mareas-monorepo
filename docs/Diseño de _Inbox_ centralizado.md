# Bandeja de entrada (Inbox) para gestión centralizada de Mareas

## Objetivo

Diseñar una funcionalidad de **bandeja de entrada centralizada** (tipo “inbox”) que actúe como **punto único y claro de entrada** para registrar, gestionar y dar seguimiento a **cualquier evento, movimiento o novedad** asociado a una **marea**.

La intención principal es que:

*   Toda actividad relevante sobre una marea sea **descubrible** y **accionable** desde un único lugar.
    
*   La UI evite la fragmentación (“¿dónde se hace esto?”).
    
*   Las diferencias entre roles se resuelvan por **permisos, visibilidad y acciones disponibles**, no por multiplicación de pantallas.
    

## Principios de diseño

### 1) Una sola vista conceptual

Debe existir **una única pantalla** de bandeja (Inbox) con:

*   filtros/pestañas preconfiguradas por rol
    
*   distintas acciones disponibles según permisos
    

Esto reduce el costo cognitivo: el usuario aprende **un solo lugar** para “lo que hay que hacer” y para “registrar algo”.

### 2) Separar “historial” de “pendientes”

La bandeja no es un chat ni un log. Es una lista de **ítems accionables**.

Se recomienda separar dos conceptos:

*   **Event Log (inmutable)**: “qué pasó” (auditoría)
    
*   **Work Items (accionables)**: “qué hay que atender / hacer” (con ciclo de vida)
    

### 3) El backend decide reglas y acciones

El frontend **no debe inferir** lógica de negocio sobre estados y transiciones.

El backend debe calcular:

*   **acciones habilitadas** para un ítem o una marea
    
*   motivos de bloqueo
    
*   próximos estados permitidos (si aplica)
    

Así el front solo renderiza y ejecuta.

### 4) Centralización real: todo debe poder iniciarse desde la bandeja

Regla práctica:

> “Si algo implica registrar un movimiento o cambio relevante, debe poder iniciarse desde la bandeja.”

Esto implica:

*   Un botón global para **Registrar evento**
    
*   Un buscador para **Ir a marea**
    
*   Desde cualquier pantalla de marea, una acción **Enviar a bandeja** (crear ítem manual)
    

## Concepto: Inbox de ítems accionables

La bandeja mostrará **ítems** asociados a una marea, cada uno representando:

*   una **acción pendiente**
    
*   una **solicitud**
    
*   una **alerta/regla**
    
*   una **novedad**
    
*   un **mensaje/comentario** (si se incluye)
    

### Tipos de ítems (categorías)

1.  **Acciones pendientes**
    
    *   Ej.: “Registrar zarpada”, “Registrar arribo”, “Completar etapa”, “Generar informe”, “Resolver inconsistencia”, etc.
        
2.  **Solicitudes**
    
    *   Ej.: “Piden corrección”, “Solicitan desbloqueo”, “Requiere aprobación”, “Requiere revisión”, etc.
        
3.  **Alertas / Reglas**
    
    *   Ítems generados por validaciones automáticas.
        
    *   Ej.: “Arribo sin zarpada”, “Estado incompatible con datos cargados”, “Duración anómala”, etc.
        
4.  **Novedades**
    
    *   Ítems informativos o que requieren confirmación.
        
    *   Ej.: “Se editó la zarpada”, “Se cambió el buque”, “Se adjuntó documento”, etc.
        
5.  **Mensajes / Comentarios (opcional)**
    
    *   Notas internas asociadas a la marea o a un ítem.
        

## Modelo de datos recomendado

### A) Event Log (auditoría)

Registro **inmutable** y ordenado de eventos sobre una marea.

Ejemplos de eventos:

*   creación de marea
    
*   registro/edición de zarpada
    
*   registro/edición de arribo
    
*   cambio de estado
    
*   validación ejecutada
    
*   informe generado
    
*   bloqueo/desbloqueo
    
*   adjunto agregado
    
*   comentario agregado
    

Atributos típicos:

*   `id`
    
*   `mareaId`
    
*   `eventType`
    
*   `payload` (JSON con datos del evento)
    
*   `createdAt`
    
*   `createdBy` (usuario)
    
*   `origin` (UI, importación, sistema, etc.)
    

### B) Work Items (Inbox Items)

Ítems con ciclo de vida que representan “algo que se debe atender”.

Atributos recomendados:

*   `id`
    
*   `mareaId`
    
*   `type` (tipo/categoría)
    
*   `title` / `summary`
    
*   `severity` / `priority` (alta/media/baja)
    
*   `status` (abierto / en\_progreso / resuelto / descartado)
    
*   `createdAt`
    
*   `createdBy`
    
*   `assignedTo` (opcional)
    
*   `dueAt` (opcional)
    
*   `actionsAvailable[]` (derivado, no persistente, calculado por backend)
    
*   `metadata` (JSON: tags, referencias, etc.)
    

**Nota:** el ítem debe permitir trazabilidad de “quién lo tomó”, “quién lo resolvió”, y opcionalmente comentarios.

## Variantes por rol (misma pantalla, distinto contenido)

La diferencia por rol se expresa en:

*   **Visibilidad** de tipos de ítems
    
*   **Acciones permitidas** sobre ítems y mareas
    
*   **Filtros por defecto** / vistas guardadas
    

Ejemplo conceptual (ajustable al modelo final):

*   **Observador**
    
    *   ve: pendientes de carga, alertas de consistencia, solicitudes de aclaración
        
    *   acciones: registrar eventos de campo (zarpada/arribo/etapas), corregir datos propios
        
*   **Coordinación / Administración**
    
    *   ve: solicitudes, aprobaciones, desbloqueos, estados críticos
        
    *   acciones: bloquear/desbloquear, aprobar cambios, validar y avanzar estados
        
*   **Analista**
    
    *   ve: validaciones, calidad de datos, cierre del proceso
        
    *   acciones: correr validaciones, generar informe, cerrar marea
        

La UI puede mostrar pestañas tipo:

*   “Pendientes”
    
*   “Mis asignaciones”
    
*   “Alertas”
    
*   “Solicitudes”
    
*   “Todo”
    

Estas pestañas son **filtros guardados**.

## UX recomendado de la Bandeja

### Layout

*   **Tabla/listado** central con filtros
    
*   Panel lateral de detalle del ítem (sin navegar a otra pantalla)
    
*   Acciones rápidas por fila (según permisos)
    

### Contenido por ítem

Cada ítem debería mostrar claramente:

*   Marea (buque + nro/código)
    
*   Tipo de ítem (badge)
    
*   Severidad/prioridad
    
*   Estado del ítem
    
*   Última actualización
    
*   Responsable/asignado
    
*   Acciones directas (botones)
    

### Acciones globales (entry point)

La bandeja debe incluir:

1.  **Registrar evento**
    

*   Abre selector de tipo de evento
    
*   Luego selección de marea (si no viene preseleccionada)
    
*   Luego formulario
    

1.  **Buscar marea**
    

*   Búsqueda rápida por buque/nro/fecha
    
*   Permite abrir detalle de marea y/o crear ítem asociado
    

### Desde la pantalla de Marea

Siempre debe existir:

*   **Enviar a bandeja**: crear ítem manual (tarea/solicitud/nota)
    
*   **Ver pendientes**: listar ítems filtrados por esa marea
    

## Generación automática de ítems (reglas)

Los Work Items deben poder generarse:

1.  **Automáticamente** por reglas
    

*   Ej.: al registrar arribo ⇒ crear “Generar informe”
    
*   Ej.: al detectar inconsistencia ⇒ crear “Resolver inconsistencia”
    
*   Ej.: al bloquear marea ⇒ crear “Revisar bloqueo”
    

1.  **Manualmente** por usuarios
    

*   Ej.: “Solicitar desbloqueo”
    
*   Ej.: “Pedir aclaración al observador”
    

Las reglas automáticas deben estar en backend, idealmente:

*   como parte de una capa de dominio/servicio de workflow
    
*   con trazabilidad en Event Log
    

## Acciones disponibles: contrato claro para el frontend

Para cada ítem o marea, el backend debe devolver un listado de acciones posibles.

Ejemplo de acción:

*   `key`: `register_arribo`
    
*   `label`: “Registrar arribo”
    
*   `enabled`: true/false
    
*   `blockedReason`: string opcional
    

Esto permite que la UI:

*   muestre solo lo que corresponde
    
*   explique por qué algo está bloqueado
    
*   no replique lógica de estados
    

## API sugerida (endpoints a prever)

### 1) Bandeja

**GET** `/inbox/items`

*   Filtros:
    
    *   `status[]`, `type[]`, `severity[]`
        
    *   `assignedToMe=true|false`
        
    *   `mareaId`
        
    *   `buqueId`
        
    *   `q` (búsqueda)
        
    *   `page`, `pageSize`, `sort`
        

**GET** `/inbox/items/{id}`

*   Detalle del ítem + `actionsAvailable[]`
    

**POST** `/inbox/items`

*   Crear ítem manual
    

**POST** `/inbox/items/{id}/claim`

*   Tomar/autoasignar
    

**POST** `/inbox/items/{id}/release`

*   Soltar/desasignar
    

**POST** `/inbox/items/{id}/resolve`

*   Marcar como resuelto
    

**POST** `/inbox/items/{id}/dismiss`

*   Descartar/ignorar (si el negocio lo permite)
    

**POST** `/inbox/items/{id}/comment` (opcional)

*   Comentar sobre el ítem
    

### 2) Registro de eventos sobre Marea (entry point operativo)

**POST** `/mareas/{id}/events`

*   `eventType` + `payload`
    
*   El backend:
    
    *   valida reglas
        
    *   actualiza datos/estado si corresponde
        
    *   registra en Event Log
        
    *   genera Work Items automáticos si aplica
        

**GET** `/mareas/{id}/timeline`

*   Devuelve Event Log resumido para UI
    

### 3) Acciones disponibles

**GET** `/mareas/{id}/actions`

*   Devuelve acciones posibles sobre la marea
    

**GET** `/inbox/items/{id}/actions`

*   (si se separa) acciones posibles sobre el ítem
    

### 4) Notificaciones en tiempo real (opcional)

*   SSE/WebSocket: `/inbox/stream`
    
    *   eventos: `item_created`, `item_updated`, `marea_event_created`, etc.
        

## Comportamiento esperado (escenarios)

### Escenario A: Registrar arribo

1.  Usuario abre bandeja
    
2.  Ve ítem: “Registrar arribo” para Marea X
    
3.  Abre detalle, ejecuta acción
    
4.  Backend registra evento + actualiza estado
    
5.  Backend genera automáticamente ítem: “Generar informe” (según reglas)
    

### Escenario B: Inconsistencia detectada

1.  Se corre una validación
    
2.  Backend detecta regla violada
    
3.  Registra evento `validation_failed`
    
4.  Crea Work Item “Resolver inconsistencia” con severidad Alta
    
5.  Aparece en bandeja para rol correspondiente
    

### Escenario C: Solicitud manual

1.  Coordinación crea ítem “Pedir aclaración” para el observador
    
2.  Observador lo ve en su bandeja
    
3.  Responde/corrige y resuelve el ítem
    
4.  Queda trazabilidad completa (ítem + log)
    

## Recomendaciones finales

*   Mantener la bandeja como **centro de operaciones**, no como historial.
    
*   Mantener Event Log separado para auditoría y reconstrucción.
    
*   Evitar lógica de negocio en el frontend: el backend debe devolver **acciones habilitadas** y motivos de bloqueo.
    
*   Diseñar la bandeja como un componente transversal: global y filtrable por marea.
    

## Pendientes para la implementación

Para cerrar el diseño antes de codificar:

1.  Definir la lista final de **roles** y permisos
    
2.  Definir la lista final de **estados** y transiciones
    
3.  Definir el catálogo de `eventType` (Event Log)
    
4.  Definir el catálogo de `workItemType` (Inbox Items)
    
5.  Especificar reglas automáticas: “si pasa X ⇒ crear ítem Y”
    
6.  Definir criterios de severidad/prioridad y SLA (si aplica)