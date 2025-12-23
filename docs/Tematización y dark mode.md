# **📘 Estándar de Desarrollo: Tematización y Dark Mode**

**Proyecto:** Vue System

**Tecnologías:** Vue 3, Tailwind CSS

**Estrategia:** Tokens Semánticos (CSS Variables)

## **1\. El Problema a Resolver**

Evitar la fragmentación visual y el "infierno de mantenimiento" que ocurre al usar clases utilitarias directas para colores (ej. bg-white dark:bg-gray-900) repetidas en cientos de componentes.

## **2\. La Solución: Tokens Semánticos**

En lugar de asignar colores por su apariencia ("Azul", "Gris"), asignamos colores por su **función** o **intención** ("Fondo Principal", "Texto Primario", "Acento").

Utilizamos variables CSS nativas que cambian su valor automáticamente cuando la clase .dark está presente en el html. Tailwind consume estas variables a través de una configuración personalizada.

## **3\. Implementación Técnica**

### **Paso A: Definición de Variables (CSS Global)**

Archivo: src/assets/base.css (o donde se importen las directivas de Tailwind).

@tailwind base;  
@tailwind components;  
@tailwind utilities;

@layer base {  
  :root {  
    /\* \--- MODO CLARO (Default) \--- \*/  
    \--color-fill: \#ffffff;          /\* Fondo general de la página \*/  
    \--color-surface: \#f3f4f6;       /\* Fondo de tarjetas, sidebars \*/  
    \--color-text-base: \#1f2937;     /\* Texto principal (casi negro) \*/  
    \--color-text-muted: \#6b7280;    /\* Texto secundario (gris) \*/  
    \--color-border: \#e5e7eb;        /\* Líneas divisorias \*/  
    \--color-primary: \#3b82f6;       /\* Color de marca/acción \*/  
    \--color-primary-hover: \#2563eb; /\* Estado hover del primario \*/  
  }

  .dark {  
    /\* \--- MODO OSCURO (Reasignación) \--- \*/  
    \--color-fill: \#0f172a;          /\* Azul muy oscuro (Slate 900\) \*/  
    \--color-surface: \#1e293b;       /\* Slate 800 \*/  
    \--color-text-base: \#f9fafb;     /\* Blanco casi puro \*/  
    \--color-text-muted: \#9ca3af;    /\* Gris claro \*/  
    \--color-border: \#374151;        /\* Gris oscuro para bordes \*/  
    \--color-primary: \#60a5fa;       /\* Azul más brillante para contraste \*/  
    \--color-primary-hover: \#3b82f6;  
  }  
}

### **Paso B: Configuración de Tailwind**

Archivo: tailwind.config.js

Usamos un prefijo (ej. skin) para agrupar nuestros tokens semánticos y evitar colisiones con los colores por defecto de Tailwind.

/\*\* @type {import('tailwindcss').Config} \*/  
module.exports \= {  
  darkMode: 'class', // IMPORTANTE: Control manual mediante clase CSS  
  content: \[  
    "./index.html",  
    "./src/\*\*/\*.{vue,js,ts,jsx,tsx}",  
  \],  
  theme: {  
    extend: {  
      // Extendemos la paleta de colores usando las variables CSS  
      colors: {  
        skin: {  
          fill: 'var(--color-fill)',  
          surface: 'var(--color-surface)',  
          text: 'var(--color-text-base)',  
          muted: 'var(--color-text-muted)',  
          border: 'var(--color-border)',  
          primary: 'var(--color-primary)',  
          'primary-hover': 'var(--color-primary-hover)',  
        }  
      }  
    },  
  },  
  plugins: \[\],  
}

## **4\. Guía de Uso para Desarrolladores**

### **🚫 Lo que NO debes hacer (Hardcoding)**

Evita usar modificadores dark: para colores estructurales. Esto hace que cambiar el tema requiera editar cada archivo .vue.

\<\!-- MAL: Difícil de mantener y leer \--\>  
\<div class="bg-white border-gray-200 text-gray-900 dark:bg-slate-800 dark:border-slate-700 dark:text-white border p-4 rounded"\>  
  \<p\>Hola mundo\</p\>  
\</div\>

### **✅ Lo que SÍ debes hacer (Uso Semántico)**

Usa las clases skin-\*. El componente no sabe si está en modo oscuro o claro, solo sabe que usa el color de "superficie".

\<\!-- BIEN: Limpio, semántico y automático \--\>  
\<div class="bg-skin-surface border-skin-border text-skin-text border p-4 rounded"\>  
  \<p\>Hola mundo\</p\>  
\</div\>

### **Ejemplos Comunes**

| Elemento UI | Clase recomendada |
| :---- | :---- |
| Fondo de Pantalla | bg-skin-fill |
| Cards / Paneles | bg-skin-surface |
| Texto de Párrafo | text-skin-text |
| Etiquetas / Metadatos | text-skin-muted |
| Bordes / Separadores | border-skin-border |
| Botón Primario | bg-skin-primary hover:bg-skin-primary-hover |

## **5\. Proceso para agregar nuevos colores**

Si el diseño requiere un nuevo color semántico (ej. "Danger" para errores):

1. **CSS:** Ve a base.css y agrega \--color-danger en :root (rojo oscuro/normal) y en .dark (rojo claro/brillante).  
2. **Config:** Ve a tailwind.config.js y agrégalo al objeto skin: danger: 'var(--color-danger)'.  
3. **Uso:** Ya puedes usar text-skin-danger o bg-skin-danger en tus componentes.

## **6\. Lógica de Cambio de Tema (Snippet)**

Para el componente que controla el switch (ej. ThemeToggle.vue), utilizamos la lógica de añadir/quitar la clase dark al elemento \<html\>.

// Ejemplo simplificado de lógica en Vue  
const toggleTheme \= () \=\> {  
  const html \= document.documentElement;  
  if (html.classList.contains('dark')) {  
    html.classList.remove('dark');  
    localStorage.setItem('theme', 'light');  
  } else {  
    html.classList.add('dark');  
    localStorage.setItem('theme', 'dark');  
  }  
};  
