# Guía de Despliegue de SIGMA en VPS INIDEP (Red Local: 10.0.64.46)

Esta guía detalla los pasos para poner en funcionamiento la plataforma completa de **SIGMA** (Frontend, Backend, Base de Datos, Redis, Gotenberg y Traefik) en el VPS del organismo, manteniendo el estándar de directorios utilizado en producción (`/opt`).

---

## 1. Información General del Servidor

- **IP del VPS:** `10.0.64.46`
- **Acceso:** SSH (`ssh <usuario>@10.0.64.46`)
- **Directorio base en servidor:** `/opt`
  - `/opt/traefik`: Proxy inverso global y certificados.
  - `/opt/sigma`: Repositorio y stack de la aplicación SIGMA.
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

## 3. Estructura de Directorios en el Servidor (`/opt`)

Siguiendo el esquema de producción, los servicios se distribuyen en `/opt`:

```text
/opt/
├── traefik/                          # Servicio independiente de Traefik
│   ├── docker-compose.yml            # Configuración de Traefik v2.11
│   └── .env                          # Variables de Traefik (SSL_EMAIL)
│
└── sigma/                            # Repositorio clonado (gestion-mareas-monorepo)
    ├── app/
    │   ├── backend/                  # Código y Dockerfile de NestJS
    │   └── frontend/                 # Código y Dockerfile de Vue 3
    └── deploy/
        └── vps-inidep/
            ├── traefik/              # Plantillas originales de Traefik
            ├── app/
            │   ├── docker-compose.yaml        # Stack de SIGMA (App, DB, Redis, Gotenberg)
            │   ├── .env.backend               # Variables reales del backend
            │   ├── .env                       # Variables del frontend
            │   ├── backups/                   # Copias de seguridad de la base
            │   ├── static/                    # Archivos estáticos persistentes
            │   └── uploads/                   # Documentos e informes cargados
            └── GUIA_DESPLIEGUE_VPS_INIDEP.md  # Esta guía
```

---

## 4. Paso a Paso para el Despliegue

### Paso 1: Conectarse por SSH y preparar las carpetas en `/opt`

Conéctese al servidor y cree los directorios asignando la propiedad a su usuario para operar cómodamente sin `sudo` constante:

```bash
ssh <usuario>@10.0.64.46

# Crear directorios en /opt
sudo mkdir -p /opt/traefik /opt/sigma
sudo chown -R $USER:$USER /opt/traefik /opt/sigma
```

### Paso 2: Clonar el repositorio en `/opt/sigma`

Clone el repositorio directamente dentro de `/opt/sigma`:

```bash
git clone <URL_REPOSITORIO_GIT> /opt/sigma
cd /opt/sigma
```

### Paso 3: Crear la red compartida de Docker

Traefik y la aplicación SIGMA se conectan mediante la red externa `traefik`:

```bash
docker network create traefik
```

### Paso 4: Configurar y Levantar Traefik en `/opt/traefik`

1. Copie los archivos de configuración desde el repositorio a `/opt/traefik`:
   ```bash
   cp /opt/sigma/deploy/vps-inidep/traefik/docker-compose.traefik.yaml /opt/traefik/docker-compose.yml
   cp /opt/sigma/deploy/vps-inidep/traefik/.env.example /opt/traefik/.env
   ```

2. Inicie el contenedor de Traefik:
   ```bash
   cd /opt/traefik
   docker compose up -d
   ```

3. Verifique que Traefik esté activo:
   ```bash
   docker compose ps
   ```

### Paso 5: Configurar Variables de Entorno de SIGMA

1. Ingrese a la carpeta de despliegue de la aplicación:
   ```bash
   cd /opt/sigma/deploy/vps-inidep/app
   ```

2. Genere los archivos de entorno a partir de las plantillas:
   ```bash
   cp .env.backend.example .env.backend
   cp .env.frontend.example .env
   ```

3. Edite `.env.backend` y configure sus valores:
   ```bash
   nano .env.backend
   ```
   *Puntos clave para la Fase 1 (Red Local):*
   - `DB_PASSWORD`: Contraseña para la base de datos PostgreSQL.
   - `JWT_SECRET` y `BACKUP_SECRET`: Cadenas aleatorias seguras.
   - `FRONTEND_URL`: `http://10.0.64.46`
   - `HOST_API`: `http://10.0.64.46/api`
   - `COOKIE_SECURE`: `false` (imprescindible para sesión por HTTP en IP local).
   - `COOKIE_SAMESITE`: `lax`

### Paso 6: Construir y Levantar SIGMA

Desde `/opt/sigma/deploy/vps-inidep/app`:

```bash
docker compose up -d --build
```

> [!IMPORTANT]
> El contenedor `backend` corre automáticamente `npx prisma migrate deploy` al arrancar, por lo que las tablas y migraciones de la base de datos se aplicarán sin intervención manual.

Verifique el inicio de los contenedores:
```bash
docker compose ps
docker compose logs -f backend
```

---

## 5. Carga de Datos Iniciales

### Opción A: Carga de catálogos base (Seed)
Para poblar los catálogos base (usuarios administradores, buques, puertos, pesquerías):
```bash
cd /opt/sigma/deploy/vps-inidep/app
docker compose exec backend npm run seed:prod
```

Para cargar el histórico de mareas base (JSONL):
```bash
docker compose exec backend node prisma/seed-mareas-jsonl.js
```

### Opción B: Restaurar un backup de producción existente
Si dispone de una copia de seguridad `.sql` (por ejemplo `backup_prod.sql`):
```bash
cat /ruta/hacia/backup_prod.sql | docker exec -i sigma-db psql -U postgres -d mareas_db
```

---

## 6. Verificación de Funcionamiento

1. **Frontend y Aplicación Web (Navegador):**
   Acceda desde cualquier equipo de la red del organismo a:
   ```
   http://10.0.64.46
   ```
   - Verifique la pantalla de inicio de sesión.
   - Inicie sesión y compruebe el funcionamiento del Dashboard, Bandeja de Mareas, Monitor y Planificación.
   - Las solicitudes a la API se canalizan automáticamente a `http://10.0.64.46/api/...`.

2. **Gestor de Base de Datos (DBeaver / DataGrip):**
   - **Host:** `10.0.64.46`
   - **Puerto:** `5435`
   - **Base de datos:** `mareas_db`
   - **Usuario:** `postgres` (o el valor de `DB_USERNAME`)
   - **Contraseña:** el valor asignado en `DB_PASSWORD`

3. **Dashboard de Traefik (Monitoreo de Rutas):**
   ```
   http://10.0.64.46:8080
   ```

---

## 7. Actualizaciones de Código en el Servidor

Cuando haya nuevas versiones o cambios en el repositorio:

```bash
cd /opt/sigma
git pull origin develop   # o main según la rama de despliegue

cd deploy/vps-inidep/app
docker compose up -d --build
```

Los volúmenes de base de datos (`mareas_db_data_inidep`), caché de Redis y archivos subidos (`uploads/`, `static/`, `backups/`) permanecerán intactos.

---

## 8. Fase 2: Publicación a Internet (Puerto 443 con Dominio DNI)

Una vez que el centro de cómputos asigne el nombre de dominio (ej. `mareas.inidep.gob.ar`) y autorice la apertura del puerto 443:

1. **Actualizar `/opt/traefik/docker-compose.yml`:**
   - Descomente las líneas de redirección a HTTPS y el resolver ACME (o monte los certificados SSL provistos por DNI).
   - Reinicie Traefik:
     ```bash
     cd /opt/traefik
     docker compose up -d
     ```

2. **Actualizar Backend (`/opt/sigma/deploy/vps-inidep/app/.env.backend`):**
   - Modifique los orígenes para HTTPS:
     ```env
     FRONTEND_URL=https://mareas.inidep.gob.ar
     HOST_API=https://mareas.inidep.gob.ar/api
     COOKIE_SECURE=true
     COOKIE_SAMESITE=none
     ```
   - Reinicie la aplicación:
     ```bash
     cd /opt/sigma/deploy/vps-inidep/app
     docker compose up -d
     ```

No se requerirá recompilar el frontend ni migrar la base de datos, ya que el enrutamiento relativo (`/` y `/api`) permanecerá idéntico y seguro en el puerto 443.
