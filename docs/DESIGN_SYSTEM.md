# Sistema de Diseño - Gestión de Mareas OBS

Este documento detalla los estándares de diseño y estética de la aplicación Gestión de Mareas. Todos los futuros módulos y componentes deben adherirse a estas guías para garantizar una experiencia de usuario coherente y premium.

## 1. Iconografía

El set de iconos oficial es **Google Material Symbols** (serie **Rounded** preferentemente, u **Outline** como alternativa).

### Estándar de Implementación
Todos los iconos deben envolverse en un componente Vue en `src/icons/` siguiendo este estándar:
- **ViewBox**: `0 -960 960 960` (estándar oficial de Material Symbols).
- **Dimensiones**: `width="24" height="24"`.
- **Color**: `fill="currentColor"` para que hereden el color del texto del contenedor.
- **Peso de Trazo**: Default (equivalente a 400).

```vue
<template>
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 -960 960 960" fill="currentColor">
    <path d="...path data..."/>
  </svg>
</template>
```

## 2. Tipografía y Colores

### Tipografía
- **Fuente Principal**: [Outfit](https://fonts.google.com/specimen/Outfit) (Google Fonts).
- **Tamaño Base**: `text-sm` (14px) para controles, tablas y navegación.
- **Títulos**: `text-lg` o `text-xl` con `font-bold`.

### Colores Principales (CSS Variables)
- **Brand (Primario)**: `#465fff` (`brand-500`)
- **Success**: `#12b76a` (`success-500`)
- **Error/Destructive**: `#f04438` (`error-500`)
- **Warning**: `#f79009` (`warning-500`)
- **Fondo General**: `#f9fafb` (`gray-50`) en Light Mode.

## 3. Controles de Formulario

### Inputs y Selects
Para mantener la estética "Sober and Readable":
- **Bordes**: `border-gray-100` (`dark:border-gray-800`), `rounded-lg` (8px).
- **Relleno**: `bg-gray-50/50` (`dark:bg-gray-900/50`).
- **Estados**: 
    - Focus: `focus:border-brand-500` con `outline-none`.
    - Error: `border-red-500 bg-red-50/30`.

### Botones
- **Primarios**: `bg-brand-500 text-white hover:bg-brand-600 rounded-lg px-4 py-2.5 text-sm font-medium`.
- **Secundarios/Ghost**: `text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg`.

## 4. Gestión de Temas (Claro/Oscuro)

La aplicación utiliza la clase `.dark` en el elemento raíz para el modo oscuro.
- Siempre utilizar variantes de Tailwind `dark:` para colores de fondo, texto y bordes.
- Fondos oscuros preferidos: `bg-gray-950` para contenedores principales, `bg-gray-900` para controles.
- Texto oscuro: `text-gray-300` o `text-white`.

## 5. Sistema de Listas y Tablas

### Tablas de Datos
- **Cabecera**: `bg-gray-50 dark:bg-gray-900/50`, texto `uppercase`, `tracking-wider`, `text-xs`.
- **Filas**: `border-b border-gray-100 dark:border-gray-800`, hover con `bg-gray-50/50 dark:bg-white/5`.
- **Acciones**: Ubicadas a la derecha, utilizando botones de icono `p-2 rounded-lg`.

## 6. Componentes Personalizados

### SearchableSelect
Utilizado para combos de búsqueda pesados (Buques, Pesquerías). Debe incluir navegación por teclado (flechas) y búsqueda en tiempo real.

### DatePicker
Componente custom que permite entrada manual con máscara `DD/MM/YYYY` y selector visual. No utilizar librerías externas de terceros (como Flatpickr) para mantener el control total del build.

## 7. Sistema de Edición y Modales

### Modales (BaseModal)
- **Ancho**: Preferentemente `maxWidth="2xl"` para formularios estándar.
- **Header**: Título claro y botón de cierre (`X`) consistente.
- **Acciones**: Botones de acción (Guardar/Cancelar) alineados en la parte inferior, preferentemente usando un grid responsivo: `sm:grid sm:grid-cols-2 sm:gap-3`.

### Formularios
- **Label**: `block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5`.
- **Estructura**: `form` con `space-y-4` para separación uniforme de campos.
- **Validación**: Feedback inmediato mediante estilos de borde rojo y notificaciones (Vue Sonner).

### Protección de Datos (Navegación)
En formularios de edición o creación (vistas o modales), si existen cambios sin guardar, se **debe** interceptar el intento de salida o cancelación ("Volver", cierre de modal, navegación atrás).
- **Diálogo de Confirmación**: Mostrar un diálogo de confirmación (`ConfirmationDialog`) antes de abandonar la vista para evitar la pérdida accidental de datos.


## 8. Espaciado y Layout
- **Gaps**: Utilizar preferentemente `gap-4` o `gap-6` para separación de controles en formularios.
- **Páginas**: Padding uniforme de `p-6` en el contenedor principal del dashboard.
- **Card/Modales**: `rounded-xl` o `rounded-2xl` con `shadow-xl`.

## 9. Estilos de Fichas (Cards)

Para las fichas principales del dashboard (KPIs, estadísticas), utilizamos un estilo distintivo con borde izquierdo coloreado para reforzar el contexto visual de cada sección.

### Patrón de Borde Izquierdo
- **Clase Base**: `border-l-4` + `border-l-{color}`.
- **Colores de Contexto**:
    - **Azul (`blue-500`)**: Flota y Distribución.
    - **Índigo (`indigo-500`)**: Personal y Recursos Humanos.
    - **Esmeralda (`emerald-500`)**: Vencimientos y Próximos Arribos.
    - **Rosa (`rose-500`)**: Alertas Críticas.
    - **Naranja (`orange-500`)**: Métricas de Inactividad (Top Dry) o Advertencias.

Ejemplo en Vue:
```html
<div class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm border-l-4 border-l-orange-500">
  <!-- Contenido -->
</div>
```
