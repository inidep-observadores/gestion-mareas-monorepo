# Guía de Desarrollo y Buenas Prácticas

Este documento establece los estándares de arquitectura y desarrollo para el proyecto, basados en la refactorización profesional realizada en el módulo de administración. Todos los nuevos módulos deben seguir estos patrones para asegurar la mantenibilidad y escalabilidad del sistema.

## 1. Backend (NestJS)

### 1.1. Principio de Responsabilidad Única (SRP)
Los servicios de dominio (como `UsersService`) no deben contener lógica de infraestructura o seguridad genérica.
- **Patrón**: Crear servicios especializados en el módulo `Common` para tareas transversales.
- **Ejemplo**: El `HashService` centraliza la lógica de `bcrypt`. Los servicios de dominio lo inyectan en lugar de importar librerías externas directamente.

### 1.2. Manejo de Errores Base de Datos
No repetir bloques `try-catch` complejos en cada método.
- **Patrón**: Implementar un método privado `handleDBErrors(error)` consistente en cada servicio para mapear códigos de error de Prisma (ej. `P2002`) a excepciones de NestJS (`BadRequestException`).

### 1.3. Validación de Datos (DTOs)
Utilizar DTOs estrictos para cada operación.
- **Patrón**: Separar DTOs de creación (`CreateUserDto`) y actualización (`UpdateUserDto`).
- **Buenas Prácticas**: Usar herencia de DTOs si hay campos comunes, pero mantener la claridad sobre qué campos son requeridos o opcionales.

---

## 2. Frontend (Vue 3)

### 2.1. Modularización con Composables
Las vistas (`.vue`) deben ser descriptivas y ligeras. La lógica de estado y efectos debe residir en **Composables**.
- **Regla**: Si un componente tiene más de 100 líneas de `<script>`, es candidato para extraer lógica a un composable (ej. `useUsers.ts`).
- **Beneficio**: Facilita el testeo unitario y permite reutilizar la lógica de negocio en diferentes componentes.

### 2.2. Componentes Reutilizables (Shared UI)
Evitar duplicar marcado complejo (como modales o tablas) en cada módulo.
- **Patrón**: Utilizar componentes base en `src/components/common/`.
- **Ejemplo**: `BaseModal.vue` gestiona el backdrop, el cierre con Esc y la estructura base, permitiendo que `UserDialog.vue` se enfoque solo en el formulario.

### 2.3. Principio DRY y Constantes Centralizadas
No hardcodear etiquetas o listas de opciones (como roles o estados) en los componentes.
- **Patrón**: Crear un archivo `*.constants.ts` en el nivel del módulo.
- **Beneficio**: Si una etiqueta cambia, se actualiza en un solo lugar y se refleja en tablas, formularios y filtros.

### 2.4. Estabilidad de Recursos Externos (CSS/Assets)
Para librerías críticas de UI (como `sonner` o `flatpickr`), si la resolución de módulos de Vite presenta problemas de visibilidad o estilos en producción:
- **Práctica**: Alojar una copia local del CSS en `src/assets/` para garantizar que los estilos se carguen correctamente sin depender de resoluciones complejas de paquetes en node_modules.

---

## 3. Calidad de Código General

1.  **Tipado Estricto (TypeScript)**: Prohibido el uso de `any`. Definir interfaces precisas para las respuestas de la API y los payloads.
2.  **Clean Code**: Nombres de variables y funciones descriptivos en inglés para la lógica y en español para las etiquetas de usuario si es necesario.
3.  **Refactorización Continua**: Si detectas un patrón repetido 3 veces, es momento de abstraerlo.

---
*Este documento es dinámico y debe actualizarse a medida que el sistema evolucione.*
