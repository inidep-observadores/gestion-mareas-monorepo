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

2. **Configurar el Firewall (UFW)**:
   Abra los puertos necesarios para el acceso externo durente las pruebas:
   ```bash
   sudo ufw allow 5435/tcp  # Acceso a Postgres (DBeaver)
   sudo ufw allow 8025/tcp  # Interfaz Web de Mailhog
   sudo ufw allow 80/tcp    # HTTP (Traefik)
   sudo ufw allow 443/tcp   # HTTPS (Traefik)
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
      sh -c "npx prisma generate && npx prisma migrate deploy && node dist/src/main"
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
docker compose -f docker-compose-prod.yaml exec backend npm run seed:prod
```

Para cargar los datos históricos de mareas (JSONL):

```bash
docker compose -f docker-compose-prod.yaml exec backend node prisma/seed-mareas-jsonl.js
```

> [!TIP]
> Ahora los archivos se compilan a `.js` durante el build de Docker, por lo que se ejecutan con `node` plano, lo que es más rápido y no requiere dependencias de desarrollo en producción.

## 9. Validaciones básicas

- Verifique estado de contenedores:
### Acceso a Base de Datos (DBeaver)
Para conectarse desde su máquina local a la base de datos del VPS:
- **Host**: IP de su VPS
- **Puerto**: `5435` (mapeado al 5432 interno)
- **Usuario**: Valor de `DB_USERNAME`
- **Password**: Valor de `DB_PASSWORD`

### Pruebas de Correo (Mailhog)
El stack incluye Mailhog para capturar correos salientes sin enviarlos realmente:
- **Interfaz Web**: `http://IP-VPS:8025`
- **Puerto SMTP (interno)**: `1025`

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

## 11. Recuperación ante Desastres (Disaster Recovery)

En caso de pérdida total de la base de datos o necesidad de migrar a un servidor nuevo, siga estos protocolos:

### Método A: Restauración Directa (Consola VPS)
Es el método más rápido y seguro. No requiere que la aplicación esté funcional.

1.  Asegúrese de que el archivo `.sql` esté en la carpeta `backups/` del VPS.
2.  Ejecute el siguiente comando (reemplace el nombre del archivo):
    ```bash
    cat backups/BKP-archivo.sql | docker exec -i mareasdb psql -U ${DB_USERNAME} -d ${DB_NAME}
    ```
    *(Nota: Las variables `${DB_...}` se cargarán de tu archivo `.env` si las tienes exportadas, sino escríbelas manualmente).*

### Método B: Restauración vía UI (Rescate amigable)
Si prefiere usar la interfaz web pero no tiene acceso (porque se borraron los usuarios):

1.  Ejecute un **Seed** para crear el usuario admin básico:
    ```bash
    docker compose -f docker-compose-prod.yaml exec backend node prisma/seed.js
    ```
2.  Inicie sesión en la web y vaya a **Sistema > Backups**.
3.  Seleccione el backup de la lista (o súbalo) y use la **Frase de Confirmación** que le solicite el sistema.

---

## 12. Limpieza de Espacio (Docker Cleanup)

Es normal que tras varios builds fallidos o actualizaciones se acumulen imágenes y capas "huérfanas" que consumen gigas de espacio. Para liberar espacio:

### Comandos de emergencia

1.  **Limpiar todo lo que no se esté usando**:
    Elimina imágenes sin nombre, contenedores parados y redes no usadas.
    ```bash
    docker system prune -f
    ```

2.  **Limpiar imágenes antiguas o sin usar (Más profundo)**:
    Si quieres borrar todas las imágenes que no tienen un contenedor activo (cuidado, esto borrará la cache de build):
    ```bash
    docker image prune -a -f
    ```

3.  **Ver qué está consumiendo espacio en Docker**:
    ```bash
    docker system df
    ```

### Comandos de Linux para monitorear el disco

Si quieres ver el estado general del VPS fuera de Docker:

*   **Ver espacio total y disponible (Legible)**:
    ```bash
    df -h
    ```
    *(Busca la línea que dice `/` en la columna "Mounted on", ahí verás el % de uso).*

*   **Ver cuánto pesa cada carpeta en el directorio actual**:
    ```bash
    du -sh *
    ```
    *(Ideal para saber si es la carpeta de la app, de logs o de Docker la que está creciendo).*

> [!TIP]
> Ejecutar `docker system prune -f` una vez al mes es una buena práctica de mantenimiento para tu VPS.

---

## Consideraciones para evitar errores de CORS y HTTPS

### 1. Ajuste de CORS
En NestJS, el origen debe coincidir exactamente carácter por carácter.

> [!CAUTION]
> **NO incluyas una barra final `/`** en la variable `FRONTEND_URL`. Si lo haces, las peticiones serán rechazadas por CORS.

- ✅ **CORRECTO**: `FRONTEND_URL=https://mareas.innovamdp.com`
- ❌ **INCORRECTO**: `FRONTEND_URL=https://mareas.innovamdp.com/` (la barra final provoca Error de CORS)
- ❌ **MAL**: `FRONTEND_URL=http://mareas.innovamdp.com` (si el frontend usa HTTPS)

### 2. Protocolo HTTPS
- Traefik se encarga de "terminar" la conexión SSL. El backend recibe tráfico HTTP internamente, pero el navegador web cree que todo es HTTPS.
- Si usas un dominio con HTTPS, **todas** las llamadas del frontend deben ser a `https://`.

### 3. Certificados de confianza
- Si usas `myresolver` (Let's Encrypt), Traefik generará los certificados automáticamente.
- Si ves errores de "Certificate Not Trusted", revisa los logs de Traefik para ver si falló el desafío HTTP o DNS de Let's Encrypt.

---

## 13. Seguridad de Datos y Actualizaciones

Es una preocupación común temer por los datos al actualizar. Aquí explicamos por qué su configuración es segura:

### 1. Persistencia vía Volúmenes
En el archivo `docker-compose-prod.yaml`, la base de datos está configurada con un **volumen nombrado**:
```yaml
volumes:
  - mareas_db_data:/var/lib/postgresql/data
```
Esto significa que los datos **NO viven dentro del contenedor**, sino en una carpeta protegida del VPS. Aunque borre el contenedor, lo reconstruya o actualice la imagen de Docker, los datos permanecen intactos.

### 2. Actualizaciones con Prisma
El comando `npx prisma migrate deploy` que usamos al iniciar el backend es **no destructivo**:
- Solo aplica cambios nuevos (como añadir una tabla o columna).
- Nunca borra datos existentes a menos que usted haya creado explícitamente una migración de borrado.

### 3. Procedimiento Seguro de Actualización
Para actualizar la app sin riesgo, el flujo siempre debe ser:
1.  **Pull de código**: `git pull origin main`
2.  **Rebuild**: `docker compose -f docker-compose-prod.yaml up -d --build`

> [!IMPORTANT]
> El comando `up -d --build` es inteligente: solo detiene los contenedores unos segundos, los crea de nuevo y **vuelve a conectar los volúmenes con todos sus datos originales**.

