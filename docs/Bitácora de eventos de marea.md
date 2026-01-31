## **Modelo consolidado de eventos, alertas y ejecución**

Este documento describe el **conjunto completo de eventos** que se registran durante todo el ciclo de vida de una marea, desde la **designación del observador** hasta la **protocolización**, incluyendo la **ejecución operativa**, la gestión de fechas, las alertas externas y el cálculo de indicadores derivados.

El objetivo del modelo es:

*   separar claramente **estados**, **eventos**, **datos operativos** y **alertas**;
    
*   permitir trazabilidad clara sin convertir la bitácora en la fuente de verdad;
    
*   facilitar la implementación incremental durante el desarrollo.
    

## 1\. Principios generales

### 1.1 Qué es un evento

Un **evento** representa un **hecho relevante confirmado** dentro del ciclo de vida de una marea.

Un evento:

*   ocurre en un momento determinado,
    
*   puede tener impacto administrativo u operativo,
    
*   **no es necesariamente la fuente de verdad del dato**, sino su registro histórico.
    

### 1.2 Qué NO es un evento

No son eventos:

*   los estados actuales (eso vive en `mareas.id_estado_actual`);
    
*   las señales externas automáticas (alertas), hasta que alguien decide qué hacer con ellas;
    
*   los datos operativos en sí mismos (etapas, fechas vigentes, trayectorias).
    

## 2\. Relación entre estados, eventos, alertas y datos

<figure class="table op-uc-figure_align-center op-uc-figure"><table class="op-uc-table"><thead class="op-uc-table--head"><tr class="op-uc-table--row"><th class="op-uc-table--cell op-uc-table--cell_head"><p class="op-uc-p">Concepto</p></th><th class="op-uc-table--cell op-uc-table--cell_head"><p class="op-uc-p">Rol</p></th></tr></thead><tbody><tr class="op-uc-table--row"><td class="op-uc-table--cell"><p class="op-uc-p"><strong>Estado</strong></p></td><td class="op-uc-table--cell"><p class="op-uc-p">Situación actual de la marea</p></td></tr><tr class="op-uc-table--row"><td class="op-uc-table--cell"><p class="op-uc-p"><strong>Evento</strong></p></td><td class="op-uc-table--cell"><p class="op-uc-p">Hecho confirmado / decisión tomada</p></td></tr><tr class="op-uc-table--row"><td class="op-uc-table--cell"><p class="op-uc-p"><strong>Alerta</strong></p></td><td class="op-uc-table--cell"><p class="op-uc-p">Señal externa no confirmada</p></td></tr><tr class="op-uc-table--row"><td class="op-uc-table--cell"><p class="op-uc-p"><strong>Dato operativo</strong></p></td><td class="op-uc-table--cell"><p class="op-uc-p">Fuente de verdad (fechas, etapas, trayectoria)</p></td></tr></tbody></table></figure>

Regla central del diseño:

> **Los eventos cuentan la historia.**  
> **Los datos operativos representan la realidad vigente.**

## 3\. Eventos por etapa del ciclo de vida

### A. Designación y planificación

Eventos que ocurren **antes de la ejecución** de la marea.

*   `**DESIGNACION_OBSERVADOR**`  
    Se crea la designación del observador para la marea.
    
*   `**ACTUALIZACION_FECHA_ESTIMADA_ZARPADA**`  
    Se modifica la fecha estimada de zarpada (`mareas.fecha_zarpada_estimada`).
    

Estos eventos:

*   no crean etapas,
    
*   no implican navegación,
    
*   suelen ocurrir con la marea en estado inicial.
    

### B. Inicio y fin del observador (fechas globales)

Eventos vinculados a las **fechas marco del observador**, que se almacenan como propiedades de la marea.

*   `**REGISTRO_INICIO_OBSERVADOR**`  
    Se fija o confirma `fecha_inicio_observador`.
    
*   `**REGISTRO_FIN_OBSERVADOR**`  
    Se fija o confirma `fecha_fin_observador`.
    

Correcciones posteriores:

*   se registran como `NOTA_ADMINISTRATIVA` o `NOTA_TECNICA` con metadata  
    (`campo`, `valor_anterior`, `valor_nuevo`).
    

### C. Alertas externas (señales)

Las alertas **no son eventos operativos**, sino señales externas que requieren validación humana.

Las alertas se registran en una tabla específica (ej. `mareas_alertas`) y pueden ser:

*   `POSIBLE_ZARPADA`
    
*   `POSIBLE_ARRIBO`
    

**No generan eventos automáticamente.**

### D. Resolución de alertas (decisión humana)

Cuando una alerta se resuelve, **sí se registra un evento**, porque hay una decisión confirmada.

*   `**CONFIRMACION_ZARPADA**`  
    El operador confirma una alerta de zarpada.  
    Acción asociada:
    
    *   se crea una nueva etapa de navegación.
        
*   `**CONFIRMACION_ARRIBO**`  
    El operador confirma una alerta de arribo.  
    Acción asociada:
    
    *   se completa (cierra) la etapa abierta.
        
*   `**ALERTA_DESCARTADA**`  
    Se decide que la señal no aplica.
    

Estos eventos deben registrar en metadata:

*   `alerta_id`
    
*   `etapa_id` (si aplica)
    
*   `fecha_confirmada`
    
*   observaciones si hubo conflicto o ambigüedad
    

### E. Gestión manual de etapas

Eventos para casos donde:

*   no hay alertas externas,
    
*   o se requiere intervención directa.
    
*   `**CREACION_ETAPA_MANUAL**`  
    Se crea una etapa sin alerta previa.
    
*   `**CIERRE_ETAPA_MANUAL**`  
    Se cierra una etapa manualmente.
    
*   `**CORRECCION_ETAPA**`  
    Se modifican datos de una etapa existente (fechas, puertos).
    

Las **etapas** siguen siendo la fuente de verdad; el evento documenta la acción.

### F. Flujo de estados

Eventos que documentan transiciones de estado.

*   `**CAMBIO_ESTADO**`  
    Registra cualquier transición de estado de la marea.
    

El detalle del cambio se expresa mediante:

*   `id_estado_desde`
    
*   `id_estado_hasta`
    

### G. Recepción y manejo de datos

Eventos que registran **ingreso de información**.

*   `**RECEPCION_DATOS_ORIGINALES**`
    
*   `**RECEPCION_DATOS_EXTERNOS**`
    
*   `**CARGA_DATOS_CORREGIDOS**`
    

### H. Corrección y responsables

Eventos administrativos vinculados a la corrección.

*   `**APERTURA_CORRECCION**`
    
*   `**CIERRE_CORRECCION**`
    
*   `**ASIGNACION_RESPONSABLE**`
    
*   `**CAMBIO_RESPONSABLE**`
    

### I. Documentación física y materiales

*   `**ESCANEO_CARPETA**`
    
*   `**ENTREGA_OTOLITOS**`
    
*   `**OTROS_MATERIALES_FISICOS**`
    

### J. Trayectoria y Zona Austral

Eventos vinculados al seguimiento satelital y cálculos derivados.

*   `**IMPORTACION_TRAYECTORIA**`  
    Se importa una trayectoria satelital (replace-all).
    
*   `**RECALCULO_ZONA_AUSTRAL**`  
    Se recalcula y actualiza `mareas.dias_zona_austral`.
    

Metadata típica:

*   cantidad de puntos
    
*   rango temporal
    
*   días antes / después
    
*   id de la trayectoria utilizada
    

### K. Informe y protocolización

*   `**INFORME_GENERADO**`
    
*   `**INFORME_REVISADO**`
    
*   `**INFORME_APROBADO**`
    
*   `**PROTOCOLIZACION_INICIADA**`
    
*   `**PROTOCOLIZACION_COMPLETADA**`
    

### L. Notas generales

*   `**NOTA_ADMINISTRATIVA**`
    
*   `**NOTA_TECNICA**`
    
*   `**CONTACTO_CON_OBSERVADOR**`
    
*   `**CONTACTO_CON_BUQUE_EMPRESA**`
    
*   `**DELEGACION_EXTERNA**`
    
*   `**RETORNO_DELEGACION**`
    
*   `**OTRO**`
    

## 4\. Catálogo consolidado de `tipo_evento`

```text
DESIGNACION_OBSERVADOR
ACTUALIZACION_FECHA_ESTIMADA_ZARPADA
REGISTRO_INICIO_OBSERVADOR
REGISTRO_FIN_OBSERVADOR

CONFIRMACION_ZARPADA
CONFIRMACION_ARRIBO
ALERTA_DESCARTADA

CREACION_ETAPA_MANUAL
CIERRE_ETAPA_MANUAL
CORRECCION_ETAPA

CAMBIO_ESTADO

RECEPCION_DATOS_ORIGINALES
RECEPCION_DATOS_EXTERNOS
CARGA_DATOS_CORREGIDOS

APERTURA_CORRECCION
CIERRE_CORRECCION
ASIGNACION_RESPONSABLE
CAMBIO_RESPONSABLE

ESCANEO_CARPETA
ENTREGA_OTOLITOS
OTROS_MATERIALES_FISICOS

IMPORTACION_TRAYECTORIA
RECALCULO_ZONA_AUSTRAL

INFORME_GENERADO
INFORME_REVISADO
INFORME_APROBADO
PROTOCOLIZACION_INICIADA
PROTOCOLIZACION_COMPLETADA

NOTA_ADMINISTRATIVA
NOTA_TECNICA
CONTACTO_CON_OBSERVADOR
CONTACTO_CON_BUQUE_EMPRESA
DELEGACION_EXTERNA
RETORNO_DELEGACION
OTRO
```

## 5\. Regla final para la implementación

> **Los eventos no crean realidad por sí solos.**  
> **Documentan decisiones y hechos confirmados.**  
> **La realidad operativa vive en las tablas de marea, etapas y trayectorias.**

Con esta documentación:

*   el backend puede validar qué acciones generan eventos,
    
*   el frontend puede mostrar una línea de tiempo coherente,
    
*   y el modelo se mantiene estable aunque la operatoria evolucione.
    

Si querés, el siguiente paso puede ser **mapear eventos → acciones de dominio** (qué cambia en la DB cuando ocurre cada uno), que ya es casi escribir el backend en castellano.