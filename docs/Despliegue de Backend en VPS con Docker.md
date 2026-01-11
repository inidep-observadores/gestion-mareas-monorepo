# Despliegue de Backend en VPS con Docker (Traefik)

Este documento describe los pasos para levantar el backend de SIGMA en un VPS usando Docker y Traefik, con foco en un entorno de pruebas. Siga el orden indicado y valide cada paso antes de continuar.

## 1. Requisitos previos

- VPS con Linux (recomendado Ubuntu 22.04 LTS o similar).
- Acceso SSH con usuario con permisos sudo.
- Docker Engine y Docker Compose Plugin instalados.
- Git instalado.
- Traefik funcionando en el VPS (red externa disponible).

## 2. Preparacion del VPS

1. Actualice el sistema e instale dependencias basicas:

   ```bash
   sudo apt update && sudo apt -y upgrade
   sudo apt -y install git ca-certificates curl
   ```

2. Instale Docker y Docker Compose (documentacion oficial de Docker recomendada).
3. Verifique la red externa de Traefik (ejemplo `traefik`):

   ```bash
   docker network ls
   ```

## 3. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd gestion-mareas-monorepo
```

## 4. Configurar variables de entorno

1. Copie el template del backend:

   ```bash
   cp backend/.env.template backend/.env
   ```

2. Edite `backend/.env` y configure valores reales. Para un despliegue con Docker Compose:

- `DB_HOST=db`
- `DB_PORT=5432`
- `DB_USERNAME=postgres`
- `DB_PASSWORD=<su_password>`
- `DB_NAME=<su_db>`
- `DATABASE_URL="postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"`
- `JWT_SECRET=<secreto_largo_y_unico>`
- `FRONTEND_URL=<url_real_del_frontend>`
- `SMTP_HOST=mailhog` (solo pruebas) o el SMTP real que corresponda
- `SMTP_PORT=1025` (solo pruebas)

> Nota: si utiliza un SMTP real, actualice `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS` y `SMTP_SECURE`.

## 5. Dockerfile del backend

Utilizamos un flujo multi-stage para optimizar el tamaño de la imagen y la seguridad:

```dockerfile
# backend/Dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@latest --activate
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --no-frozen-lockfile
COPY . .
RUN pnpm prisma generate
RUN pnpm build

FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
RUN corepack enable && corepack prepare pnpm@latest --activate
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --prod --no-frozen-lockfile
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/static ./static
CMD ["node", "dist/main"]
```

## 6. Docker Compose de producción

Configuración optimizada para Traefik con persistencia de datos y migraciones automáticas:

```yaml
# backend/docker-compose-prod.yaml
services:
  db:
    image: postgres:15-alpine
    restart: always
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    container_name: mareasdb
    volumes:
      - mareas_db_data:/var/lib/postgresql/data
    networks:
      - sigma-network

  backend:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: sigma-backend
    restart: always
    env_file:
      - .env
    environment:
      DB_HOST: db
      SMTP_HOST: mailhog
    depends_on:
      - db
    volumes:
      - ./backups:/app/backups
      - ./static:/app/static
      - ./uploads:/app/uploads
    command: >
      sh -c "npx prisma migrate deploy && node dist/src/main"
    labels:
      - "traefik.enable=true"
      - 'traefik.http.routers.sigma-backend.rule=Host(`${API_DOMAIN}`)'
      - "traefik.http.routers.sigma-backend.entrypoints=websecure"
      - "traefik.http.routers.sigma-backend.tls=true"
      - "traefik.http.routers.sigma-backend.tls.certresolver=mytlschallenge"
      - "traefik.http.services.sigma-backend.loadbalancer.server.port=3000"
      - "traefik.docker.network=traefik"
    networks:
      - sigma-network
      - traefik

networks:
  sigma-network:
    driver: bridge
  traefik:
    external: true

volumes:
  mareas_db_data:
```

## 7. Levantar servicios

Desde la carpeta `backend/`:

```bash
docker compose -f docker-compose-prod.yaml up -d --build
```

> [!IMPORTANT]
> El comando `command` en el `docker-compose` ya incluye la ejecución de `prisma migrate deploy`, por lo que la base de datos se actualizará automáticamente en cada inicio.

## 8. Carga inicial de datos (Seed)

Si es la primera vez o necesita resetear datos base (catálogos):

```bash
docker compose -f docker-compose-prod.yaml exec backend pnpm prisma db seed
```

## 9. Validaciones básicas

- Verifique estado de contenedores:
  ```bash
  docker compose -f docker-compose-prod.yaml ps
  ```

- Revise logs para asegurar que las migraciones corrieron bien:
  ```bash
  docker compose -f docker-compose-prod.yaml logs -f backend
  ```

## 10. Reverse proxy y TLS

- Asegure que la variable `API_DOMAIN` en el `.env` sea exactamente el dominio configurado en el DNS (ej: `mareas-api.innovamdp.com`).
- Verifique que el `certresolver` en las etiquetas de Traefik coincida con el nombre configurado en su `traefik.yaml` global (en tu caso es `mytlschallenge`).

---

---

## Consideraciones para evitar errores de CORS y HTTPS

### 1. Ajuste de CORS
En NestJS, el origen debe coincidir exactamente. En tu `.env` de producción:
- ✅ **BIEN**: `FRONTEND_URL=https://mareas.innovamdp.com`
- ❌ **MAL**: `FRONTEND_URL=https://mareas.innovamdp.com/` (la barra final rompe el match)
- ❌ **MAL**: `FRONTEND_URL=http://mareas.innovamdp.com` (si el frontend usa HTTPS)

### 2. Protocolo HTTPS
- Traefik se encarga de "terminar" la conexión SSL. El backend recibe tráfico HTTP internamente, pero el navegador web cree que todo es HTTPS.
- Si usas un dominio con HTTPS, **todas** las llamadas del frontend deben ser a `https://`.

### 3. Certificados de confianza
- Si usas `myresolver` (Let's Encrypt), Traefik generará los certificados automáticamente.
- Si ves errores de "Certificate Not Trusted", revisa los logs de Traefik para ver si falló el desafío HTTP o DNS de Let's Encrypt.

