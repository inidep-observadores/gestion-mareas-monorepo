# **AGENTS.md \- Contexto y Reglas de Desarrollo para SIGMA**

Este archivo contiene las directrices obligatorias para cualquier Agente de IA o desarrollador que genere o modifique código en este proyecto.

## **1\. Identidad del Proyecto**

* **Nombre:** SIGMA (Sistema Integral de Gestión de Mareas).  
* **Descripción:** Plataforma de gestión logística y operativa para buques pesqueros y mareas.  
* **Estética:**  
  * *Landing/Login:* "Deep Ocean" (Modo oscuro, gradientes marinos, neón, efectos SVG).  
  * *Dashboard/Interna:* "Professional Clean" (Modo claro, alta legibilidad, acentos en azul corporativo).

## **2\. Directrices Generales (Mandamientos)**

1. **Idioma:** TODO el texto, comentarios, documentación y mensajes de commit deben estar estrictamente en **ESPAÑOL**.  
   * *Excepción:* Nombres de variables y funciones en código pueden estar en inglés (estándar de la industria) o español, pero se debe mantener la consistencia.  
2. **Rol:** Actúa como un **Senior Frontend Engineer** experto en Vue 3 y Arquitectura de Software.  
3. **Calidad:** Prioriza la legibilidad, el desacoplamiento y la escalabilidad. Aplica principios SOLID y Clean Code rigurosamente.

## **3\. Stack Tecnológico**

* **Framework:** Vue 3 (Composition API con \<script setup\>).  
* **Build Tool:** Vite.  
* **Estilos:** Tailwind CSS (Versión 4+).  
  * Diseño **Mobile-First**.  
  * Uso de @apply restringido. Preferir clases utilitarias en el template.  
* **Iconos:** Heroicons (SVG inline o librería).

## **4\. Arquitectura Modular (Feature-Based)**

Para evitar el caos a medida que el proyecto escala, **NO** uses una estructura plana. Utiliza una arquitectura basada en **Módulos de Negocio**.

### **Estructura de Directorios Obligatoria:**

src/  
├── modules/                  \# Módulos de Negocio (Features)  
│   ├── auth/                 \# Ejemplo: Módulo de Autenticación  
│   │   ├── components/       \# Componentes exclusivos de este módulo (LoginForm.vue)  
│   │   ├── views/            \# Páginas/Vistas del módulo (LoginView.vue)  
│   │   ├── composables/      \# Lógica de negocio (useAuth.js)  
│   │   ├── services/         \# Llamadas a API (authService.js)  
│   │   └── routes.js         \# Definición de rutas del módulo  
│   │  
│   ├── tides/                \# Ejemplo: Módulo de Mareas  
│   │   ├── components/  
│   │   ├── models/           \# Definiciones de tipos/interfaces (si aplica)  
│   │   └── ...  
│   │  
│   └── fleet/                \# Ejemplo: Módulo de Flota  
│  
├── shared/                   \# Código compartido y UI Kit (Core)  
│   ├── components/           \# Componentes UI reutilizables (Botones, Tablas, Modales)  
│   ├── layouts/              \# Layouts de la app (MainLayout.vue, AuthLayout.vue)  
│   ├── services/             \# Servicios HTTP base (Axios config)  
│   └── utils/                \# Funciones helpers puras (formatDate, currency)  
│  
├── assets/                   \# Estilos globales, imágenes, fuentes  
└── main.js                   \# Punto de entrada

### **Reglas de Dependencia:**

* Un **Módulo** puede depender de shared.  
* Un **Módulo** idealmente **NO** debería depender de otro módulo hermano (bajo acoplamiento). Si dos módulos comparten mucha lógica, esa lógica debe moverse a shared.  
* shared **NUNCA** debe depender de un módulo específico.

## **5\. Estándares de Código Vue 3**

### **Script Setup**

* Usa siempre \<script setup\>.  
* No uses Options API (data, methods).  
* Orden del bloque script:  
  1. Imports.  
  2. Props & Emits.  
  3. Estado Reactivo (ref, reactive).  
  4. Composables / Hooks.  
  5. Computed Properties.  
  6. Funciones / Handlers.  
  7. Lifecycle Hooks (onMounted).

### **Comunicación de Componentes**

* **Props:** Tipadas fuertemente. Usa valores por defecto cuando aplique.  
* **Emits:** Define siempre los eventos que el componente emite (defineEmits).  
* **Estado Global:** Si el estado debe compartirse entre múltiples vistas, usa un Composable global o Pinia (si se integra más adelante), no provide/inject excesivo.

## **6\. Manejo de Errores y UI**

* Nunca dejes un bloque try/catch vacío o con un simple console.log.  
* Implementa feedback visual para el usuario (spinners de carga, notificaciones toast, estados de error en inputs).  
* En formularios, maneja validaciones y estados de "loading" para evitar dobles envíos.

## **7\. Instrucciones para Generación de Código**

Cuando se te pida crear una nueva funcionalidad:

1. **Categoriza:** Determina a qué módulo pertenece (o si es uno nuevo).  
2. **Modulariza:** Crea los archivos dentro de la carpeta src/modules/{feature}/.  
3. **Reutiliza:** Si necesitas un botón o input, verifica si ya existe en src/shared/components antes de crear uno nuevo.  
4. **Genera:** Entrega el código completo y explica brevemente la ubicación del archivo según la arquitectura modular.
