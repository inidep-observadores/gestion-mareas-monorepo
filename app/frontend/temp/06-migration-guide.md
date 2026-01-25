# Guía de Migración: De Estilos Hardcodeados a Tokens Semánticos

Esta guía detalla el proceso para transformar componentes con estilos rígidos (colores y fuentes fijas) al sistema de **Temas Dinámicos** del Dashboard Starter.

## 1. El Problema de los Estilos Hardcodeados

Un componente "hardcodeado" utiliza clases de utilidad directas de Tailwind que no pueden mutar. 
**Ejemplo:** `text-blue-600` siempre será azul, incluso si el usuario selecciona el tema "Naranja".

## 2. Tabla de Mapeo (Refactorización)

Para migrar, identifica la intención del estilo y reemplázalo por su equivalente semántico:

| Tipo | Estilo Hardcodeado (Ejemplo) | Reemplazo Semántico |
| :--- | :--- | :--- |
| **Color Acento** | `bg-blue-600`, `text-emerald-500` | `bg-primary`, `text-primary` |
| **Color Fondo** | `bg-white`, `bg-slate-50` | `bg-surface`, `bg-background` |
| **Bordes** | `border-gray-200`, `border-slate-800` | `border-border` |
| **Texto** | `text-gray-900`, `text-slate-100` | `text-text` |
| **Texto Tenue** | `text-gray-500`, `text-slate-400` | `text-text-muted` |
| **Radios** | `rounded-md`, `rounded-full` | `rounded-lg`, `rounded-xl` (dinámicos) |

## 3. Proceso de Migración paso a paso

### Paso 1: Auditoría Visual
Identifica qué elementos del componente representan la "identidad" de la marca (colores principales, tipografía y bordes).

### Paso 2: Reemplazo de Colores de Acento
Busca todas las instancias de colores específicos y cámbialas por `primary`.
- **Antes:** `hover:bg-blue-700`
- **Después:** `hover:opacity-90` (mejor práctica para mantener el tono del tema actual).

### Paso 3: Abstracción de Tipografía
Elimina utilidades de fuentes específicas como `font-sans` o `font-serif` si están forzadas. Deja que el sistema herede `--font-sans` desde el body.

### Paso 4: Adaptación a Dark Mode
Asegúrate de eliminar prefijos `dark:bg-slate-900` si ya estás usando `bg-surface`, ya que `bg-surface` cambia automáticamente mediante variables CSS en el archivo `main.css`.

## 4. Ejemplo Práctico: Refactorización de un Botón

### Antes (Rígido)
```vue
<button class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded shadow-lg dark:bg-blue-700">
  Confirmar
</button>
```
*Problema:* No cambia a verde, la fuente es siempre la misma, los bordes son pequeños incluso en temas "fun".

### Después (Semántico/Dinámico)
```vue
<button class="bg-primary text-primary-fg font-bold py-2 px-5 rounded-lg shadow-sm hover:opacity-90 transition-all">
  Confirmar
</button>
```
*Resultado:* Cambia color, fuente y redondez de forma automática al cambiar de tema.

## 5. Estrategia de Migración para Toda una App

Si estás migrando una aplicación completa, sigue este orden:

1. **Global CSS:** Define tus tokens en `@theme` dentro de `main.css`.
2. **Componentes Base:** Migra primero `Button`, `Input` y `Card`. Esto tendrá el mayor impacto inmediato.
3. **Layouts:** Actualiza el `Sidebar` y `Topbar`.
4. **Vistas de Contenido:** Migra gradualmente las páginas de negocio.

## 6. Verificación de la Migración

Una migración exitosa se confirma cuando:
1. El componente se ve bien en **Light Mode** y **Dark Mode** sin usar (o usando muy poco) el prefijo `dark:`.
2. El componente **cambia completamente de estilo** cuando vas a la UI Demo y alternas entre los temas "Formal" (Verde) e "Informal" (Naranja).
3. No hay clases de colores específicos (ej: `slate`, `zinc`, `blue`, `green`) en el código del componente.

---
**Nota:** Este sistema no prohíbe colores específicos para estados semánticos universales (ej: `text-red-500` para errores graves), pero anima a usar `primary` para todo lo que defina la "piel" de la aplicación.
