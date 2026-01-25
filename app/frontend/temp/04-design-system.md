# Sistema de Diseño y Temas Dinámicos

Este documento explica cómo funciona el sistema de estilos de la aplicación y cómo crear nuevos componentes que soporten el cambio dinámico de temas (color, tipografía y formas).

## 1. Arquitectura de Estilos (Tailwind v4)

Utilizamos el nuevo paradigma de **Tailwind v4**, donde la configuración del tema reside directamente en el CSS (`main.css`) mediante la directiva `@theme`.

### Abstracción Semántica
En lugar de usar valores directos (ej: `text-blue-500`), utilizamos **tokens semánticos**. Esto permite que el valor real del token cambie según el tema activo sin modificar el componente.

```css
@theme {
  --color-primary: #2563eb;    /* Token Semántico */
  --font-sans: "Inter", ...;   /* Token de Tipografía */
}
```

## 2. Cómo Aplicar Estilos a Componentes

Para que un componente sea compatible con el sistema de temas, **SIEMPRE** debes usar las variables semánticas o las utilidades de Tailwind vinculadas a ellas.

### Reglas de Oro
- **Color Primario:** Usa `bg-primary`, `text-primary`, `border-primary` o `primary/10` para transparencias.
- **Tipografía:** Usa las clases estándar de Tailwind (`text-base`, `font-bold`). El sistema cambiará la fuente subyacente automáticamente (`Inter` vs `Merriweather` vs `Quicksand`).
- **Radios (Bordes):** Usa utilidades como `rounded-lg`, `rounded-xl`. El tema **Naranja** sobrescribe estos valores para hacerlos más redondos.

### Ejemplo de Componente Compatible
```vue
<template>
  <!-- USAR: rounded-2xl (dinámico), bg-surface (semántico), border-border (semántico) -->
  <div class="p-6 rounded-2xl bg-surface border border-border shadow-sm">
    <!-- USAR: text-primary (dinámico según tema) -->
    <h3 class="text-xl font-bold text-primary mb-2">Título del Card</h3>
    
    <p class="text-text-muted">Texto descriptivo con color atenuado.</p>
    
    <!-- USAR: bg-primary (dinámico), text-primary-fg (contraste dinámico) -->
    <button class="mt-4 px-6 py-2 bg-primary text-primary-fg rounded-lg hover:opacity-90">
      Acción
    </button>
  </div>
</template>
```

## 3. Funcionamiento de los Temas

El cambio de tema se basa en la cascada de CSS y clases en el elemento raíz (`<html>` o `<body>`).

### Mecanismos de Cambio
1. **Color y Tipografía:** Clases como `.theme-green` o `.theme-orange` sobrescriben las variables `--color-primary` y `--font-sans`.
2. **Personalidad (Bordes):** El tema naranja sobrescribe los tokens de radio (`--radius-lg`, etc.).
3. **Dark Mode:** La clase `.dark` se combina con las de tema para ajustar el contraste.

### Cascada de Ejemplo (Verde Formal)
```css
.theme-green {
  --color-primary: #10b981;    /* Cambia color */
  --font-sans: var(--font-serif); /* Cambia fuente global a Serif */
}
```

## 4. Guía de Tokens Disponibles

| Token | Propósito | Comportamiento Dinámico |
| :--- | :--- | :--- |
| `--color-primary` | Color de acento principal | Cambia según tema y Dark Mode. |
| `--font-sans` | Fuente principal de la app | Cambia entre Sans (Base), Serif (Verde) y Fun (Naranja). |
| `--radius-*` | Radios de bordes | Se vuelven más pronunciados en el tema Naranja. |
| `--color-surface` | Fondo de cards/contenedores | Cambia según Dark Mode. |
| `--color-text` | Color de texto principal | Cambia según Dark Mode. |

## 5. Mejores Prácticas para Desarrolladores

1. **No Hardcodear Colores:** Evita `text-slate-900` o `bg-emerald-500` a menos que sea un diseño que NO deba cambiar con el tema.
2. **Usa Transparencias del Token:** Tailwind v4 permite `bg-primary/20` para crear variaciones sutiles que mantienen la armonía del tema.
3. **Verifica en UI Guide:** Siempre prueba tus nuevos componentes en la [**Guía de Estilos**](/ui-demo) cambiando entre temas y modos (claro/oscuro).

## 6. Portabilidad a otros Proyectos (Checklist)

Si deseas replicar este sistema en una nueva aplicación, sigue estos 3 pasos:

### 1. Requisitos Técnicos
- **Tailwind CSS v4:** El proyecto destino debe usar la versión 4 para interpretar la directiva `@theme`.
- **Plugin de Vite:** Asegúrate de tener `@tailwindcss/vite` instalado y activo en el nuevo proyecto.

### 2. Archivos a Copiar
- **CSS:** Copia el contenido de `main.css` (asegura las importaciones de fuentes).
- **Lógica (Store):** Copia el store de temas (`themeStore`). Es vital para la reactividad.

### 3. Integración en el Root
En el componente principal (`App.vue` o similar) del nuevo proyecto, añade la lógica de inicialización en el `setup`:

```typescript
// Al montar la app, aplicar clase de color guardada
const theme = localStorage.getItem('primary-color') || 'blue';
if (theme !== 'blue') {
  document.documentElement.classList.add(`theme-${theme}`);
}
```

---
*Este sistema garantiza que la aplicación pueda cambiar de "personalidad" por completo simplemente cambiando una clase en el motor de renderizado.*
