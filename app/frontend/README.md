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

## Despliegue con Docker y Traefik

El proyecto incluye una configuración para ser desplegado en un VPS propio utilizando Docker y Traefik como proxy inverso.

### Requisitos previos

- Tener Docker y Docker Compose instalados en el VPS.
- Tener Traefik configurado en una red externa llamada `traefik`.
- Configurar los registros DNS para el subdominio deseado.

### Pasos para el despliegue (Staging)

1. **Configurar variables de entorno**:
   Asegúrese de que el archivo `.env.staging` tenga los valores correctos:
   ```env
   VITE_BACKEND_URL=https://api.tu-servidor.com/api
   STAGING_FRONTEND_DOMAIN=staging.tu-dominio.com
   ```

2. **Ejecutar el despliegue**:
   Desde la carpeta `app/frontend`, ejecute el siguiente comando:
   ```bash
   docker compose --env-file .env.staging -f docker-compose-staging.yaml up -d --build
   ```

### Archivos de configuración de despliegue

- `Dockerfile`: Construcción multietapa (Node + Nginx Alpine).
- `nginx.conf`: Configuración optimizada para Single Page Applications (SPA).
- `docker-compose-staging.yaml`: Orquestación y etiquetas para Traefik.

## Estructura del proyecto

- `src/modules/`: funcionalidades por dominio (auth, mareas, admin, etc.).
- `src/components/`: componentes UI reutilizables.
- `src/composables/`: logica compartida por composables.
- `src/config/`: configuracion de HTTP, colores y utilidades.
- `src/assets/`: estilos globales y recursos.

## Consideraciones para despliegue

- Configure `VITE_BACKEND_URL` con la URL pública del backend.
- Asegure CORS y cookies seguras si usa autenticación con cookies.
- Para entornos con Traefik u otro reverse proxy, utilice dominios coherentes entre frontend y backend.
