# Estados de marea

## 1) `tipo_evento` en `mareas_movimientos`

Te los agrupo por función, así después es fácil filtrarlos.

### A. Flujo de estados

`'CAMBIO_ESTADO' &nbsp; &nbsp;      // Cualquier transición de estado de la marea`

> Ya con este uno solo alcanza, porque el detalle está en `id_estado_desde` / `id_estado_hasta`.

### B. Recepción y manejo de datos

`'RECEPCION_DATOS_ORIGINALES'   // Llegan por primera vez los archivos del observador 'CARGA_DATOS_CORREGIDOS'       // Se suben archivos corregidos (luego de una sesión de corrección) 'RECEPCION_DATOS_EXTERNOS'     // Llegan datos desde un proyecto/lab externo (si corrigen afuera)`

* En la práctica, cuando el observador trae un pendrive o manda por mail, usarías `RECEPCION_DATOS_ORIGINALES`.

* Si se delega a un proyecto y luego devuelven un Excel corregido, usarías `RECEPCION_DATOS_EXTERNOS`.

### C. Corrección y responsables

`'APERTURA_CORRECCION'          // Se abre una sesión de corrección interna 'CIERRE_CORRECCION'            // Se da por finalizada la corrección interna 'ASIGNACION_RESPONSABLE'       // Se asigna alguien como responsable de la marea o de su corrección 'CAMBIO_RESPONSABLE'           // Se reasigna el responsable`

> Acá no estás modelando la sesión en sí (eso va en `sesiones_correccion`), sino dejando trazas claras de decisiones administrativas.

### D. Documentación física / escaneo / otolitos

`'ESCANEO_CARPETA'              // Se escanea la carpeta física y se sube el PDF 'ENTREGA_OTOLITOS'             // Se registran muestras de otolitos entregadas (usa cantidad_otolitos) 'OTROS_MATERIALES_FISICOS'     // Cualquier otro material físico relevante (muestras, fotos físicas, etc.)`

### E. Informe y protocolización

`'INFORME_GENERADO'             // Se genera el primer informe técnico (versión borrador) 'INFORME_REVISADO'             // Se registra una revisión del informe (ej. devolución de coordinador) 'INFORME_APROBADO'             // Informe aprobado para protocolizar 'PROTOCOLIZACION_INICIADA'     // Se inicia el trámite de protocolización 'PROTOCOLIZACION_COMPLETADA'   // Se completa el trámite (normalmente coincide con estado PROTOCOLIZADA)`

> Muchos de estos eventos van a ir de la mano de `CAMBIO_ESTADO`, pero conviene tenerlos diferenciados para auditoría fina.

### F. Notas y administración general

`'NOTA_ADMINISTRATIVA'          // Comentarios administrativos: licencias, demoras, problemas de logística 'NOTA_TECNICA'                 // Comentarios técnicos sobre datos, procedimientos, aclaraciones metodológicas 'CONTACTO_CON_OBSERVADOR'      // Registro de llamados/correos al observador (por dudas, demoras, etc.) 'CONTACTO_CON_BUQUE_EMPRESA'   // Registro de gestiones con armador/empresa 'DELEGACION_EXTERNA'           // La marea se deriva formalmente a un proyecto/lab externo para revisión 'RETORNO_DELEGACION'           // Vuelven con correcciones/comentarios desde afuera 'OTRO'                         // Cualquier cosa que no encaje (válvula de escape)`

### Resumen de `tipo_evento` sugeridos

`'CAMBIO_ESTADO' 'RECEPCION_DATOS_ORIGINALES' 'RECEPCION_DATOS_EXTERNOS' 'CARGA_DATOS_CORREGIDOS' 'APERTURA_CORRECCION' 'CIERRE_CORRECCION' 'ASIGNACION_RESPONSABLE' 'CAMBIO_RESPONSABLE' 'ESCANEO_CARPETA' 'ENTREGA_OTOLITOS' 'OTROS_MATERIALES_FISICOS' 'INFORME_GENERADO' 'INFORME_REVISADO' 'INFORME_APROBADO' 'PROTOCOLIZACION_INICIADA' 'PROTOCOLIZACION_COMPLETADA' 'NOTA_ADMINISTRATIVA' 'NOTA_TECNICA' 'CONTACTO_CON_OBSERVADOR' 'CONTACTO_CON_BUQUE_EMPRESA' 'DELEGACION_EXTERNA' 'RETORNO_DELEGACION' 'OTRO'`

## 2) `tipo_archivo` en `mareas_archivos`

Acá queremos describir **qué representa** el archivo en el flujo.

### A. Datos crudos y corregidos

`'DATOS_ORIGINALES_OBSERVADOR'   // DBF/XLS/etc tal como los entregó el observador 'DATOS_CORREGIDOS_INTERNO'      // Versión corregida por técnicos internos 'DATOS_CORREGIDOS_EXTERNO'      // Versión corregida por un proyecto/lab externo`

### B. Documentación digitalizada

`'CARPETA_ESCANEADA'             // PDF (o ZIP) con la carpeta física escaneada 'DOCUMENTACION_ADICIONAL'       // Otros documentos asociados: actas, notas, autorizaciones, etc.`

### C. Informes

`'INFORME_TECNICO_BORRADOR'      // Versión preliminar 'INFORME_TECNICO_FINAL'         // Versión final (previa a protocolizar) 'INFORME_PROTOCOLIZADO'         // Copia del informe protocolizado (PDF final) 'ANEXO_INFORME'                 // Tablas, gráficos, anexos que acompañan el informe`

### D. Varios

`'MATERIAL_REFERENCIA'           // Mapas, instrucciones, protocolos específicos de esa marea 'OTRO'                          // Cualquier archivo que no entre en otra categoría`

### Resumen de `tipo_archivo` sugeridos

`'DATOS_ORIGINALES_OBSERVADOR' 'DATOS_CORREGIDOS_INTERNO' 'DATOS_CORREGIDOS_EXTERNO' 'CARPETA_ESCANEADA' 'DOCUMENTACION_ADICIONAL' 'INFORME_TECNICO_BORRADOR' 'INFORME_TECNICO_FINAL' 'INFORME_PROTOCOLIZADO' 'ANEXO_INFORME' 'MATERIAL_REFERENCIA' 'OTRO'`

## 3) `version` y `formato` (por si los querés estandarizar también)

No hace falta volver loco el modelo, pero podés tener constantes recomendadas.

### `version` (en `mareas_archivos`)

`'ORIGINAL'      // Lo primero que llegó (ej. datos del observador) 'CORREGIDO'     // Modificado después de revisión 'FINAL'         // Versión definitiva (ej. informe final) 'COPIA'         // Copias, respaldos, etc.`

### `formato`

<br>
