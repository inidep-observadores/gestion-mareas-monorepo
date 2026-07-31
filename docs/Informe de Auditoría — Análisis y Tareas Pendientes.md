# Informe de Auditoría de Mareas — Análisis de Requerimientos y Tareas Pendientes

> **Estado al 2026-04-02** · Versión del sistema: `0.5.0` · Rama activa: `feature/auditoria`

---

## Contexto del Módulo

El Panel de Auditoría (`AuditAnalysisPanel.vue`) es el centro de análisis estadístico anual
destinado a la generación de informes de auditoría interna del Proyecto Observadores a Bordo (INIDEP).
Se accede desde el tab "Auditoría" dentro de la vista de Estadísticas (`StatsView`).

El panel consume los mismos filtros globales del módulo de estadísticas (año, modo calendario/total,
fechas personalizadas, campañas) y genera tres salidas:
1. **UI interactiva** — pestañas con tablas, gráficos y KPIs.
2. **Exportación Excel** (`DATOS EXCEL`) — workbook con 3+ hojas para auditoría técnica.
3. **Informe Word** (`GENERAR INFORME`) — documento narrativo completo.

---

## Estado Actual de Implementación

### ✅ Completado en esta iteración (v0.5.0)

#### Dominio / Base de Datos
- **Nuevo estado `DESESTIMADA`**: mareas ejecutadas cuyos datos son descartados. Distinto de
  `CANCELADA` (mareas que nunca llegaron a ejecutarse).
  - 7 transiciones habilitadas hacia `DESESTIMADA` con acción `DESESTIMAR`.
  - Migración automática: `20260402000000_add_estado_desestimada/migration.sql`.
  - `DESESTIMADA` excluida de todas las consultas de estadísticas principales.

#### Backend — Nuevos endpoints
| Endpoint | Descripción |
|---|---|
| `GET /stats/secondary-observers` | Observadores con etapas en rol secundario, agrupados por observador |
| `GET /stats/audit-special-cases` | Mareas en estado especial: canceladas, desestimadas, pendientes de informe, derivadas externas |
| `GET /stats/protocolization-timeline` | Timeline mensual: enviadas a DNI vs. protocolizadas, latencia promedio y máxima |

- `StatsDetailItem` extendido con: `estadoActual`, `fechaZarpada`, `fechaArribo`, `fechaDerivacion`.
- `ProtocolizationTimelineResult` incluye `totalEnviadas` y campo `enviadas` por mes.
- La distribución mensual del timeline respeta el período del filtro (no siempre 12 meses).

#### Frontend — UI
- **`AuditAnalysisPanel.vue`**: arquitectura de pestañas con toolbar, barra KPI permanente y
  precarga del badge de Seguimiento.
- **`AuditSummaryBar.vue`**: 6 KPIs permanentes (Mareas, Días, Cobertura %, Protocolizadas,
  Canceladas+Desestimadas, Requieren atención).
- **`AuditPersonalTab.vue`**: ranking de observadores + columna Etapas Sec. + banner de resumen.
- **`AuditNavegacionTab.vue`**: tabla con Zarpada/Arribo, DELEGADA_EXTERNA en ámbar con fecha de
  derivación y nota explicativa.
- **`AuditPesqueriasTab.vue`**: agrupación Pesquería → Flota, gráfico apilado interactivo,
  secciones expandibles por pesquería.
- **`AuditSeguimientoTab.vue`**: contadores + tablas acordeón para 4 tipos de casos especiales +
  timeline de protocolización con doble barra (enviadas / protocolizadas).
- **`AuditSpecialCaseTable.vue`**: componente acordeón reutilizable para listas de casos especiales.
- **Tooltips premium** en todos los gráficos de auditoría (estilo consistente con Tendencia Mensual).

---

## ⏳ Tareas Pendientes

> El usuario explícitamente decidió: *"Una vez que aprobemos la funcionalidad de la UI veremos
> como implementar los reportes."* Las tareas siguientes se retoman **después de la aprobación
> de la UI actual**.

---

### TAREA 1 — Actualizar Exportación Excel (`DATOS EXCEL`)

**Archivo relevante:** `app/backend/src/stats/stats.service.ts`  
**Método principal:** `getAuditExportWorkbook()` (~línea 2216) y helpers `buildAuditPersonalSheet`,
`buildAuditNavegacionSheet`, `buildAuditPesqueriaSheet`.

El workbook actual tiene **3 hojas**. Se deben actualizar las existentes y agregar **2 hojas nuevas**.

#### 1.1 Hoja "Personal" — actualizar
- Agregar columna **"Etapas como Secundario"** en la tabla de ranking de observadores.
  - Fuente de datos: llamar a `getSecondaryObserverStats(year, startDate, endDate)` dentro de
    `getAuditExportWorkbook()` y cruzar por `observadorId`.
- Agregar fila de totales con suma de etapas secundarias.

#### 1.2 Hoja "Navegación" — actualizar
- Agregar columnas **Fecha Zarpada** y **Fecha Arribo** (formato `DD/MM/AAAA`).
  - Ya disponibles en `detailItems` como `item.fechaZarpada` / `item.fechaArribo`.
- Marcar filas de mareas `DELEGADA_EXTERNA` con fondo ámbar claro (color Excel: `FFFFF3CD` aprox.)
  y agregar columna **"Obs."** con el texto `"Derivada a proyecto externo"` + la fecha de derivación
  formateada (`item.fechaDerivacion`).
- Agregar nota al pie de la hoja: *"Las mareas marcadas como Derivadas a Proyecto Externo están
  pendientes de validación por un proyecto ajeno al Proyecto Observadores a Bordo."*

#### 1.3 Hoja "Pesquería" — verificar
- Revisar que la agrupación use Pesquería como dimensión primaria y Flota como secundaria
  (consistente con la corrección de terminología realizada en la UI).
- Sin cambios estructurales previstos salvo ese alineamiento.

#### 1.4 Nueva hoja "Casos Especiales"
Llamar a `getAuditSpecialCases(year, startDate, endDate, includeCampaigns)` y generar una hoja
con 4 secciones separadas por un encabezado de sección coloreado:

| Sección | Color cabecera | Datos |
|---|---|---|
| Canceladas | Ámbar (`FFFFC107`) | id_marea, buque, pesquería, flota, observador, días nav., fecha cancelación |
| Desestimadas | Rojo (`FFF44336`) | ídem + motivo |
| Pendientes de Informe | Azul cielo (`FF03A9F4`) | ídem sin motivo |
| Derivadas a Proyecto Externo | Ámbar oscuro (`FFFF9800`) | ídem + fecha derivación |

- Total de cada sección al pie de cada bloque.
- Nota explicativa al final de la sección de Derivadas.

#### 1.5 Nueva hoja "Protocolización"
Llamar a `getProtocolizationTimeline(year, startDate, endDate)` y generar:

- **Bloque KPIs** (tabla vertical izquierda):
  - Enviadas a DNI
  - Protocolizadas
  - Sin protocolizar
  - Latencia promedio (días)
  - Latencia máxima (días)
- **Tabla de distribución mensual** (derecha o debajo):
  - Columnas: Mes | Enviadas a DNI | Protocolizadas | Acumulado | % del Total
  - Solo filas con `cantidad > 0 || enviadas > 0`
  - Fila de totales al pie.

---

### TAREA 2 — Actualizar Informe Word (`GENERAR INFORME`)

**Archivo relevante:** `app/backend/src/reports/templates/audit-report.builder.ts` (861 líneas)  
**Librería:** `docx` (ya instalada y en uso).

#### 2.1 Sección de Personal — actualizar
- Agregar párrafo sobre **observadores secundarios**: *"Durante el período se registraron N
  participaciones de observadores en calidad de secundarios, involucrando a X observadores distintos."*
  - Datos desde `getSecondaryObserverStats()`.
- Incorporar tabla de observadores con columna adicional de etapas secundarias (si las hay).

#### 2.2 Sección de Navegación — actualizar
- Para las mareas `DELEGADA_EXTERNA`: agregar un **párrafo aclaratorio** después del listado:
  > *"N marea/s de las registradas en el período se encuentran derivadas a proyectos externos
  > para validación de datos. La eventual demora en la confección del informe correspondiente
  > es ajena al Subprograma Observadores a Bordo."*
- Si `delegadas > 0`, incluir una tabla específica con: N° Marea, Buque, Pesquería, Fecha de
  derivación — antes del párrafo aclaratorio.

#### 2.3 Nueva sección "Mareas con Estado Especial"
Agregar sección nueva entre Navegación y Pesquerías (o al final, según criterio editorial):

- **Subsección Canceladas**: párrafo descriptivo + tabla (si `canceladas.length > 0`).
- **Subsección Desestimadas**: párrafo descriptivo + tabla con columna Motivo (si `desestimadas.length > 0`).
- **Subsección Pendientes de Informe**: párrafo descriptivo + tabla (si `pendientes.length > 0`).
- Si todas las listas están vacías: párrafo único: *"No se registraron mareas con estados
  especiales en el período analizado."*

#### 2.4 Nueva sección "Seguimiento de Protocolización"
Agregar al final del documento:

- **KPIs narrativos**: *"De las N mareas del período, X fueron enviadas a la DNI para
  protocolización y Y han sido efectivamente protocolizadas (Z%). La latencia promedio entre
  el fin de la observación y la protocolización fue de P días (máximo Q días)."*
- **Tabla de distribución mensual**: Mes | Enviadas a DNI | Protocolizadas | Acumulado | %
  (solo meses con actividad).
- Si `sinProtocolizar > 0`: nota de alerta.

---

## Arquitectura de Datos — Referencia Rápida

```
getAuditExportWorkbook()               ← Excel builder (stats.service.ts ~2216)
  ├── getDashboardStats()              ← KPIs principales
  ├── getMareaDistribution()           ← etapas por marea
  ├── getDashboardStatsDetail()        ← detalle por marea (incl. fechaZarpada, fechaArribo, etc.)
  ├── getSecondaryObserverStats()  ✅  ← NEW: observadores secundarios
  ├── getAuditSpecialCases()       ✅  ← NEW: canceladas, desestimadas, pendientes, derivadas
  └── getProtocolizationTimeline() ✅  ← NEW: timeline enviadas/protocolizadas

audit-report.builder.ts                ← Word builder (861 líneas)
  ├── buildPersonalSection()           → actualizar con secundarios
  ├── buildNavegacionSection()         → actualizar con DELEGADA_EXTERNA
  ├── [NEW] buildCasosEspecialesSection()
  └── [NEW] buildProtocolizacionSection()
```

### Tipos clave (ya definidos en interfaces)

```typescript
// AuditSpecialMarea — usado en canceladas, desestimadas, pendientes, derivadas
interface AuditSpecialMarea {
    id: string; id_marea: string; buque: string; flota: string;
    pesqueria: string; observador: string; diasNavegados: number;
    fechaEvento: Date | string | null; motivo: string | null;
}

// ProtocolizationTimelineResult
interface ProtocolizationTimelineResult {
    totalProtocolizadas: number; totalEnviadas: number;
    totalEnPeriodo: number; sinProtocolizar: number;
    promedioDiasLatencia: number | null; maxDiasLatencia: number | null;
    distribucionMensual: ProtocolizationMonthItem[];  // { mes, label, cantidad, enviadas, acumulado, pctDelTotal }
}

// ObserverSecondaryStats
interface ObserverSecondaryStats {
    observadorId: string; etapasComoSecundario: number;
}
```

---

## Notas de Negocio Importantes

- **DELEGADA_EXTERNA**: las mareas derivadas a proyectos externos **sí deben aparecer** en el
  listado de navegación (con badge ámbar). La demora en el informe es responsabilidad del proyecto
  externo, NO del Proyecto OaB. Esto debe quedar explícito tanto en la UI como en Word y Excel.

- **DESESTIMADA vs CANCELADA**: semánticamente distintas.
  - `CANCELADA`: la marea fue planificada pero nunca se ejecutó.
  - `DESESTIMADA`: la marea se ejecutó pero sus datos son descartados por algún motivo (indicado
    en el campo `motivo` del movimiento que originó el cambio de estado).

- **Pesquería es siempre la dimensión primaria**; Flota es subordinada. Los ejemplos de auditoría
  en Excel de años anteriores mezclaban estos términos — la interpretación correcta es la indicada.

- **Muestreo Biológico**: omitido deliberadamente. El módulo de importación/validación de datos
  biológicos aún no está implementado. Se incorporará en una iteración futura.

---

## Checklist de Verificación antes de Cerrar la Feature

- [x] UI aprobada por el usuario (condición para iniciar reportes).
- [x] Hoja Excel "Personal" con columna Etapas Secundarias + tabla breakdown Obs/Téc.
- [x] Hoja Excel "Navegación" con Zarpada/Arribo, 3 columnas de protocolización y marcado de Derivadas.
- [x] Nueva hoja Excel "Casos Especiales" con 5 secciones (incluye Esperando Protocolización).
- [x] Nueva hoja Excel "Protocolización" con KPIs + tabla mensual.
- [x] Hoja Excel "Pesquerías" con columna "Cant. Etapas" en tabla de resumen.
- [x] Word: sección Personal actualizada con tabla breakdown Obs/Téc, párrafo de secundarios y columna Etapas Sec.
- [x] Word: sección Navegación con tabla y nota de Derivadas (subsección 5.2).
- [x] Word: nueva sección 7 "Mareas con Estado Especial" (4 subsecciones dinámicas).
- [x] Word: nueva sección 8 "Seguimiento de Protocolización" con narrativa + tabla mensual.
- [x] Word: sección 9 "Observaciones Complementarias" renumerada correctamente.
- [ ] PR a `develop` creado y revisado.
- [ ] `package.json` versionado (ya en `0.5.0`).
