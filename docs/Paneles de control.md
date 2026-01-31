# Panel operativo y vistas de control de Mareas

## Objetivo general

Definir el conjunto de **vistas de control y monitoreo** del sistema de mareas, separando claramente:

*   **Operación diaria** (qué está pasando ahora y qué requiere atención)
    
*   **Seguimiento del proceso** (estados, flujos, cuellos de botella)
    
*   **Análisis y estadísticas** (cómo viene el año, carga de trabajo, desempeño)
    

El diseño se apoya en tres vistas principales, con responsabilidades bien delimitadas:

1.  **Panel operativo** (dashboard operativo)
    
2.  **Vista Kanban de estados** (flujo completo)
    
3.  **Vista estadística anual** (análisis agregado)
    

Cada vista responde a una pregunta distinta y evita superposiciones innecesarias.

## 1) Panel operativo (dashboard operativo)

### Propósito

El panel operativo es la **vista principal del sistema**.

Su objetivo es ofrecer, de un vistazo, una **imagen clara y accionable** de la situación actual de las mareas **antes del informe**, es decir, aquellas que aún están:

*   previstas (designadas)
    
*   en curso
    
*   en carga
    
*   en revisión
    
*   o presentan problemas que requieren intervención
    

No es una vista histórica ni de auditoría. Es una vista **operativa**.

### Alcance funcional

El panel **solo incluye mareas relevantes para la gestión operativa**, es decir:

*   Mareas **anteriores a la generación del informe**
    
*   Mareas **bloqueadas** o con alertas críticas, aunque estén cerca de finalizar
    

Una vez que el informe fue generado, la marea **deja de aparecer** en este panel y pasa a formar parte de las vistas de control/seguimiento.

Este criterio debe resolverse en backend mediante una condición clara (por ejemplo: `informe_generado_at IS NULL`).

### Estados considerados

El panel no muestra todos los estados posibles del workflow, sino solo los **estados relevantes para la operación**, por ejemplo:

*   Designada
    
*   Navegando (estado derivado: zarpada registrada y sin arribo)
    
*   Arribada / en carga (si corresponde)
    
*   En revisión previa al informe
    
*   Bloqueada
    

Estados posteriores al informe (informada, cerrada, archivada, etc.) **no se muestran** aquí.

### Componentes del panel

#### A) KPIs superiores (visión instantánea)

Tarjetas de lectura rápida, orientadas a gestión:

*   Cantidad de mareas navegando
    
*   Cantidad de mareas designadas
    
*   Cantidad de mareas en revisión
    
*   Cantidad de mareas bloqueadas
    
*   Total de alertas activas
    
*   Última actualización / sincronización (si aplica)
    

Estos valores deben ser calculados por backend y devueltos como parte de un endpoint agregado.

#### B) Tabla central tipo “vuelos”

Elemento principal del panel. Cada fila representa una marea.

Columnas recomendadas:

*   Buque
    
*   Identificador de marea
    
*   Estado operativo
    
*   Fecha/hora de zarpada
    
*   Fecha/hora de arribo (si existe)
    
*   Indicador de progreso (etapas, lances, capturas, según modelo)
    
*   Último movimiento (fecha + usuario)
    
*   Indicadores visuales (alertas, bloqueos, pendientes)
    
*   Acciones rápidas (abrir marea, ir a bandeja, resolver)
    

Orden y filtros deben priorizar **lo urgente** y **lo problemático**.

#### C) Filtros operativos

Filtros pensados para uso diario:

*   Estado operativo (multi-select)
    
*   Buque
    
*   Con alertas / sin alertas
    
*   Rango de fechas (zarpada / arribo)
    
*   Búsqueda textual (buque, marea, observador)
    

#### D) Panel lateral de contexto

Al seleccionar una marea:

*   Ficha resumida (buque, observador, fechas clave, estado)
    
*   Timeline resumido de eventos
    
*   Lista de alertas activas
    
*   Acceso directo a la bandeja filtrada por esa marea
    

Este panel evita navegar a múltiples pantallas para entender la situación.

### Comportamiento esperado

*   El panel debe cargar rápido y con **pocos requests** (idealmente uno solo).
    
*   El backend debe devolver datos ya calculados:
    
    *   estado operativo
        
    *   flags derivados (navegando, con alertas, bloqueada)
        
    *   acciones disponibles
        
*   El frontend no interpreta reglas de negocio.
    

### Endpoint conceptual asociado

*   **GET** `/dashboard/mareas?scope=operativo`
    
    *   Devuelve:
        
        *   KPIs
            
        *   listado paginado de mareas
            
        *   contadores y flags derivados
            

## 2) Vista Kanban de estados

### Propósito

La vista Kanban permite visualizar el **flujo completo de las mareas** a lo largo de **todos los estados del workflow**, incluyendo estados posteriores al informe.

Es una vista de:

*   seguimiento
    
*   control de proceso
    
*   análisis de cuellos de botella
    

No es la vista principal del día a día.

### Alcance

Incluye:

*   Todas las mareas (activas y finalizadas)
    
*   Todos los estados definidos en el workflow
    

Permite observar:

*   acumulaciones por estado
    
*   transiciones frecuentes
    
*   tiempos de permanencia
    

### Diseño funcional

*   Columnas = estados del workflow
    
*   Tarjetas = mareas
    
*   Información mínima por tarjeta:
    
    *   buque
        
    *   identificador de marea
        
    *   fechas clave
        
    *   indicadores (alertas, bloqueos)
        

Las acciones de cambio de estado deben respetar:

*   permisos por rol
    
*   transiciones válidas
    

El backend debe validar cualquier cambio.

### Interacciones posibles

*   Navegar a detalle de marea
    
*   Ejecutar acciones permitidas (si se habilita)
    
*   Filtrar por:
    
    *   buque
        
    *   año
        
    *   pesquería
        
    *   observador
        

### Endpoint conceptual asociado

*   **GET** `/mareas/kanban`
    
    *   Devuelve columnas con sus mareas, o dataset agrupado por estado
        

## 3) Vista estadística anual

### Propósito

Proveer una visión **analítica y agregada** del desempeño del sistema en el año en curso (y eventualmente años anteriores).

Esta vista responde a la pregunta:

> “¿Cómo venimos?”

### Métricas principales

#### Actividad general

*   Total de mareas realizadas
    
*   Días totales navegados
    
*   Promedio de días por marea
    
*   Mareas por mes
    

#### Distribución y estados

*   % de mareas cerradas correctamente
    
*   % desestimadas
    
*   % bloqueadas
    
*   Tiempos promedio entre hitos (zarpada → arribo → informe)
    

#### Observadores

*   Mareas por observador
    
*   Días navegados por observador
    
*   Promedio de duración por marea
    

#### Buques

*   Mareas por buque
    
*   Días navegados por buque
    
*   Duración promedio
    

#### Pesquerías

*   Mareas por pesquería
    
*   Días navegados por pesquería
    
*   Evolución mensual
    

#### Calidad de datos

*   % de mareas con alertas
    
*   Promedio de alertas por marea
    
*   Tiempo promedio de resolución de bloqueos
    

### Agrupaciones soportadas

Las métricas deben poder agruparse por:

*   Año / mes
    
*   Pesquería
    
*   Observador
    
*   Buque
    
*   Estado final
    

Las combinaciones deben resolverse en backend.

### Visualizaciones esperadas

*   KPIs anuales
    
*   Gráficos de barras (distribuciones)
    
*   Gráficos de líneas (evolución temporal)
    
*   Comparaciones simples (mes actual vs promedio)
    

### Endpoint conceptual asociado

*   **GET** `/stats/mareas`
    
    *   Parámetros:
        
        *   `year`
            
        *   `groupBy`
            
        *   `metrics`
            
*   **GET** `/stats/kpis`
    

## Relación entre las vistas

<figure class="table op-uc-figure_align-center op-uc-figure"><table class="op-uc-table"><thead class="op-uc-table--head"><tr class="op-uc-table--row"><th class="op-uc-table--cell op-uc-table--cell_head"><p class="op-uc-p">Vista</p></th><th class="op-uc-table--cell op-uc-table--cell_head"><p class="op-uc-p">Pregunta que responde</p></th><th class="op-uc-table--cell op-uc-table--cell_head"><p class="op-uc-p">Enfoque</p></th></tr></thead><tbody><tr class="op-uc-table--row"><td class="op-uc-table--cell"><p class="op-uc-p">Panel operativo</p></td><td class="op-uc-table--cell"><p class="op-uc-p">¿Qué está pasando ahora?</p></td><td class="op-uc-table--cell"><p class="op-uc-p">Operativo</p></td></tr><tr class="op-uc-table--row"><td class="op-uc-table--cell"><p class="op-uc-p">Bandeja (Inbox)</p></td><td class="op-uc-table--cell"><p class="op-uc-p">¿Qué hay que hacer?</p></td><td class="op-uc-table--cell"><p class="op-uc-p">Accionable</p></td></tr><tr class="op-uc-table--row"><td class="op-uc-table--cell"><p class="op-uc-p">Kanban</p></td><td class="op-uc-table--cell"><p class="op-uc-p">¿Cómo fluye el proceso?</p></td><td class="op-uc-table--cell"><p class="op-uc-p">Proceso</p></td></tr><tr class="op-uc-table--row"><td class="op-uc-table--cell"><p class="op-uc-p">Estadísticas</p></td><td class="op-uc-table--cell"><p class="op-uc-p">¿Cómo venimos?</p></td><td class="op-uc-table--cell"><p class="op-uc-p">Analítico</p></td></tr></tbody></table></figure>

Cada vista tiene un propósito claro y no se superpone funcionalmente con las otras.

## Decisiones clave de diseño

*   El **panel operativo** es la pantalla principal
    
*   Las mareas post-informe salen del panel operativo
    
*   El backend define:
    
    *   estados operativos
        
    *   flags derivados
        
    *   acciones disponibles
        
*   El frontend se mantiene declarativo
    

## Pendientes para cerrar diseño

1.  Definir lista final de estados del workflow
    
2.  Definir criterio exacto de “post-informe”
    
3.  Definir KPIs finales del panel operativo
    
4.  Definir qué acciones rápidas se exponen en cada vista
    
5.  Definir políticas de actualización en tiempo real (si aplica)