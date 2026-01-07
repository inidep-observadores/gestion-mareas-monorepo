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

## 5. Crear Dockerfile del backend

Cree `backend/Dockerfile` con un flujo multi-stage (produccion):

```dockerfile
# backend/Dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json ./
RUN corepack enable && pnpm install --no-frozen-lockfile
COPY . .
RUN pnpm prisma generate
RUN pnpm build

FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY package.json ./
RUN corepack enable && pnpm install --no-frozen-lockfile --prod
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/static ./static
CMD ["node", "dist/main"]
```

## 6. Crear docker-compose de produccion

Cree `backend/docker-compose-prod.yaml` con el siguiente contenido (Traefik):

```yaml
services:
  db:
    image: postgres:15-alpine
    restart: always
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    container_name: mareasdb
    volumes:
      - ./postgres:/var/lib/postgresql/data

  mailhog:
    image: mailhog/mailhog
    restart: always
    ports:
      - "1025:1025"
      - "8025:8025"
    container_name: mailhog

  backend:
    build:
      context: .
      dockerfile: Dockerfile
    restart: always
    env_file:
      - .env
    environment:
      DB_HOST: db
      SMTP_HOST: mailhog
    depends_on:
      - db
      - mailhog
    volumes:
      - ./backups:/app/backups
    expose:
      - "3000"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.sigma-backend.rule=Host(`api.su-dominio.com`)"
      - "traefik.http.routers.sigma-backend.entrypoints=websecure"
      - "traefik.http.routers.sigma-backend.tls=true"
      - "traefik.http.services.sigma-backend.loadbalancer.server.port=3000"
    networks:
      - default
      - traefik

networks:
  traefik:
    external: true
```

> Nota: Si necesita acceso directo por IP para pruebas, reemplace `expose` por `ports` y abra el puerto 3000 en el firewall.

## 7. Levantar servicios

Desde la carpeta `backend/`:

```bash
docker compose -f docker-compose-prod.yaml up -d --build
```

## 8. Migraciones y seed (una sola vez)

Ejecute las migraciones en el contenedor:

```bash
docker compose -f docker-compose-prod.yaml exec backend pnpm prisma migrate deploy
```

Para cargar datos de prueba:

```bash
docker compose -f docker-compose-prod.yaml exec backend pnpm prisma db seed
```

> Nota: El seed carga catalogos y mareas 2025. No lo ejecute en un entorno productivo real.

## 9. Validaciones basicas

- Verifique estado de contenedores:

  ```bash
  docker compose -f docker-compose-prod.yaml ps
  ```

- Revise logs del backend:

  ```bash
  docker compose -f docker-compose-prod.yaml logs -f backend
  ```

## 10. Reverse proxy y TLS

- Actualice el dominio en la regla Traefik:
  - `traefik.http.routers.sigma-backend.rule=Host(`api.su-dominio.com`)`
- Asegure que Traefik tenga entrypoints `web` y `websecure` configurados.
- Configure el certificado TLS en Traefik (ACME o manual).
- Ajuste `HOST_API` y `FRONTEND_URL` en `backend/.env` si cambia el dominio.

---

Si necesita incluir el frontend en el mismo VPS, cree un despliegue separado en `/frontend` y configure CORS, `HOST_API` y `FRONTEND_URL` de forma consistente.

## 11. Frontend en Netlify (recordatorio)

Si despliega el frontend en Netlify, configure la variable de entorno:

```bash
VITE_BACKEND_URL=https://api.su-dominio.com/api
```

