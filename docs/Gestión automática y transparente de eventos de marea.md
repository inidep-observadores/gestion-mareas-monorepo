## Contexto

El sistema registra una gran variedad de eventos asociados al ciclo de vida de una marea: designación, ejecución, alertas, etapas, correcciones, importación de trayectorias, informes y protocolización.

Estos eventos cumplen un rol clave en:

*   la trazabilidad del proceso,
    
*   la auditoría administrativa,
    
*   y la reconstrucción histórica de decisiones.
    

Sin embargo, exponer al usuario final la responsabilidad de **seleccionar manualmente el tipo de evento** introduce un alto riesgo de:

*   errores de clasificación,
    
*   inconsistencias semánticas,
    
*   mala experiencia de uso,
    
*   y datos difíciles de interpretar a largo plazo.
    

## Decisión adoptada

👉 **Los tipos de evento (**`**tipo_evento**`**) son de uso interno del sistema y se gestionan de forma automática.**

El usuario **no selecciona** ni **define explícitamente** el tipo de evento en la mayoría de los casos.

## Principio rector

> **El usuario realiza acciones.**  
> **El sistema registra eventos.**

Los eventos son una **consecuencia técnica** de una acción o decisión, no una entrada manual del usuario.

## Alcance de la automatización

### 1\. Eventos automáticos (la gran mayoría)

Se generan automáticamente desde los **casos de uso del backend**, como efecto colateral de una acción concreta.

Ejemplos:

*   Designar un observador → `DESIGNACION_OBSERVADOR`
    
*   Modificar fecha estimada de zarpada → `ACTUALIZACION_FECHA_ESTIMADA_ZARPADA`
    
*   Confirmar una alerta de zarpada → `CONFIRMACION_ZARPADA`
    
*   Confirmar una alerta de arribo → `CONFIRMACION_ARRIBO`
    
*   Crear o cerrar una etapa → `CREACION_ETAPA_MANUAL` / `CIERRE_ETAPA_MANUAL`
    
*   Importar trayectoria → `IMPORTACION_TRAYECTORIA`
    
*   Recalcular zona austral → `RECALCULO_ZONA_AUSTRAL`
    
*   Cambiar estado → `CAMBIO_ESTADO`
    
*   Generar / revisar / aprobar informe → eventos correspondientes
    

En todos estos casos:

*   el usuario interactúa con una acción concreta (botón, flujo guiado, confirmación),
    
*   el backend **decide** qué evento corresponde registrar,
    
*   el `tipo_evento` **no se expone** en la interfaz.
    

### 2\. Eventos semimanuales (casos excepcionales)

Solo algunos eventos de tipo **narrativo o descriptivo** pueden ser iniciados explícitamente por el usuario, pero **sin acceso libre al catálogo completo**.

Estos son:

*   `NOTA_ADMINISTRATIVA`
    
*   `NOTA_TECNICA`
    
*   `CONTACTO_CON_OBSERVADOR`
    
*   `CONTACTO_CON_BUQUE_EMPRESA`
    
*   `OTRO` (casos excepcionales)
    

Incluso en estos casos:

*   la UI ofrece **opciones acotadas y semánticamente claras** (ej. “Agregar nota técnica”),
    
*   no existe un selector genérico de `tipo_evento`.
    

## Decisiones explícitas de diseño

*   ❌ **No existe** una acción genérica tipo “Crear evento”.
    
*   ❌ **No se expone** un dropdown con todos los valores de `tipo_evento`.
    
*   ✅ Cada acción funcional del sistema conoce **qué evento debe generar**.
    
*   ✅ Los eventos se crean **en el backend**, dentro de los casos de uso.
    
*   ✅ El frontend no necesita conocer ni validar el catálogo completo de eventos.
    

## Beneficios de esta decisión

### Usabilidad

*   El usuario no debe entender el modelo interno de eventos.
    
*   Se reduce la carga cognitiva y la posibilidad de error.
    

### Calidad de datos

*   Los eventos son consistentes y semánticamente correctos.
    
*   No hay “eventos mal elegidos”.
    

### Mantenibilidad

*   El catálogo de eventos puede evolucionar sin impactar la UI.
    
*   Se pueden agregar eventos nuevos sin romper flujos existentes.
    

### Auditoría y trazabilidad

*   Cada evento refleja una **acción real o una decisión confirmada**.
    
*   La bitácora es confiable y legible.
    

## Regla final para implementación

> **El sistema es el único responsable de decidir qué evento se registra.**  
> **El usuario solo decide qué acción realizar o qué información ingresar.**

Esta regla debe respetarse tanto en:

*   el diseño del backend (casos de uso),
    
*   como en el diseño de la interfaz de usuario.