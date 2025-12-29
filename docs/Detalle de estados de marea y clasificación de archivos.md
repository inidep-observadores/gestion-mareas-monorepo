# Modelo de trazabilidad de mareas

**Estados, eventos y archivos**

Este modelo separa explícitamente tres dimensiones distintas del ciclo de vida de una marea:

1.  **Estado de la marea**  
    Representa la situación “macro” en la que se encuentra la marea dentro del proceso institucional.
    
2.  **Eventos (**`**tipo_evento**`**)**  
    Registran _hechos concretos_ que ocurren a lo largo del tiempo: decisiones, acciones administrativas, recepciones de datos, contactos, etc.  
    Los eventos **no definen el estado**, pero muchos de ellos pueden **provocar** o **acompañar** un cambio de estado.
    
3.  **Archivos (**`**tipo_archivo**`**)**  
    Describen _qué representa un archivo dentro del flujo_, independientemente de su formato físico (PDF, XLS, DBF, ZIP, etc.).
    

Esta separación permite:

*   Auditoría fina del proceso.
    
*   Reconstrucción histórica clara.
    
*   Flexibilidad sin forzar estados artificiales.
    

## 1) `tipo_evento` (tabla `mareas_movimientos`)

Un **evento** es cualquier hecho relevante ocurrido durante la vida de una marea.  
Todo evento queda registrado con fecha, usuario y observaciones opcionales.

Los eventos se agrupan **por función**, solo a efectos conceptuales y de filtrado.

### A. Flujo de estados

Estos eventos documentan explícitamente los cambios de estado de la marea.

*   `**CAMBIO_ESTADO**`  
    Registra cualquier transición de estado.
    
    El detalle del cambio **no está en el tipo**, sino en:
    
    *   `id_estado_desde`
        
    *   `id_estado_hasta`
        
    
    👉 Con este único tipo de evento alcanza para modelar todo el flujo de estados.
    

### B. Recepción y manejo de datos

Eventos que registran **cómo y desde dónde** ingresan datos al sistema.

*   `**RECEPCION_DATOS_ORIGINALES**`  
    Ingreso inicial de datos tal como los entrega el observador  
    (pendrive, mail, etc.).
    
*   `**RECEPCION_DATOS_EXTERNOS**`  
    Ingreso de datos que fueron trabajados fuera del equipo interno  
    (proyecto, laboratorio, consultoría externa).
    
*   `**CARGA_DATOS_CORREGIDOS**`  
    Se cargan versiones corregidas luego de una instancia de revisión.
    

Ejemplos:

*   El observador entrega DBF originales → `RECEPCION_DATOS_ORIGINALES`
    
*   Un proyecto devuelve un Excel corregido → `RECEPCION_DATOS_EXTERNOS`
    
*   Se sube la versión ajustada final → `CARGA_DATOS_CORREGIDOS`
    

### C. Corrección y responsables

Eventos administrativos vinculados a la gestión de la marea y su corrección.  
**No modelan sesiones técnicas**, solo decisiones.

*   `**APERTURA_CORRECCION**`  
    Se habilita formalmente la corrección interna.
    
*   `**CIERRE_CORRECCION**`  
    Se da por finalizada la corrección interna.
    
*   `**ASIGNACION_RESPONSABLE**`  
    Se asigna una persona responsable (marea o corrección).
    
*   `**CAMBIO_RESPONSABLE**`  
    Se reasigna la responsabilidad.
    

> Las sesiones de corrección en sí se modelan en `sesiones_correccion`.

### D. Documentación física y materiales

Eventos relacionados con materiales no puramente digitales.

*   `**ESCANEO_CARPETA**`  
    Se digitaliza la carpeta física y se sube el archivo resultante.
    
*   `**ENTREGA_OTOLITOS**`  
    Registro de entrega de muestras de otolitos  
    (usa `cantidad_otolitos`).
    
*   `**OTROS_MATERIALES_FISICOS**`  
    Cualquier otro material relevante (muestras, fotos físicas, etc.).
    

### E. Informe y protocolización

Eventos que documentan el ciclo de vida del informe técnico.

*   `**INFORME_GENERADO**`  
    Se genera un primer borrador del informe.
    
*   `**INFORME_REVISADO**`  
    Se registra una revisión o devolución.
    
*   `**INFORME_APROBADO**`  
    El informe queda aprobado para protocolizar.
    
*   `**PROTOCOLIZACION_INICIADA**`  
    Se inicia el trámite administrativo.
    
*   `**PROTOCOLIZACION_COMPLETADA**`  
    Se completa la protocolización  
    (suele coincidir con el estado _PROTOCOLIZADA_).
    

> Muchos de estos eventos suelen ir acompañados de `CAMBIO_ESTADO`, pero se mantienen separados para trazabilidad detallada.

### F. Notas y administración general

Eventos descriptivos que no necesariamente cambian el estado.

*   `**NOTA_ADMINISTRATIVA**`  
    Licencias, demoras, logística, cuestiones operativas.
    
*   `**NOTA_TECNICA**`  
    Aclaraciones metodológicas o técnicas.
    
*   `**CONTACTO_CON_OBSERVADOR**`  
    Llamadas, correos, consultas al observador.
    
*   `**CONTACTO_CON_BUQUE_EMPRESA**`  
    Gestiones con armador o empresa.
    
*   `**DELEGACION_EXTERNA**`  
    La marea se deriva formalmente a un proyecto/lab externo.
    
*   `**RETORNO_DELEGACION**`  
    Se reciben comentarios o correcciones desde afuera.
    
*   `**OTRO**`  
    Evento excepcional no encuadrable (válvula de escape).
    

### Resumen de `tipo_evento`

<br>

`CAMBIO_ESTADO RECEPCION_DATOS_ORIGINALES RECEPCION_DATOS_EXTERNOS CARGA_DATOS_CORREGIDOS APERTURA_CORRECCION CIERRE_CORRECCION ASIGNACION_RESPONSABLE CAMBIO_RESPONSABLE ESCANEO_CARPETA ENTREGA_OTOLITOS OTROS_MATERIALES_FISICOS INFORME_GENERADO INFORME_REVISADO INFORME_APROBADO PROTOCOLIZACION_INICIADA PROTOCOLIZACION_COMPLETADA NOTA_ADMINISTRATIVA NOTA_TECNICA CONTACTO_CON_OBSERVADOR CONTACTO_CON_BUQUE_EMPRESA DELEGACION_EXTERNA RETORNO_DELEGACION OTRO`

## 2) `tipo_archivo` (tabla `mareas_archivos`)

Describe **qué representa el archivo dentro del proceso**, no su extensión.

### A. Datos crudos y corregidos

*   `**DATOS_ORIGINALES_OBSERVADOR**`  
    Datos tal como los entregó el observador.
    
*   `**DATOS_CORREGIDOS_INTERNO**`  
    Versión corregida por el equipo interno.
    
*   `**DATOS_CORREGIDOS_EXTERNO**`  
    Versión corregida por un proyecto o laboratorio externo.
    

### B. Documentación digitalizada

*   `**CARPETA_ESCANEADA**`  
    PDF o ZIP con la carpeta física escaneada.
    
*   `**DOCUMENTACION_ADICIONAL**`  
    Actas, notas, autorizaciones, etc.
    

### C. Informes

*   `**INFORME_TECNICO_BORRADOR**`  
    Versión preliminar.
    
*   `**INFORME_TECNICO_FINAL**`  
    Versión final previa a protocolizar.
    
*   `**INFORME_PROTOCOLIZADO**`  
    Copia del informe protocolizado.
    
*   `**ANEXO_INFORME**`  
    Tablas, gráficos o anexos complementarios.
    

### D. Varios

*   `**MATERIAL_REFERENCIA**`  
    Mapas, protocolos, instrucciones específicas.
    
*   `**OTRO**`  
    Archivo no clasificable.
    

### Resumen de `tipo_archivo`

<br>

`DATOS_ORIGINALES_OBSERVADOR DATOS_CORREGIDOS_INTERNO DATOS_CORREGIDOS_EXTERNO CARPETA_ESCANEADA DOCUMENTACION_ADICIONAL INFORME_TECNICO_BORRADOR INFORME_TECNICO_FINAL INFORME_PROTOCOLIZADO ANEXO_INFORME MATERIAL_REFERENCIA OTRO`

## 3) Versiones y formatos (opcional)

No es obligatorio rigidizar el modelo, pero se recomiendan valores estándar.

### `version` (en `mareas_archivos`)

*   `**ORIGINAL**` – Primera versión recibida
    
*   `**CORREGIDO**` – Modificada luego de revisión
    
*   `**FINAL**` – Versión definitiva
    
*   `**COPIA**` – Respaldo o duplicado
    

### `formato`

Libre (PDF, XLSX, DBF, ZIP, etc.), sin forzar enumeración.