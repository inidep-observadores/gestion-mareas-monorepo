---
name: vuejs-apex-charts
description: |
  Integración de ApexCharts para Vue 3 usando vue3-apexcharts para visualización de datos.
  CUÁNDO: Al crear gráficos en Vue 3 (líneas, barras, circular, donut, radar, mapa de calor), construir tableros, actualizaciones de gráficos en tiempo real, integración de datos de API con gráficos.
  CUÁNDO NO: Proyectos que no sean de Vue, otras bibliotecas de gráficos (Chart.js, D3), desarrollo general de Vue (usa vuejs-dev).
---

# Vue 3 ApexCharts

Guía completa para usar ApexCharts en Vue 3 usando vue3-apexcharts.

## Instalación

```bash
npm install apexcharts vue3-apexcharts
```

## Configuración

### Registro Global (Recomendado)

```javascript
// main.js
import { createApp } from 'vue'
import VueApexCharts from 'vue3-apexcharts'
import App from './App.vue'

const app = createApp(App)
app.use(VueApexCharts)
app.mount('#app')
```

## Propios del Componente

| Prop | Tipo | Por defecto | Descripción |
|------|------|---------|-------------|
| `type` | String | 'line' | Tipo de gráfico (obligatorio) |
| `series` | Array | [] | Series de datos (obligatorio) |
| `options` | Object | {} | Configuración del gráfico |
| `width` | String/Number | '100%' | Ancho del gráfico |
| `height` | String/Number | 'auto' | Alto del gráfico |

## Referencia Rápida de Tipos de Gráfico

| Tipo | Valor | Caso de Uso |
|------|-------|----------|
| Línea | `line` | Tendencias a lo largo del tiempo |
| Área | `area` | Datos de volumen/acumulativos |
| Barra | `bar` | Comparaciones horizontales |
| Columna | `bar` + vertical | Comparaciones verticales |
| Circular | `pie` | Parte del todo (pocos elementos) |
| Donut | `donut` | Parte del todo con centro |
| Radar | `radar` | Comparación multivariable |
| Calor | `heatmap` | Datos de matriz/densidad |
