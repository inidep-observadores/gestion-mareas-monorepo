# Estrategias de Importación de Datos (DBF)

Este documento analiza las alternativas arquitectónicas para manejar la ingesta de archivos `.dbf` ruidosos, desnormalizados y potencialmente concurrentes.

## Análisis de Alternativas

### 1. Importación Directa (In-Place con banderas de error)
Implica guardar los datos crudos directamente en las tablas formales (`Lances`, `Muestras`, etc.), modificando el esquema para que *todos* los campos críticos (incluso FKs) sean nulables o permitan strings sucios, y agregando campos como `estado_validacion` o `errores`.

*   **Pros:** Una sola estructura de tablas. Sin pasos de migración interna.
*   **Contras:**
    *   **Contamina el dominio:** Ensucia las tablas "doradas" (truth source) con datos basura temporalmente.
    *   **Complejidad en consultas:** El frontend y los reportes deben filtrar constantemente `WHERE estado_validacion = 'OK'`.
    *   **Inconsistencia relacional:** Impide el uso estricto de Foreign Keys y `NOT NULL` en Prisma para proteger la integridad, ya que hay que debilitar la base de datos para aceptar la basura.

### 2. Tablas Intermedias (Staging Tables) - **[NUEVA ALTERNATIVA RECOMENDADA]**
Implica crear un esquema espejo transitorio en la base de datos (ej: `schema "import"` o prefijo `imp_lances`, `imp_muestras`). Los DBFs se vuelcan aquí permitiendo datos sucios (tipos relajados o `errores` adjuntos). Luego un proceso de negocio valida, normaliza y mueve los registros limpios a las tablas de `public`.

Dado tu **requerimiento clave** de poder corregir errores de forma iterativa utilizando CRUDs por cada entidad (Lances, Capturas, Muestras), **esta arquitectura se convierte en la ganadora absoluta**.

### Ciclo de Vida e Integración con Estados de Marea

Esta estrategia de Staging se acopla perfectamente a la máquina de estados de la Marea mediante el siguiente flujo transaccional:

#### 1. Ingesta Inicial (`ENTREGADA_RECIBIDA`)
Cuando la marea finaliza y arriba el soporte físico/digital, el personal de recepción carga los archivos `.dbf`.
*   **Acción del Sistema:** Lee los `.dbf` y hace un volcado *crudo* inseratando los registros en las tablas espejo (`imp_lances`, `imp_muestras`, etc.) vinculados a un único `id_lote_importacion` atado a la `mareaId`.
*   **Estado de Marea:** Permanece o pasa a `ENTREGADA_RECIBIDA`. Los datos están en el servidor, sucios, esperando ser tomados.

#### 2. Bloqueo y Reclamación (`EN_CORRECCION`)
La corrección no es inmediata. Tiempo después, un analista (que puede ser distinto al receptor) decide procesar esta marea.
*   **Acción del Usuario:** Clic en "Iniciar Corrección".
*   **Acción del Sistema:** 
    1. Registra al usuario actual como "propietario" de ese lote (Lock). 
    2. Cambia el estado de la marea a `EN_CORRECCION`.
*   **Regla de Negocio (Bloqueo Duro):** Mientras el lote esté asignado, ningún otro usuario u proceso puede escribir en las tablas `imp_*` para esta marea, ni reclamarla. Otorga aislamiento total para que el analista trabaje tranquilo con sus CRUDs.

#### 3. Iteración y Validación en Staging
El analista a cargo hace uso intensivo de la plataforma.
*   **Acción Micro (Punta-a-Punta):** Edita registros individuales en Lances o Muestras, mediante CRUDs tradicionales que apuntan al esquema `import.*`.
*   **Macro-Acciones (Correcciones de Lote o Masivas):** Existen errores sistémicos (el observador entendió mal una instrucción para docenas de lances) que requieren herramientas poderosas en frontend para no obligar al analista a editar lanza por lanza. El sistema proveerá:
    1.  **Reemplazo Masivo de Especie:** Una vista listará el Set Único de Especies presentes en esta Marea (tablas espejo `imp_capturas`, `imp_muestras`, `imp_producciones`). El analista podrá seleccionar una Especie "Origen" y dictar una Especie "Destino" de reemplazo. Al aceptar, un endpoint de NestJS (`POST /api/import/lote/:id/bulk/reemplazar-especie`) correrá transaccionalmente un `UPDATE` en cascada sobre todas las tablas staging de esa marea, haciendo el swap total.
    2.  **Conversión de Descarte (Porcentaje a Kilos):** Si el observador utilizó la grilla de capturas de manera desviada anotando `%` en lugar de kilos nominales (un error humano de campo típico), y la BD esperaba float normal, el analista usará el panel de **"Recalcular Descartes"**. El backend identificará esos ingresos porcentuales como cadenas, y mediante la captura total de cada lance, calculará el descarte derivado ($KgDescarte = CapturaTotalKg \times (Porcentaje/100)$) actualizando todos los registros de capturas automáticamente en la base relacional staging.
*   **Validación Constante:** Tras cada guardado manual o Ejecución de Macro-Acción Automática, los gatillos del backend (o el refetch del frontend) re-evalúan el motor biológico; el dashboard central reduce el conteo visual de incidencias en tiempo real.

#### 4. Consolidación y Promoción (`PENDIENTE_DE_INFORME`)
El analista visualiza que el Lote tiene `0 ERRORES`. Termina su labor.
*   **Acción del Usuario:** Clic en "Confirmar Marea".
*   **Acción del Sistema:**
    1. Transfiere transaccionalmente (SQL masivo) todos los registros perfectos de `imp_*` hacia las tablas operativas definitivas en `public.*`.
    2. Libera el bloqueo del usuario.
    3. Cambia el estado de la Marea a `PENDIENTE_DE_INFORME`.
    4. (Opcional) Limpia las tablas espejo para esa marea o las marca `HISTORICO`.

### Mecanismos Excepcionales (Resiliencia)

Para garantizar que el modelo soporte el mundo real, se integran dos flujos de emergencia vitales:

#### A. La Vuelta Atrás (Rollback a Corrección)
Si en fases avanzadas (`PENDIENTE_DE_INFORME` o posteriores) un superior o un control de calidad detecta un fallo estructural que fue omitido.
*   **Acción:** Reversión de Estado ("Devolver a Corrección").
*   **Mecanismo Dual:** 
    *   **Si las tablas espejo no se borraron:** Simplemente se eliminan las tablas "limpias" recién inyectadas en `public.*` y se restaura el lote en `import.*`, volviendo el estado de marea a `EN_CORRECCION`.
    *   **Si las tablas espejo se limpian por diseño:** El sistema realiza el proceso "Inverso de Promoción". Saca los datos de `public.*`, los vuelve a inyectar en `import.*`, los elimina del esquema productivo y entrega la tenencia de corrección a un nuevo analista.

#### B. Re-Importación Destructiva (Reemplazo de Base)
¿Qué sucede si los analistas se dan cuenta de que el disco original que leyeron era un backup viejo, o que el observador envió un set de archivos nuevo tras notar sus omisiones?
*   **Acción:** Reingreso de disco/archivos en una marea que ya tiene datos en staging.
*   **Mecanismo:** El sistema alerta visiblemente con una barrera roja: *"Atención: Una carga sobreescribirá por completo los archivos originales. Cualquier corrección manual iterativa que hayas realizado en el sistema hasta el momento se perderá de forma irreversible."*
*   **Ejecución:** Si se acepta, se hace un `DELETE CASCADE` sobre el `id_lote_importacion` en el esquema staging, liberando todo progreso previo, y se repite el Paso 1 (Ingesta Inicial `ENTREGADA_RECIBIDA`) con los nuevos DBF físicos.

### Sistema Inverso: Exportación a DBF Saneado (Legacy Support)

Un requisito crítico de este sistema es que actúa como el puente sanitizador de la organización. Hay aplicaciones legacy que consumen `.dbf` y no pueden conectarse a la API moderna de NestJS/PostgreSQL.

**Flujo de Exportación `Back-to-DBF`:**
1.  **Disparador:** Puede ser ejecutado automáticamente al finalizar la Consolidación (Marea a `PENDIENTE_DE_INFORME`) o solicitado on-demand desde el UI de una marea limpia.
2.  **Transformador (Serializador DBF):** Un servicio en NestJS (utilizando librerías como `dbffile` o scripts Python ejecutables) leerá los registros saneados desde las tablas `public.*` de la marea especificada.
3.  **Mapeo Rígido:** El sistema deberá transformar los datos modernos (Fechas ISO, IDs Únicos) de regreso a los tipos de columna restrictivos de DBASE III o IV (Cadenas numéricas fijas, booleanos T/F, límites de string).
4.  **Descarga/Publicación:** El backend empaqueta los N archivos generados (`Lances_Clean.dbf`, `Muestras_Clean.dbf`) en un `.zip` disponible para descargar desde el Frontend, o los deposita en un servidor FTP interno para que los sistemas legacy los consuman automáticamente.

---

### ¿Cómo funcionaría con el Requisito de CRUD Iterativo?

1.  **Tablas Espejo (`imp_lances`, `imp_capturas`, etc.):** Se diseñan en Prisma de forma casi idéntica a las originales (que usa la app de recolección), pero añadiendo tres campos clave: `id_lote_importacion` (para aislar las mareas de diferentes usuarios concurrentes), `estado_validacion` (`PENDIENTE`, `ERROR`, `OK`) y `detalle_errores` (JSON con las validaciones fallidas).
2.  **Desarrollo Específico de CRUDs:** Dado que el sistema centralizado no cuenta con CRUDs preexistentes en `public.*` (las tablas productivas son de solo-lectura analítica y carga histórica consolidada), **se desarrollarán vistas front-end y endpoints backend (`GET /api/import/lances`, `PATCH /api/import/lances/:id`) diseñados exclusiva y nativamente para operar sobre estas tablas de Staging**. 
3.  **Iteración Real:** El analista abre el lote, entra al CRUD específico de Lances de importación. Edita un lance con error temporal, le da a "Guardar". El backend altera `imp_lances`, corre el motor de validación biológica sobre ese lance, y si todo da verde, pasa ese lance a `estado = OK`.
4.  **Confirmación Transaccional:** Cuando todos los registros de `imp_lances` y dependencias del Lote X están en `OK`, un botón final "Aplicar Marea" ejecuta un script SQL rápido (Ej: `INSERT INTO public.lances SELECT * FROM import.lances WHERE id_lote = X`) que mueve la marea entera al sistema definitivo. Nunca se edita manualmente sobre las tablas `public.*`.

*   **Pros:**
    *   **Facilidad de Front-End:** Construir CRUDs visuales en Vue sobre tablas relacionales Staging es estándar, robusto y familiar.
cíficos del JSON en el aire.
4. Para cada mínimo autoguardado de corrección, enviar todo el JSON pesadísimo por la red, o programar un sistema de parches complejos (JSON Patch/Merge).
Esto rompe el patrón estándar de Vue/NestJS. Pierdes la potencia de SQL para filtrar los datos *mientras* los estás corrigiendo.

## 3. La Tercera Vía (Documento Crudo Transaccional JSONB)

Esta era la opción original para sistemas "rápidos", donde se volcaba todo el DBF crudo como una gran matriz JSON en un campo de una tabla general de importaciones.

### ¿Por qué NO es ideal dado el nuevo requisito?
Para implementar "CRUDs granulares" sobre Lances, Capturas y Submuestras, el enfoque JSONB falla. Tendrías que:
1. Volcar todo el archivo a un JSON gigante.
2. Hacer que el Frontend parsee ese JSON inmenso.
3. Diseñar una interfaz personalizada tipo Excel o un manejador de estado Vue (Pinia) bestial para editar nodos específicos del JSON en el aire.
4. Para cada mínimo autoguardado de corrección, enviar todo el JSON pesadísimo por la red, o programar un sistema de parches complejos (JSON Patch/Merge).
Esto rompe el patrón estándar de Vue/NestJS. Pierdes la potencia de SQL para filtrar los datos *mientras* los estás corrigiendo.

## Conclusión Actualizada

El requerimiento de **"trabajar con los datos originales mediante CRUDs para editar de forma iterativa y granular"** dicta sentencia:

Debemos utilizar la **Alternativa 2: Tablas Intermedias / Staging Schema**.

**Arquitectura recomendada para Prisma:**
Crear un bloque de modelos `imp_*` que imite los modelos operativos, unidos por una entidad padre `LoteImportacion`. Estas tablas staging absorberán los .dbf crudos. Desarrollaremos servicios NestJS CRUD para este esquema "sucio", permitiendo a los analistas corregirlos en el Vue con las mismas herramientas habituales, hasta que el Lote entero valide en verde y se transfiera seguro a las tablas public.
