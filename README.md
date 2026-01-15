# Mareas App - Monorepo

Este es el repositorio principal para el proyecto Mareas, que contiene tanto el backend como el frontend de la aplicación.

## Descripción General

Este monorepo está organizado en dos partes principales:

- **`backend/`**: Una API de NestJS que gestiona los datos, la autenticación y la lógica de negocio.
- **`frontend/`**: Una aplicación de Vue.js que proporciona la interfaz de usuario.

## Tecnologías Utilizadas

- **Backend**:
  - [NestJS](https://nestjs.com/)
  - [Prisma](https://www.prisma.io/) como ORM.
  - [PostgreSQL](https://www.postgresql.org/) como base de datos.
  - [Docker](https://www.docker.com/) para la gestión de la base de datos.
- **Frontend**:
  - [Vue 3](https://vuejs.org/)
  - [Vite](https://vitejs.dev/)
  - [Tailwind CSS](https://tailwindcss.com/)

---

## Puesta en Marcha

Sigue estos pasos para configurar y ejecutar el proyecto completo en tu entorno de desarrollo.

### Prerrequisitos

- [Node.js](https://nodejs.org/) (versión 16 o superior recomendada)
- [Docker](https://www.docker.com/get-started) y Docker Compose

---

### 1. Configuración del Backend

Primero, configura y ejecuta el servidor de la API.

1. **Navega al directorio del backend:**

    ```bash
    cd backend
    ```

2. **Instala las dependencias:**

    ```bash
    npm install
    ```

3. **Configura las variables de entorno:**
    Copia el archivo `.env.template` y renómbralo a `.env`. Luego, ajusta las variables según tu entorno.

    ```bash
    cp .env.template .env
    ```

4. **Levanta la base de datos con Docker:**
    Este comando iniciará un contenedor de PostgreSQL.

    ```bash
    docker-compose up -d
    ```

5. **Ejecuta las migraciones de la base de datos (si es necesario con Prisma):**

    ```bash
    npx prisma migrate dev
    ```

6. **Inicia el servidor de desarrollo:**

    ```bash
    npm run start:dev
    ```

    La API estará disponible en `http://localhost:3000`.

7. **(Opcional) Ejecuta el SEED:**
    Para poblar la base de datos con datos de prueba ejecuta el seed que se define en `backend/prisma/seed.ts` usando el binario de Prisma:

    ```bash
    cd backend
    pnpm prisma db seed
    ```

    También lo puedes correr desde la raíz del monorepo con el scope del workspace:

    ```bash
    pnpm --filter sigma-backend -- prisma db seed
    ```

    El comando invoca `ts-node prisma/seed.ts`, limpia los datos existentes e inserta los registros base definidos en el seed.

---

### 2. Configuración del Frontend

Ahora, configura y ejecuta la aplicación cliente.

1. **Abre una nueva terminal y navega al directorio del frontend:**

    ```bash
    cd frontend
    ```

2. **Instala las dependencias:**

    ```bash
    npm install
    ```

3. **Inicia el servidor de desarrollo:**

    ```bash
    npm run dev
    ```

    La aplicación estará disponible en `http://localhost:5173` (o en el puerto que Vite indique).

---

### 3. Acceso a la Aplicación

- **API Backend**: `http://localhost:3000`
- **Aplicación Frontend**: `http://localhost:5173` (revisa la salida de `npm run dev` para el puerto exacto).
- **MailHog (para ver correos enviados)**: `http://localhost:8025`

---

## Despliegue en Producción

A diferencia del entorno de desarrollo, en producción **nunca** se debe usar `prisma migrate dev`, ya que este comando puede intentar resetear la base de datos si detecta cambios manuales.

### Aplicar migraciones en Producción
Para aplicar las migraciones (incluyendo nuestras vistas SQL personalizadas) de forma segura:

```bash
npx prisma migrate deploy
```

Este comando:
1. Lee las migraciones en `prisma/migrations`.
2. Aplica solo las que faltan.
3. **Nunca** borra datos ni resetea la base de datos.
4. Es el comando ideal para usar en tuberías de CI/CD.

---

## Vistas SQL y Personalizaciones de Base de Datos

Para que la base de datos incluya vistas "aplanadas" u otras personalizaciones que no se pueden definir directamente en el esquema de Prisma, se utilizan migraciones personalizadas.

### Cómo agregar o modificar vistas SQL
1. **Generar migración vacía**:
   ```bash
   npx prisma migrate dev --create-only --name nombre_de_tu_vista
   ```
2. **Agregar el SQL**: Edita el archivo `migration.sql` creado en la nueva carpeta de `prisma/migrations` y pega tu código SQL (ej: `CREATE VIEW...`).
3. **Aplicar**: Ejecuta `npx prisma migrate dev`.

### Vistas Disponibles
- **`vw_mareas_completas`**: Una vista que aplane los IDs de buques, estados y puertos de las primeras 10 etapas de una marea, formateando las fechas a `DD/MM/YYYY` en hora local (UTC-3). Ideal para consultas externas o reportes rápidos.

---

## Flujo de Recuperación de Contraseña

El backend proporciona endpoints para un flujo de recuperación de contraseña. El frontend debe integrarse con los siguientes endpoints:

1. **Solicitar recuperación**: `POST /api/auth/forgot-password`
2. **Validar Token**: `GET /api/auth/reset-password/:token`
3. **Establecer nueva contraseña**: `POST /api/auth/reset-password`

> **Nota:** El enlace de recuperación enviado por correo se basa en la variable `FRONTEND_URL` del archivo `.env` del backend. Asegúrate de que apunte a la URL correcta de tu frontend.
