# Diseño del Reporte de Diagnóstico y Validación (Mareas)

Este documento establece la estructura y componentes del reporte funcional que utilizarán los analistas para auditar y corregir las importaciones crudas (.dbf) alojadas en el entorno Staging (`imp_*`). 

El reporte debe funcionar tanto como una herramienta interactiva en pantalla (con navegación directa a los CRUDs) como un documento estático optimizado para impresión (para que el analista pueda puntear contra las planillas físicas originales).

---

## 1. Estructura General del Reporte

El reporte contendrá tres bloques informativos jerárquicos:

### A. Encabezado de la Marea (Contexto)
Datos inmutables para orientar al analista y evitar traspapelamientos si imprime varios lotes.
*   **Buque:** Nombre y Matrícula.
*   **Identificador de Marea:** Año / Número.
*   **Fechas de Etapa:** Zarpada a Arribo.
*   **Lote ID:** Hash visual o número de importación para trazabilidad.
*   **Analista Asignado:** Usuario que posee el "*Lock*" o bloqueo de corrección actual.

### B. Dashboard de Salud de Datos (Resumen Ejecutivo)
Un panel rápido que indica la magnitud del trabajo pendiente.
*   **Métricas Globales (Rojo y Naranja):**
    *   X Errores Críticos (Bloqueantes).
    *   Y Advertencias (`Warnings` biológicos).
*   **Distribución del daño por Entidad:**
    *   Lances: XX de YY lances presentan errores. (Ej. 14 / 80).
    *   Capturas: XX registros afectados.
    *   Muestras: XX afectadas.
    *   Submuestras: XX afectadas.

### C. Listado Detallado de Discrepancias (Agrupado por Lance cronológico)
Esta es el área principal de trabajo. En lugar de listar los errores organizados alfabéticamente por especie o tabla, el listado **debe agruparse cronológicamente por número de Lance**, ya que la libreta de campo física del observador está ordenada secuencialmente por lances a lo largo de los días de navegación.

**Ejemplo de Bloque en el Reporte:**

> **LANCE N° 14 - Fecha: 12/10/2026 - Arte: Arrastre Fondo**
> *   🔴 `[ERROR]` - **Tiempos Inventados:** La hora de inicio (14:30) y final (18:40) arrojan un lapso de 4h 10m, pero el Campo `tiempoRed` reporta 9h.
>     *   *Valor actual en base:* `tiempoRed` = 540 min.
> *   🟡 `[WARNING]` - **Velocidad Excesiva:** Distancia reportada (20nm) en 4 horas implica velocidad mantenida de 5 nudos, superior al umbral histórico promedio de 3.5 nudos para merluza demersal.
> *   **Capturas del Lance 14:**
>     *   🔴 `[ERROR]` -  **Merluza Común:** `kgCaptura` retenida reporta nulo (n/a), pero hay registro de Especie procesada en bodega para el mismo día.
> *   **Muestra Cód. 50 (Langostino):**
>     *   🟡 `[WARNING]` -  **Sex Ratio Irregular:** 150 Ejemplares Machos vs 2 Hembras documentados. Revisar tabulación de cruces de la planilla física.

---

## 2. Diferencias de Interfaces (Pantalla vs Imprimible)

Para potenciar la eficiencia del analista, el motor de la vista (`Vue.js` renderizando en navegador vs motor PDF/Impresora) dictará el comportamiento:

### Vista Interactiva (Dashboard en Pantalla)

*   **Filtros en Vivo:** 
    *   Filtro "Mostrar solo errores críticos", "Ocultar Warnings".
    *   Buscador rápido "*Lance XX*".
*   **Interacción (Deep Links a CRUDs):** El listado detallado no es solo texto. Picar sobre la caja roja del error del Lance 14 **abre directamente un sidebar con el formulario CRUD del Lance 14 de Staging**, enfocado en la pestaña de Tiempos/Cinemática. 
*   **Actualización en Tiempo Real:** Al guardar la corrección en el CRUD, el dashboard evalúa el registro localmente. Si el error fue resuelto, la fila de discrepancia hace una animación fade-out y desaparece de los pendientes (gamificación del proceso de saneo).

### Documento Imprimible (Borrador de Auditoría en Papel)

Históricamente, muchos analistas biológicos contrastan la pantalla prefiriendo puntear ("hacer tildes" $\checkmark$) sobre un listado impreso mientras, con la otra mano, hojean la libreta manchada de a bordo.

*   **Layout Alto Contraste (Blanco y Negro):** Uso de iconografía clara ($\otimes$ en lugar de rojo para Errores, $\triangle$ en lugar de amarillo para Warnings) ya que será impreso comúnmente en escala de grises / impresoras láser estándar.
*   **Espacios Físicos (Checklists blancos):** Cada ítem listado debe poseer una pequeña caja cuadrada `[ ]` a la izquierda, grande y limpia, para que el analista pueda tildarla con bolígrafo una vez que revisó ese punto en la libreta.
*   **Condensación de Espacios:** Eliminación total de avatares, menús laterales, botones, para imprimir la máxima cantidad de anomalías legibles en formato A4 ahorrando papel institucional (Diseño tipo Tabulación densa).

---

## 3. Resumen Técnico del Componente (Implementación Sugerida)

Para NestJS / Vue:
1.  NestJS provee un EndPoint (`GET /import/lote/:id/diagnostico`) que corre todas las reglas del documento de validaciones contra las cuatro tablas staging, y devuelve una inmensa matriz JSON de incidencias agrupadas por `Lance`.
2.  El Frontend de Vue parseará este JSON alimentando un componente tipo acordeón (Expandir Lance N).
3.  El botón "Imprimir" del frontend inyectará temporalmente una clase CSS `@media print` al cuerpo del DOM que oculta todos los botones, expande todos los acordeones forzosamente, altera colores y añade los checkboxes en blanco `[ ]` antes de lanzar el diálogo nativo `window.print()` del navegador Chrome. No es necesario armar un PDF costoso en el backend.
