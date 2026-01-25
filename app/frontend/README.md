# SIGMA Frontend

Cliente web del Sistema Integral de Gestion de Mareas (SIGMA) para INIDEP. Este proyecto concentra la interfaz de usuario, la navegacion y el consumo de la API del backend.

## Funcionalidades principales

- Autenticacion completa (inicio de sesion, recuperacion y restablecimiento de contrasena).
- Paneles operativos y tableros de control con indicadores clave.
- Gestion integral de mareas (listado, detalle, edicion y flujo de trabajo).
- Administracion de catalogos y entidades (buques, observadores, puertos, especies, etc.).
- Modulo de monitoreo y visualizacion de informacion operacional.
- Notificaciones mediante toasts y feedback visual para acciones asincronas.

## Stack y convenciones

- Vue 3 + Composition API (`<script setup lang="ts">`).
- Vite como build tool.
- TypeScript estricto.
- Tailwind CSS v4 con variables de tema en `src/assets/main.css`.
- Componentes UI: prioridad a FlyonUI.
- Dialogos: Headless UI.
- Notificaciones: `vue-sonner`.
- Navegacion: rutas nombradas con Vue Router.

## Configuracion de entorno

El frontend toma la URL del backend desde la variable `VITE_BACKEND_URL`.

- Desarrollo local: edite `frontend/.env`.
- Netlify: defina la variable de entorno en el panel del sitio.

Ejemplo:

```bash
VITE_BACKEND_URL=https://api.su-dominio.com/api
```

## Scripts utiles

```bash
# Instalar dependencias
pnpm install

# Desarrollo
pnpm dev

# Build de produccion
pnpm build

# Preview local del build
pnpm preview
```

## Estructura del proyecto

- `src/modules/`: funcionalidades por dominio (auth, mareas, admin, etc.).
- `src/components/`: componentes UI reutilizables.
- `src/composables/`: logica compartida por composables.
- `src/config/`: configuracion de HTTP, colores y utilidades.
- `src/assets/`: estilos globales y recursos.

## Consideraciones para despliegue

- Configure `VITE_BACKEND_URL` con la URL publica del backend.
- Asegure CORS y cookies seguras si usa autenticacion con cookies.
- Para entornos con Traefik u otro reverse proxy, utilice dominios coherentes entre frontend y backend.
