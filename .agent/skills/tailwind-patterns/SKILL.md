---
name: tailwind-patterns
description: "Principios de Tailwind CSS v4 aplicados al proyecto GastosCompartidos. Configuración CSS-first, consultas de contenedor, patrones modernos y arquitectura de tokens de diseño."
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Patrones de Tailwind CSS v4 (GastosCompartidos)

> CSS moderno con prioridad en utilidades y configuración nativa de CSS.

## 🎯 Específico para GastosCompartidos

Este proyecto usa **Tailwind CSS v4** con:
- ✅ Configuración CSS-first mediante `@theme`
- ✅ Plugin `@tailwindcss/vite` integrado
- ✅ Motor Oxide (10x más rápido que v3)
- ✅ Espacio de color OKLCH para mejor consistencia visual
- ✅ Sistema de diseño definido en `apps/frontend/src/style.css`

## 📁 Ubicación de Estilos

```
apps/frontend/
├── src/
│   └── style.css         # ⭐ Configuración global + @theme
├── vite.config.ts        # Plugin de Tailwind configurado
└── NO HAY tailwind.config.js (eliminado en v4)
```

## 1. Arquitectura de Tailwind v4

### Qué cambió respecto a la v3

| v3 (Legado) | v4 (GastosCompartidos) |
|-------------|------------------------|
| `tailwind.config.js` | `@theme` en `style.css` |
| PostCSS plugin | `@tailwindcss/vite` |
| JIT mode opcional | Nativo, siempre activo |
| Plugin system | CSS nativo |
| `@apply` permitido | Funciona, pero se desaconseja |

### Conceptos Core

- **CSS-first**: Configuración en CSS, no en JavaScript
- **Motor Oxide**: Compilador Rust, mucho más rápido
- **Variables CSS**: Todos los tokens como `--*` vars
- **OKLCH**: Espacio de color perceptivamente uniforme

## 2. Sistema de Diseño en GastosCompartidos

### Estructura de `style.css`

```css
@import "tailwindcss";

@theme {
  /* Tokens de diseño del proyecto */
  --color-brand-primary: oklch(0.6 0.25 250);
  --color-brand-secondary: oklch(0.6 0.25 285);
  --radius-card: 1rem;
  --shadow-premium: 0 20px 50px -12px rgba(0, 0, 0, 0.1);
}

@layer base {
  :root {
    /* Variables HSL para compatibilidad */
    --background: 210 40% 98%;
    --foreground: 222 47% 11%;
    --brand-primary: oklch(0.6 0.25 250);
  }

  .dark {
    --background: 224 71% 4%;
    --foreground: 213 31% 91%;
    --brand-primary: oklch(0.7 0.2 250);
  }
}

@layer components {
  .glass-card {
    @apply bg-card/60 backdrop-blur-xl border border-white/20;
  }
}
```

### Tokens Disponibles

#### Colores
```css
/* Marca */
bg-brand                  /* Color principal de la marca */
bg-brand-primary          /* Azul sofisticado */
bg-brand-secondary        /* Violeta */
bg-brand-accent           /* Cian */

/* Semánticos */
bg-background             /* Fondo principal */
text-foreground           /* Texto principal */
bg-card                   /* Fondo de tarjetas */
border-border             /* Bordes */
bg-muted                  /* Fondos desactivados */
text-muted-foreground     /* Texto secundario */

/* Interacción */
bg-secondary              /* Botones secundarios */
hover:bg-accent           /* Estados hover */
focus-visible:ring-ring   /* Anillos de enfoque */
```

#### Espaciado y Forma
```css
/* Radius personalizado */
rounded-2xl      /* 1rem */
rounded-3xl      /* 1.5rem */
rounded-subtle   /* 0.75rem */

/* Sombras premium */
shadow-premium        /* Sombra elevada elegante */
shadow-premium-hover  /* Sombra al hacer hover */
shadow-glass          /* Efecto glassmorfismo */
```

## 3. Patrones de Uso en Componentes

### ✅ Componentes de Tarjeta

```vue
<template>
  <!-- CORRECTO: Uso de tokens del sistema de diseño -->
  <div class="bg-card rounded-2xl p-6 shadow-premium border border-border">
    <h3 class="text-foreground font-semibold text-lg">Título</h3>
    <p class="text-muted-foreground text-sm mt-2">Descripción</p>
  </div>

  <!-- MEJOR: Usar componente del sistema de diseño -->
  <AppCard>
    <template #header>
      <h3 class="font-semibold text-lg">Título</h3>
    </template>
    <p class="text-muted-foreground text-sm">Descripción</p>
  </AppCard>
</template>
```

### ✅ Botones con Estados

```vue
<template>
  <!-- Uso de clases de utilidad con modificadores de opacidad -->
  <button class="
    bg-brand-primary text-brand-primary-foreground
    hover:bg-brand-primary/90
    active:scale-95
    transition-all duration-300
    rounded-lg px-4 py-2
    shadow-premium hover:shadow-premium-hover
  ">
    Guardar Gasto
  </button>

  <!-- MEJOR: Usar AppButton del sistema de diseño -->
  <AppButton variant="solid" size="md">
    Guardar Gasto
  </AppButton>
</template>
```

### ✅ Layouts Responsivos

```vue
<template>
  <!-- Grid responsivo con breakpoints -->
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <ExpenseCard v-for="expense in expenses" :key="expense.id" />
  </div>

  <!-- Flexbox con ajuste automático -->
  <div class="flex flex-col md:flex-row items-start md:items-center gap-4">
    <AppInput v-model="search" class="flex-1" />
    <AppButton>Buscar</AppButton>
  </div>
</template>
```

## 4. Modo Oscuro

### Estrategia: Class-based

```vue
<script setup>
import { useThemeStore } from '@/stores/theme'

const themeStore = useThemeStore()
</script>

<template>
  <!-- Los estilos dark: se activan automáticamente -->
  <div class="bg-background text-foreground dark:bg-background dark:text-foreground">
    <p class="text-zinc-900 dark:text-zinc-100">
      Este texto se adapta al tema
    </p>
  </div>
</template>
```

### Convenciones
- Fondo claro: `bg-white` → Oscuro: `dark:bg-zinc-900`
- Texto claro: `text-zinc-900` → Oscuro: `dark:text-zinc-100`
- Bordes claro: `border-zinc-200` → Oscuro: `dark:border-zinc-700`

## 5. Consultas de Contenedor (v4)

### Cuándo Usar

| Escenario | Usar |
|-----------|------|
| Layout de página completa | Breakpoints (`md:`, `lg:`) |
| Componentes reutilizables | Container queries (`@container`) |
| Diseño responsivo por componente | Container queries |

### Ejemplo con Container Query

```vue
<template>
  <!-- Contenedor padre -->
  <div class="@container">
    <!-- Hijo responde al tamaño del contenedor -->
    <div class="flex flex-col @md:flex-row gap-4">
      <div class="w-full @md:w-1/2">Columna 1</div>
      <div class="w-full @md:w-1/2">Columna 2</div>
    </div>
  </div>
</template>
```

## 6. Sistema de Color OKLCH

### Por qué OKLCH

- ✅ Perceptivamente uniforme (colores se ven consistentes)
- ✅ Mejor que HSL para gradientes suaves
- ✅ Soporte de opacidad nativo en Tailwind v4
- ✅ Mejores colores vibrantes

### Uso en el Proyecto

```css
/* En style.css */
@theme {
  /* Sintaxis: oklch(lightness chroma hue) */
  --color-brand-primary: oklch(0.6 0.25 250);    /* Azul */
  --color-brand-secondary: oklch(0.6 0.25 285);  /* Violeta */
  --color-brand-accent: oklch(0.7 0.2 190);      /* Cian */
}
```

```vue
<!-- En componentes -->
<div class="bg-brand-primary text-brand-primary-foreground">
  <!-- Opacidad funciona automáticamente -->
  <div class="bg-brand-primary/50">Fondo semi-transparente</div>
</div>
```

## 7. Animaciones y Transiciones

### Animaciones Personalizadas (en style.css)

```css
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.animate-float {
  animation: float 6s ease-in-out infinite;
}
```

### Uso en Componentes

```vue
<template>
  <!-- Transiciones suaves -->
  <button class="
    transition-all duration-300
    hover:scale-105 hover:shadow-premium-hover
    active:scale-95
  ">
    Hover me
  </button>

  <!-- Animación personalizada -->
  <div class="animate-float">
    <Icon name="sparkles" />
  </div>
</template>
```

## 8. Mejores Prácticas del Proyecto

### ✅ QUÉ HACER

1. **Usar componentes del sistema de diseño**
   ```vue
   <!-- ✅ BIEN -->
   <AppButton variant="solid">Guardar</AppButton>
   
   <!-- ❌ MAL: Recrear estilos -->
   <button class="bg-brand-primary text-white px-4 py-2...">
     Guardar
   </button>
   ```

2. **Preferir tokens sobre valores arbitrarios**
   ```vue
   <!-- ✅ BIEN -->
   <div class="bg-card text-foreground rounded-2xl p-6">
   
   <!-- ❌ MAL: Valores mágicos -->
   <div class="bg-[#ffffff] text-[#1a1a1a] rounded-[1rem] p-[1.5rem]">
   ```

3. **Usar modificadores de opacidad**
   ```vue
   <!-- ✅ BIEN -->
   <div class="bg-brand-primary/10 hover:bg-brand-primary/20">
   
   <!-- ❌ MAL: Crear nuevos colores -->
   <div class="bg-brand-primary-10 hover:bg-brand-primary-20">
   ```

### ❌ ANTI-PATRONES

1. **No usar `@apply` para todo**
   ```css
   /* ❌ MAL */
   .my-button {
     @apply bg-brand-primary text-white px-4 py-2 rounded-lg;
   }
   
   /* ✅ BIEN: Crear componente Vue */
   <!-- AppButton.vue con props variant/size -->
   ```

2. **No mezclar v3 y v4**
   ```javascript
   // ❌ MAL: Intentar usar tailwind.config.js
   // Ya no existe en este proyecto
   
   // ✅ BIEN: Configurar en style.css
   @theme { --color-custom: oklch(...); }
   ```

3. **No ignorar el modo oscuro**
   ```vue
   <!-- ❌ MAL: Solo estilos claros -->
   <div class="bg-white text-black">
   
   <!-- ✅ BIEN: Considerar ambos temas -->
   <div class="bg-background text-foreground">
   ```

## 9. Debugging de Estilos

### Herramientas de Desarrollo

```bash
# Ver clases generadas por Tailwind
pnpm --filter frontend dev

# Build para ver CSS optimizado
pnpm --filter frontend build
```

### Inspección en DevTools

```html
<!-- Añadir temporalmente para debug -->
<div class="ring-2 ring-red-500">
  <!-- Contenido a debuggear -->
</div>
```

## 10. Recursos

### Documentación Oficial
- [Tailwind CSS v4 Docs](https://tailwindcss.com/docs)
- [OKLCH Color Picker](https://oklch.com)
- [Can I Use: Container Queries](https://caniuse.com/css-container-queries)

### En este Proyecto
- Configuración: [`apps/frontend/src/style.css`](file:///d:/Desarrollo/_PROYECTOS/GastosCompartidos/apps/frontend/src/style.css)
- Componentes UI: [`apps/frontend/src/components/ui/`](file:///d:/Desarrollo/_PROYECTOS/GastosCompartidos/apps/frontend/src/components/ui)
- Vite Config: [`apps/frontend/vite.config.ts`](file:///d:/Desarrollo/_PROYECTOS/GastosCompartidos/apps/frontend/vite.config.ts)

---

> **Recuerda**: Tailwind v4 es CSS-first. La configuración vive en `style.css`, no en archivos JS. Usa tokens del sistema de diseño y evita valores arbitrarios cuando sea posible.
