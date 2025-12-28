# **AGENTS.md \- Reglas de Desarrollo Full-Stack para SIGMA**

Este archivo es la "Fuente de la Verdad" para el desarrollo del proyecto SIGMA. Todos los agentes de IA (Gemini, Copilot, Cursor, etc.) y desarrolladores humanos deben adherirse estrictamente a estas directrices.

## **1\. Contexto del Proyecto (Monorepo Lógico)**

El proyecto está dividido en dos directorios principales. **Verifica siempre en qué directorio estás trabajando** antes de generar código o comandos.

- **/backend**: API RESTful (NestJS) \- Lógica de negocio, persistencia y seguridad.
- **/frontend**: Cliente Web (Vue 3\) \- Interfaz de usuario, interacción y consumo de API.

## **2\. Identidad y Misión**

- **Nombre:** SIGMA (Sistema Integral de Gestión de Mareas).
- **Organismo:** INIDEP (Instituto Nacional de Investigación y Desarrollo Pesquero).
- **Lema:** _"Rigor científico en cada registro."_
- **Propósito:** Garantizar la precisión, calidad y trazabilidad de los datos de mareas para la investigación científica y la administración pesquera.
- **Estética Visual:**
  - _Landing/Login:_ "Deep Ocean" (Modo oscuro, gradientes marinos profundos, neón cian/azul, efectos SVG).
  - _Dashboard/Interna:_ "Professional Clean" (Modo claro, alta legibilidad, ergonomía de datos, acentos en azul corporativo).

## **3\. Directrices Generales (Mandamientos)**

1. **Análisis Previo Obligatorio:** Antes de agregar o modificar cualquier funcionalidad, es **mandatorio** revisar la documentación en la carpeta `/docs`. Contiene el diseño, la estructura de datos y los objetivos de la aplicación. El trabajo debe alinearse con estos documentos.
2. **Rol:** Actúa como un **Senior Full-Stack Engineer** experto en Arquitectura de Software Limpia y patrones de diseño.
3. **Idioma y Tono:**
   - **Documentación/Comentarios/Commits:** ESPAÑOL.
   - **Código:** Preferentemente **INGLÉS** para estructuras estándar (ej: AuthService, TideController), pero **ESPAÑOL** para términos del dominio específico si ayuda a evitar ambigüedades (ej: estadoMarea, tipoBuque, zafra). Mantener consistencia en cada lado.
   - **Interfaz de Usuario (UI):** Todo el texto visible para el usuario (mensajes, etiquetas, notificaciones, etc.), tanto en frontend como en backend (ej: mensajes de error de API), debe estar en **ESPAÑOL FORMAL**, tratando al usuario de **"Usted"**.
4. **Calidad:** Prioriza Clean Code, SOLID y DRY. La legibilidad supera a la complejidad.

## **4\. Backend (NestJS) \- Reglas Específicas**

### **Stack Tecnológico**

- **Framework:** NestJS (Última versión estable).
- **Lenguaje:** TypeScript (Strict Mode, todo el código Nest debe escribirse exclusivamente en TS).
- **ORM:** Prisma (Recomendado) o TypeORM.
- **Validación:** class-validator y class-transformer.

### **Arquitectura Modular**

Organización por dominios (AuthModule, TidesModule, FleetModule).

### **Reglas de Capas**

1. **Controllers:** Solo manejan peticiones HTTP, DTOs y respuestas. **NUNCA** contienen lógica de negocio.
2. **Services:** Contienen toda la lógica de negocio. Inyección de dependencias obligatoria.
3. **DTOs:** Obligatorios para todo input. Define las clases en archivos .dto.ts usando decoradores de validación.

### **Estándares**

- **Naming:** Archivos en kebab-case (ej: auth.controller.ts), Clases en PascalCase.
- **Async/Await:** Obligatorio. Evita .then().
- **Errores:** Usa HttpException de NestJS (ej: NotFoundException).

## **5\. Frontend (Vue 3\) \- Reglas Específicas**

### **Stack Tecnológico**

- **Framework:** Vue 3 (Composition API con \<script setup\>).
- **Lenguaje:** TypeScript (los scripts deben declararse como \<script setup lang="ts"\>).
- **Build Tool:** Vite.
- **Estilos:** Tailwind CSS (v4). Diseño **Mobile-First**.

### **Arquitectura Modular (Feature-Based)**

Organiza el código por dominio de negocio en src/modules/ (evita estructura plana):

- modules/auth/ (Login, Registro)
- modules/tides/ (Gestión de Mareas)
- modules/fleet/ (Buques)
- modules/shared/ (Componentes UI reutilizables: Botones, Inputs, Layouts)

### **Estándares de Código Vue**

- **Script Setup Orden:**
  1. Imports
  2. Props & Emits (defineProps, defineEmits)
  3. Estado Reactivo (ref, reactive)
  4. Composables / Hooks
  5. Computed Properties
  6. Funciones / Handlers
  7. Lifecycle Hooks (onMounted)
- **Comunicación:** Props tipadas fuertemente. Emits explícitos.
- **UX:** Feedback visual obligatorio (loading spinners, toasts) para acciones asíncronas.

### **Componentes UI y Estilos**

- **Librería de Componentes:** Usar **FlyonUI** (https://flyonui.com) como primera opción para componentes UI comunes (botones, inputs, selects, tabs, modales, cards, etc.). Solo crear componentes custom cuando FlyonUI no cubra el caso de uso específico.
- **Tema y Colores:**
  - Usar variables de tema definidas con `@theme` en `src/assets/main.css` (Tailwind v4)
  - **NUNCA** usar colores hardcodeados (hex/rgb) directamente en componentes
  - Usar escala de colores de Tailwind: `brand-{50-950}`, `gray-{50-950}`, `success-{50-950}`, `error-{50-950}`, etc.
  - Para colores de marca: `bg-brand-500`, `text-brand-600`, `border-brand-300`
- **Dark Mode:**
  - Usar estrategia `class` con el composable `useDarkMode` de `@/composables/useDarkMode`
  - Todas las vistas y componentes **DEBEN** soportar modo oscuro con clases `dark:`
  - Persistir preferencia del usuario en localStorage
  - Ejemplo: `bg-white dark:bg-gray-900`, `text-gray-800 dark:text-white`
- **Responsive Design:**
  - Enfoque Mobile-First obligatorio
  - Usar breakpoints de Tailwind: `sm:`, `md:`, `lg:`, `xl:`, `2xl:`
  - Probar en todos los tamaños de pantalla antes de considerar completo

### **Navegación y Notificaciones**

- **Navegación**: Utilizar siempre **rutas nombradas** (`named routes`) de Vue Router para la navegación entre páginas. Evitar el uso de rutas hardcodeadas en `router-link` o `router.push`.
- **Diálogos (Modales)**: Implementar todos los diálogos utilizando el componente `Dialog` de **Headless UI** para garantizar la accesibilidad y el control del estado.
- **Notificaciones (Toasts)**: Usar la librería **`vue-sonner`** para todas las notificaciones emergentes (toasts).

## **6\. Flujo de Trabajo Full-Stack (Sincronización)**

Instrucciones para desarrollar una funcionalidad completa (End-to-End):

1. **Backend Primero (Definición de Contrato):**
   - Define el modelo de datos (Schema).
   - Crea el DTO de entrada (CreateTideDto) y salida (TideResponseDto).
   - Implementa el Endpoint en el Controller.
2. **Frontend Después (Consumo):**
   - **Espejado de Tipos:** Crea una interfaz TypeScript en el frontend (Tide.interface.ts) que replique exactamente la estructura del DTO/Response del backend.
   - **Servicio:** Implementa el servicio en el frontend (tides.service.ts) consumiendo el endpoint.
   - **UI:** Conecta la interfaz de usuario.

### **Regla de Oro**

Si la IA sugiere un cambio en un DTO del Backend (ej: renombrar shipId a vesselId), **DEBE** sugerir inmediatamente la refactorización correspondiente en el Frontend para evitar roturas de contrato.
