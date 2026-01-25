<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="200" alt="Nest Logo" /></a>
</p>

# SIGMA Backend

1. Clonar el repositorio
2. Instalar dependencias del backend:

   ```bash
   cd backend
   pnpm install
   ```

3. Copiar `.env.template` a `.env` y ajustar las variables necesarias.
4. Levantar la base de datos PostgreSQL con Docker:

   ```bash
   docker-compose up -d
   ```

5. Iniciar el servidor en modo desarrollo:

   ```bash
   pnpm start:dev
   ```

6. Ejecutar el seed oficial de Prisma para cargar datos de prueba (catálogos + mareas 2025):

   ```bash
   pnpm prisma db seed
   ```

   Desde la raíz del monorepo también se puede correr con el scope:

   ```bash
   pnpm --filter sigma-backend -- prisma db seed
   ```

7. (Opcional) Si solo desea reimportar las mareas sin tocar los catálogos, puede ejecutar el seed específico:

   ```bash
   pnpm ts-node prisma/seed-mareas-jsonl.ts
   ```

# SMTP

- La interfaz web de MailHog queda disponible en:
👉 <http://localhost:8025>
Ahí se pueden ver todos los correos que envía el backend

# Recuperación de Contraseña (Integración Frontend)

El flujo de recuperación de contraseña consta de 3 pasos:

### 1. Solicitar recuperación

El usuario ingresa su email en el frontend.

- **Endpoint:** `POST /api/auth/forgot-password`
- **Body:** `{ "email": "usuario@email.com" }`
- **Respuesta:** Mensaje genérico (siempre 201 Created).

### 2. Validar Token (Opcional pero recomendado)

El usuario recibe un correo con un enlace. El frontend debe extraer el token de la URL.

- **Endpoint:** `GET /api/auth/reset-password/:token`
- **Respuesta:** `{ "valid": true }` o error 400/401.
- **Uso:** Verificar si el token es válido antes de mostrar el formulario de "Nueva Contraseña".

### 3. Establecer nueva contraseña

El usuario envía el token y la nueva contraseña.

- **Endpoint:** `POST /api/auth/reset-password`
- **Body:**
  ```json
  {
    "token": "TOKEN_RECIBIDO",
    "newPassword": "NuevaPassword123!"
  }
  ```
- **Respuesta:** `{ "message": "Contraseña actualizada correctamente" }`

> **Nota:** El enlace enviado por correo se genera a partir de la variable de entorno `FRONTEND_URL`. En desarrollo se ha configurado en `.env.template` como `FRONTEND_URL=http://mi.frontend.com/reset-password`. El token se pasa como parámetro de consulta (`?token=...`). Ajusta `FRONTEND_URL` en tu archivo `.env` para que apunte a la URL del frontend que manejará la recuperación de contraseña.

# Copias de Seguridad (Backup)

Para habilitar el sistema de backups en el panel de administración, es necesario configurar la ruta de almacenamiento:

- **Variable:** `BACKUP_PATH`
- **Valor recomendado:** `"./backups"` (creará una carpeta en la raíz del backend).
- **Dependencia:** El sistema utiliza `docker exec mareasdb pg_dump` por lo que el contenedor de la base de datos debe estar corriendo y tener el nombre `mareasdb`.
