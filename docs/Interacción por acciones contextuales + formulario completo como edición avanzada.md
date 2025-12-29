## Contexto

Las mareas pueden ser cargadas y actualizadas en **distintos momentos de su ciclo de vida**:

*   al momento de la designación,
    
*   durante la ejecución,
    
*   al finalizar el trabajo del observador,
    
*   durante la etapa de corrección, informes y protocolización.
    

En la práctica operativa:

*   la información **no llega toda junta**,
    
*   muchas actualizaciones son **puntuales y frecuentes**,
    
*   y obligar al usuario a reabrir siempre el formulario completo genera fricción, errores y lentitud.
    

## Problema a resolver

Diseñar una interfaz que permita:

*   cargar rápidamente información disponible en cualquier punto del ciclo,
    
*   registrar hechos operativos en pocos segundos,
    
*   evitar que el usuario deba “entender el modelo interno” del sistema,
    
*   y mantener consistencia de datos y eventos.
    

## Decisión adoptada

👉 **Se adopta un modelo de interacción en dos niveles:**

1.  **Formulario completo de marea**  
    Para creación inicial, edición global y revisión.
    
2.  **Acciones contextuales y específicas**  
    Para el uso diario operativo.
    

## Principio rector de usabilidad

> **El formulario completo sirve para editar.**  
> **Las acciones rápidas sirven para operar.**

El usuario **no debe entrar al formulario completo** para registrar hechos simples y frecuentes.

## Nivel 1 — Formulario completo de marea

### Rol

*   Crear una nueva marea.
    
*   Cargar toda la información disponible de una sola vez.
    
*   Revisar y corregir datos globales.
    

### Características

*   Acceso explícito mediante acción “Editar marea”.
    
*   Incluye todos los campos:
    
    *   identificación,
        
    *   fechas,
        
    *   descripción,
        
    *   observador,
        
    *   etapas,
        
    *   etc.
        
*   Puede presentarse como:
    
    *   panel lateral,
        
    *   o pantalla dedicada.
        

### Uso esperado

*   menos frecuente,
    
*   más reflexivo,
    
*   no orientado a la operación diaria.
    

## Nivel 2 — Acciones contextuales (uso diario)

### Rol

*   Registrar hechos concretos a medida que ocurren.
    
*   Avanzar la marea en su ciclo de vida.
    
*   Reaccionar rápidamente ante alertas o novedades.
    

### Características

*   Botones visibles en la vista principal de la marea.
    
*   **Contextuales al estado y a los datos existentes**.
    
*   Cada acción:
    
    *   solicita solo la información mínima necesaria,
        
    *   se resuelve en un modal pequeño o diálogo simple,
        
    *   dispara automáticamente eventos y cambios de estado.
        

## Ejemplos de acciones contextuales

### Según el estado / situación de la marea

*   **Registrar inicio del observador**
    
*   **Registrar fin del observador**
    
*   **Crear etapa**
    
*   **Cerrar etapa**
    
*   **Confirmar alerta de zarpada / arribo**
    
*   **Importar trayectoria**
    
*   **Recalcular zona austral**
    
*   **Agregar nota**
    
*   **Cambiar estado**
    
*   **Cargar datos / informes**
    

En todos los casos:

*   el usuario **no elige tipos de evento**,
    
*   no navega a un formulario grande,
    
*   registra el hecho en pocos segundos.
    

## Regla de diseño clave

> **Todo dato que tenga una acción específica NO debe requerir edición en el formulario completo.**

Ejemplos:

*   Inicio / fin del observador → acción dedicada.
    
*   Zarpadas / arribos → acciones sobre etapas.
    
*   Importación de trayectoria → acción dedicada.
    
*   Confirmación de alertas → acción dedicada.
    

El formulario completo queda como **respaldo**, no como flujo principal.

## Relación con el modelo de eventos

Esta decisión se alinea con la gestión automática de eventos:

*   Las acciones del usuario disparan **eventos internos automáticos**.
    
*   El usuario no interactúa con el concepto de evento.
    
*   La bitácora se construye como consecuencia de las acciones.
    

## Beneficios esperados

### Usabilidad

*   Menos clicks.
    
*   Menos pantallas.
    
*   Menos errores.
    

### Aprendizaje

*   El sistema se entiende por uso, no por capacitación.
    
*   El usuario “hace lo que pasó”, no “piensa cómo cargarlo”.
    

### Robustez del modelo

*   Eventos coherentes.
    
*   Estados consistentes.
    
*   Menor riesgo de datos incompletos o mal cargados.
    

### Escalabilidad

*   Nuevas acciones pueden agregarse sin tocar el formulario principal.
    
*   El sistema crece sin volverse complejo para el usuario.
    

## Regla final para diseño de UI

> **La vista principal de la marea debe ofrecer siempre**  
> **las acciones correctas para el momento correcto.**

El usuario no debería preguntarse:

*   “¿Dónde cargo esto?”
    
*   “¿Tengo que editar todo de nuevo?”
    

El sistema debe **guiar la operación**, no delegarla.  
  
  

# Acciones contextuales por estado de marea

**Guía de diseño de UI y comportamiento**

Aquí se define **qué acciones debe ofrecer la interfaz** según el estado y la situación de la marea, siguiendo el principio:

> **El usuario ve solo lo que tiene sentido hacer en ese momento.**

Las acciones:

*   son explícitas,
    
*   piden pocos datos,
    
*   generan automáticamente los eventos correspondientes,
    
*   y evitan el uso permanente del formulario completo.
    

## Convenciones

*   🟢 Acción principal (flujo normal)
    
*   🟡 Acción secundaria / opcional
    
*   🔴 Acción restringida (solo roles especiales)
    
*   ✏️ Acceso al formulario completo (edición avanzada)
    

## 1\. Estado: DESIGNADA

La marea existe, el observador está designado, pero **aún no inició su trabajo**.

### Acciones disponibles

*   🟢 **Registrar inicio del observador**  
    → Pide: fecha de inicio  
    → Evento: `REGISTRO_INICIO_OBSERVADOR`  
    → Puede disparar cambio de estado
    
*   🟡 **Actualizar fecha estimada de zarpada**  
    → Pide: nueva fecha  
    → Evento: `ACTUALIZACION_FECHA_ESTIMADA_ZARPADA`
    
*   🟡 **Agregar nota**  
    → Evento: `NOTA_ADMINISTRATIVA` / `NOTA_TECNICA`
    
*   ✏️ **Editar marea**  
    → Formulario completo
    

## 2\. Estado: EN EJECUCIÓN

(o equivalente: iniciada / navegando)

El observador inició su trabajo. Puede haber o no etapas registradas.

### Acciones disponibles

*   🟢 **Confirmar alerta de zarpada** _(si hay alertas pendientes)_  
    → Evento: `CONFIRMACION_ZARPADA`  
    → Acción: crea nueva etapa
    
*   🟢 **Crear etapa manual**  
    → Evento: `CREACION_ETAPA_MANUAL`
    
*   🟢 **Cerrar etapa** _(si hay etapa abierta)_  
    → Pide: fecha de arribo, puerto  
    → Evento: `CONFIRMACION_ARRIBO` o `CIERRE_ETAPA_MANUAL`
    
*   🟡 **Ver / resolver alertas**  
    → Acciones: confirmar / descartar  
    → Eventos: `CONFIRMACION_*` / `ALERTA_DESCARTADA`
    
*   🟡 **Agregar nota**  
    → Evento: `NOTA_*`
    
*   ✏️ **Editar marea**  
    → Formulario completo (con validaciones)
    

## 3\. Estado: FINALIZADA

(el observador ya terminó su trabajo)

### Acciones disponibles

*   🟢 **Registrar fin del observador** _(si no está cargado)_  
    → Pide: fecha de fin  
    → Evento: `REGISTRO_FIN_OBSERVADOR`
    
*   🟢 **Importar trayectoria**  
    → Acción técnica  
    → Eventos: `IMPORTACION_TRAYECTORIA` + `RECALCULO_ZONA_AUSTRAL`
    
*   🟡 **Recalcular zona austral** _(si ya hay trayectoria)_  
    → Evento: `RECALCULO_ZONA_AUSTRAL`
    
*   🟡 **Cargar datos / archivos**  
    → Evento: `RECEPCION_DATOS_*` / `CARGA_DATOS_CORREGIDOS`
    
*   🟡 **Agregar nota**
    
*   ✏️ **Editar marea**  
    → Solo campos administrativos o correcciones justificadas
    

## 4\. Estado: EN CORRECCIÓN

(si aplica en el flujo)

### Acciones disponibles

*   🟢 **Abrir corrección** _(si aún no está abierta)_  
    → Evento: `APERTURA_CORRECCION`
    
*   🟢 **Cerrar corrección**  
    → Evento: `CIERRE_CORRECCION`
    
*   🟡 **Asignar / cambiar responsable**  
    → Eventos: `ASIGNACION_RESPONSABLE` / `CAMBIO_RESPONSABLE`
    
*   🟡 **Subir datos corregidos**  
    → Evento: `CARGA_DATOS_CORREGIDOS`
    
*   🟡 **Agregar nota técnica**
    
*   ✏️ **Editar marea** _(restringido)_
    

## 5\. Estado: INFORME / PROTOCOLIZACIÓN

(según granularidad que manejen)

### Acciones disponibles

*   🟢 **Generar informe**  
    → Evento: `INFORME_GENERADO`
    
*   🟡 **Marcar informe como revisado**  
    → Evento: `INFORME_REVISADO`
    
*   🟢 **Aprobar informe**  
    → Evento: `INFORME_APROBADO`
    
*   🟢 **Iniciar protocolización**  
    → Evento: `PROTOCOLIZACION_INICIADA`
    
*   🟢 **Completar protocolización**  
    → Evento: `PROTOCOLIZACION_COMPLETADA`
    
*   🟡 **Agregar nota**
    

## 6\. Estado: PROTOCOLIZADA

Marea cerrada administrativamente.

### Acciones disponibles

*   🟡 **Agregar nota**
    
*   🔴 **Editar marea** _(solo roles especiales)_
    
*   🔍 **Consulta / visualización**
    

No se permiten acciones operativas.

## 7\. Acciones transversales (siempre disponibles)

Independientemente del estado, según permisos:

*   🟡 **Agregar nota administrativa**
    
*   🟡 **Agregar nota técnica**
    
*   🟡 **Registrar contacto con observador**
    
*   🟡 **Registrar contacto con buque / empresa**
    
*   🔍 **Ver bitácora de eventos**
    

## 8\. Regla final de diseño de UI

> **La vista principal de la marea debe funcionar como un “panel de control”.**
> 
> El usuario:
> 
> *   ve el estado actual,
>     
> *   ve qué puede hacer ahora,
>     
> *   y ejecuta la acción correcta en segundos.
>     

El formulario completo:

*   existe,
    
*   es necesario,
    
*   pero **no es el camino principal** del uso diario.
    

<br>