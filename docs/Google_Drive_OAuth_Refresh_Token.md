# Guía de Configuración y Renovación de Refresh Token de Google Drive (OAuth 2.0)

Este documento detalla los pasos para configurar la pantalla de consentimiento de OAuth en Google Cloud Console para evitar la expiración de tokens a los 7 días y cómo obtener/renovar un **Refresh Token permanente** para la integración con Google Drive en SIGMA.

---

## Contexto y Problema

Por defecto, cuando se crea un proyecto de Google OAuth 2.0 y la pantalla de consentimiento está en estado **"En prueba" (Testing)**, los Refresh Tokens emitidos caducan automáticamente a los **7 días**. Esto provoca errores de autenticación en el backend al intentar subir o sincronizar archivos en Google Drive (`invalid_grant`).

Para resolver esto de forma definitiva y poder renovar o generar tokens futuros, se debe cumplir con dos etapas:
1. Pasar la aplicación a **Producción** o marcarla como **Interna**.
2. Obtener un nuevo **Refresh Token** usando **Google OAuth 2.0 Playground**.

---

## Paso 1: Configurar el Estado de Publicación en Google Cloud Console

1. Ingrese a la **[Google Cloud Console](https://console.cloud.google.com/)**.
2. Seleccione el proyecto correspondiente a la API de Google Drive de SIGMA.
3. En el menú de navegación lateral, diríjase a **APIs y servicios** > **Pantalla de consentimiento de OAuth** (*OAuth consent screen*).
4. Verifique el **Tipo de usuario** y **Estado de publicación**:
   - **Caso A (Cuenta Google Workspace / Institucional):** Si cuenta con una cuenta institucional de organización, puede marcar la app como **Interno (Internal)**. Esto permite acceso ilimitado dentro de la organización sin necesidad de verificación por parte de Google ni expiración a los 7 días.
   - **Caso B (Cuenta de Google pública / @gmail.com):** En la sección *Estado de publicación*, haga clic en **PUBLICAR APLICACIÓN** (*PUBLISH APP*) y confirme la acción. El estado cambiará a **En producción**.
     > [!NOTE]
     > Al pasar a producción con cuentas personales, Google mostrará una advertencia la primera vez que autorice la app (*"Google no ha verificado esta aplicación"*). Simplemente haga clic en **Opciones avanzadas** > **Ir a [Nombre App] (no seguro)**. El token obtenido **no expirará a los 7 días**.

---

## Paso 2: Habilitar URI de Redireccionamiento Autorizada

Para poder usar la herramienta oficial de Google sin levantar un servidor local para la redirección OAuth:

1. En Google Cloud Console, vaya a **APIs y servicios** > **Credenciales**.
2. Ubique las credenciales en **IDs de cliente OAuth 2.0** utilizadas por el backend.
3. Haga clic en el ícono de edición (lápiz).
4. En la sección **URIs de redireccionamiento autorizados**, agregue la siguiente URL:
   ```text
   https://developers.google.com/oauthplayground
   ```
5. Guarde los cambios (*Guardar*).

---

## Paso 3: Generación del Nuevo Refresh Token con OAuth 2.0 Playground

1. Ingrese a **[Google OAuth 2.0 Playground](https://developers.google.com/oauthplayground)**.
2. Haga clic en el ícono de **Configuración / Engranaje (⚙️)** en la esquina superior derecha.
3. Marque la opción **Use your own OAuth credentials** (*Usar tus propias credenciales OAuth*).
4. Ingrese las credenciales de su proyecto:
   - **OAuth Client ID:** Su `GOOGLE_DRIVE_CLIENT_ID`
   - **OAuth Client Secret:** Su `GOOGLE_DRIVE_CLIENT_SECRET`
5. En el panel izquierdo (**Step 1: Select & authorize APIs**):
   - Busque en la lista **Drive API v3** o ingrese manualmente el scope necesario en la casilla de texto inferior.
   - Scopes habituales:
     - Control total: `https://www.googleapis.com/auth/drive`
     - Acceso a archivos creados por la app: `https://www.googleapis.com/auth/drive.file`
   - Haga clic en el botón azul **Authorize APIs**.
6. Se abrirá la ventana de inicio de sesión de Google:
   - Inicie sesión con la cuenta de Google propietaria del Drive/Carpeta.
   - Si aparece la pantalla *"Google no ha verificado esta aplicación"*, presione **Opciones avanzadas** y luego **Ir a [Nombre de App] (no seguro)**.
   - Otorga los permisos solicitados.
7. Al ser redirigido nuevamente al Playground, estará en el **Step 2 (Exchange authorization code for tokens)**:
   - Haga clic en el botón **Exchange authorization code for tokens**.
8. En la respuesta JSON de la derecha (o en los campos del Step 2), copie el valor asignado a **`refresh_token`**.

---

## Paso 4: Actualizar las Variables de Entorno del Backend

1. Abra el archivo `.env` del backend (`app/backend/.env`).
2. Actualice la clave del Refresh Token con el nuevo valor obtenido:
   ```env
   GOOGLE_DRIVE_REFRESH_TOKEN=1//0g...tu_nuevo_refresh_token...
   ```
3. Reinicie el servicio de backend para aplicar los cambios:
   ```bash
   # En desarrollo local
   npm run start:dev

   # En entornos Docker / Producción
   docker compose restart backend
   ```

---

## Consideraciones sobre la Expiración del Refresh Token

Un Refresh Token generado bajo una app **En producción** o **Interna** no expira a los 7 días. Sin embargo, puede quedar invalidado por las siguientes razones:

1. El usuario revoca explícitamente el acceso a la aplicación desde [Mi cuenta de Google - Seguridad](https://myaccount.google.com/permissions).
2. El token no registra ningún uso durante más de 6 meses (180 días).
3. Se superó el límite de 100 Refresh Tokens activos simultáneos para la misma combinación de usuario y Client ID.
4. Se cambió la contraseña de la cuenta de Google (aplica para ciertos tipos de cuenta).
