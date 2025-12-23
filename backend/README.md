<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="200" alt="Nest Logo" /></a>
</p>

# Teslo API

1. Clonar proyecto
2. ```yarn install```
3. Clonar el archivo ```.env.template``` y renombrarlo a ```.env```
4. Cambiar las variables de entorno
5. Levantar la base de datos

```
docker-compose up -d
```

1. Levantar: ```yarn start:dev```

2. Ejecutar SEED

```
http://localhost:3000/api/seed
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
