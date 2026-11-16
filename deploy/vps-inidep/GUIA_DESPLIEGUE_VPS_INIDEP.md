# Guía de Despliegue de SIGMA en VPS INIDEP (Red Local: 10.0.64.46)

Esta guía detalla los pasos para poner en funcionamiento la plataforma completa de **SIGMA** (Frontend, Backend, Base de Datos, Redis, Gotenberg y Traefik) en el VPS del organismo.

---

## 1. Información General del Servidor

- **IP del VPS:** `10.0.64.46`
- **Acceso:** SSH (`ssh <usuario>@10.0.64.46`)
- **Fase 1 (Actual - Red Local):** Acceso por IP vía HTTP (`http://10.0.64.46`) para pruebas y validación.
- **Fase 2 (Próxima - Publicación Internet):** Conexión vía dominio institucional y certificados SSL exclusivamente por el puerto **443** (autorizado por DNI).

---

## 2. Requisitos Previos en el VPS

Asegúrese de que el VPS cuente con:
1. Docker Engine y Docker Compose Plugin (`docker compose version`).
2. Git instalado (`git --version`).
3. Puertos habilitados en el firewall del VPS (UFW u homologado):
   ```bash
   sudo ufw allow 22/tcp    # SSH
   sudo ufw allow 80/tcp    # HTTP (Traefik - Fase 1)
   sudo ufw allow 443/tcp   # HTTPS (Traefik - Fase 2)
   sudo ufw allow 5435/tcp  # PostgreSQL para DBeaver desde la red local
   ```

---

## 3. Estructura de Directorios

El monorepo contiene la configuración modular en:
```
gestion-mareas-monorepo/
└── deploy/
    └── vps-inidep/
        ├── traefik/
        │   ├── docker-compose.traefik.yaml
        │   └── .env.example
        ├── app/
        │   ├── docker-compose.yaml
        │   ├── .env.backend.example
        │   └── .env.frontend.example
        └── GUIA_DESPLIEGUE_VPS_INIDEP.md
```

---

## 4. Paso a Paso para el Despliegue

### Paso 1: Conectarse por SSH y clonar el repositorio

```bash
ssh <usuario>@10.0.64.46
git clone <URL_REPOSITORIO_GIT>
cd gestion-mareas-monorepo
```

### Paso 2: Crear la red compartida de Traefik

Traefik y la aplicación se comunican mediante una red externa de Docker:

```bash
docker network create traefik
```

### Paso 3: Configurar y Levantar Traefik (Proxy Inverso)

1. Vaya a la carpeta de Traefik:
   ```bash
   cd deploy/vps-inidep/traefik
   cp .env.example .env
   ```

2. Inicie el contenedor de Traefik:
   ```bash
   docker compose -f docker-compose.traefik.yaml up -d
   ```

3. Verifique que esté corriendo:
   ```bash
   docker compose -f docker-compose.traefik.yaml ps
   ```

### Paso 4: Configurar Variables de Entorno de la Aplicación

1. Vaya a la carpeta de la aplicación:
   ```bash
   cd ../app
   ```

2. Cree los archivos `.env` a partir de las plantillas:
   ```bash
   cp .env.backend.example .env.backend
   cp .env.frontend.example .env
   ```

3. Edite `.env.backend` con sus valores definitivos:
   ```bash
   nano .env.backend
   ```
   *Puntos clave a revisar:*
   - `DB_PASSWORD`: Elija una contraseña segura para PostgreSQL.
   - `JWT_SECRET` y `BACKUP_SECRET`: Genere claves aleatorias seguras.
   - `FRONTEND_URL`: `http://10.0.64.46`
   - `COOKIE_SECURE`: `false` (mantiene la sesión por HTTP en la red local).
   - `COOKIE_SAMESITE`: `lax`

### Paso 5: Construir y Levantar SIGMA

Desde `deploy/vps-inidep/app/`:

```bash
docker compose up -d --build
```

> [!IMPORTANT]
> El backend ejecuta automáticamente `npx prisma migrate deploy` al iniciar, por lo que la estructura de la base de datos se aplicará de forma desatendida.

Verifique los logs del backend para confirmar el inicio exitoso:
```bash
docker compose logs -f backend
```

---

## 5. Carga de Datos Iniciales

### Opción A: Carga de catálogos base (Seed)
Para cargar usuarios administradores, buques base y catálogos:
```bash
docker compose exec backend npm run seed:prod
```

Para cargar el histórico de mareas base (JSONL):
```bash
docker compose exec backend node prisma/seed-mareas-jsonl.js
```

### Opción B: Restaurar un backup de producción existente
Si tiene una copia de seguridad `.sql` de producción:
```bash
cat /ruta/hacia/backup.sql | docker exec -i sigma-db psql -U postgres -d mareas_db
```

---

## 6. Verificación de Funcionamiento

1. **Frontend y Aplicación Web:**
   Abra el navegador en cualquier computadora de la red local:
   ```
   http://10.0.64.46
   ```
   - Inicie sesión con sus credenciales.
   - Compruebe que la navegación, carga de buques, observadores y mareas funcione fluidamente.
   - Las peticiones a la API viajarán transparentemente a `http://10.0.64.46/api/...`.

2. **Acceso a Base de Datos (DBeaver / DataGrip):**
   - **Host:** `10.0.64.46`
   - **Puerto:** `5435`
   - **Base de datos:** `mareas_db`
   - **Usuario:** `postgres` (o el indicado en `DB_USERNAME`)
   - **Contraseña:** la configurada en `DB_PASSWORD`

3. **Dashboard de Traefik (Monitoreo de Rutas):**
   ```
   http://10.0.64.46:8080
   ```

---

## 7. Fase 2: Publicación a Internet (Puerto 443 con Dominio DNI)

Una vez que el centro de cómputos asigne el nombre de dominio (ej. `mareas.inidep.gob.ar`) y autorice la apertura del puerto 443:

1. **Actualizar Traefik:**
   En `deploy/vps-inidep/traefik/docker-compose.traefik.yaml`:
   - Descomente las líneas de redirección a HTTPS y el resolver ACME (o monte los certificados SSL provistos por DNI).
   - Reinicie Traefik:
     ```bash
     docker compose -f docker-compose.traefik.yaml up -d
     ```

2. **Actualizar Backend (`.env.backend`):**
   - Cambie `FRONTEND_URL` al dominio seguro: `https://mareas.inidep.gob.ar`
   - Cambie `HOST_API`: `https://mareas.inidep.gob.ar/api`
   - Cambie las cookies a modo HTTPS:
     ```env
     COOKIE_SECURE=true
     COOKIE_SAMESITE=none
     ```
   - Reinicie la aplicación:
     ```bash
     docker compose up -d
     ```

No se requerirá recompilar el frontend ni modificar la base de datos, ya que el enrutamiento por ruta (`/` y `/api`) permanecerá idéntico.

