# Configuración de Servicios Externos (SIGMA)

Este documento detalla los pasos necesarios para configurar los servicios de terceros requeridos por el sistema automático de gestión de Novedades de Observadores.

## 1. Configuración de Gmail (Lector IMAP)
El sistema utiliza IMAP para leer correos entrantes y procesar adjuntos.

### Requisitos:
- Una cuenta de Gmail (ej: `oficinaobservadores@gmail.com`).
- Habilitar IMAP.
- Generar una "Contraseña de aplicaciones".

### Pasos:
1. **Habilitar IMAP:**
   - Ingresa a Gmail en tu navegador web.
   - Haz clic en el ícono del engranaje (Arriba a la derecha) -> **Ver toda la configuración**.
   - Ve a la pestaña **Reenvío y correo POP/IMAP**.
   - En la sección "Acceso IMAP", selecciona **Habilitar IMAP** y guarda los cambios al final de la página.

2. **Generar Contraseña de Aplicaciones (App Password):**
   - Ve a la configuración de tu cuenta de Google (https://myaccount.google.com/).
   - En el menú lateral izquierdo, haz clic en **Seguridad**.
   - Bajo "Cómo accedes a Google", asegúrate de tener activada la **Verificación en dos pasos (2FA)**.
   - En el buscador superior de la página, escribe "Contraseñas de aplicaciones".
   - Crea una nueva indicando un nombre como "SIGMA Backend".
   - Se generará una clave de 16 letras (ej: `abcdefghijklmnop`).

3. **Variables de entorno (`.env`):**
   ```env
   IMAP_USER="tu_correo@gmail.com"
   IMAP_PASSWORD="las_16_letras_sin_espacios"
   IMAP_HOST="imap.gmail.com"
   ```

---

## 2. Configuración de Google Drive (Almacenamiento)
Dado que las cuentas estándar de Gmail no permiten que las "Cuentas de Servicio" (Bots) consuman espacio de almacenamiento, el sistema utiliza el flujo **OAuth2** para subir archivos actuando directamente en nombre de la cuenta de usuario (aprovechando sus 15GB).

### Pasos:
1. **Crear Proyecto y Habilitar la API:**
   - Ingresa a [Google Cloud Console](https://console.cloud.google.com/).
   - Crea un nuevo proyecto (o usa uno existente).
   - Ve a "APIs & Services" -> "Library" y busca **Google Drive API**.
   - Haz clic en **Habilitar** (Enable).

2. **Configurar la Pantalla de Consentimiento OAuth:**
   - Ve a "APIs & Services" -> "OAuth consent screen".
   - Si tu cuenta es institucional (Workspace), elige "Interno" (recomendado, el token nunca expirará). Si es una cuenta gratuita de Gmail, elige "Externo" y en la etapa de "Test Users" agrega el correo con el que iniciarás sesión.
   - Completa los nombres y correos obligatorios y guarda. (Si elegiste "Externo", asegúrate de hacer clic en "Publish App" al finalizar para evitar que el token caduque en 7 días).

3. **Crear el ID de Cliente (Client ID):**
   - Ve a "Credentials" (Credenciales).
   - "Create Credentials" -> "OAuth client ID".
   - Tipo de aplicación: **Web application**.
   - En "Authorized redirect URIs" (URIs de redireccionamiento autorizados), agrega exactamente: `http://localhost:3000`
   - Haz clic en Crear. Copia el **Client ID** y el **Client Secret**.

4. **Generar el Refresh Token:**
   - Coloca el Client ID y Secret en tu archivo `.env`.
   - Ejecuta en tu terminal el script `npx ts-node get-refresh-token.ts` (ubicado en `app/backend`).
   - Sigue los pasos en la consola para iniciar sesión, autorizar la app y pegar el código generado.
   - El script te arrojará el `GOOGLE_REFRESH_TOKEN`.

6. **Obtener el ID de la Carpeta (GOOGLE_DRIVE_FOLDER_ID):**
   - Entra a tu [Google Drive](https://drive.google.com/).
   - Crea una nueva carpeta donde quieres que el sistema guarde los archivos (ej: "Archivos SIGMA").
   - Entra en esa carpeta haciendo doble clic.
   - Observa la barra de direcciones (URL) de tu navegador. Tendrá un formato similar a: `https://drive.google.com/drive/folders/1A2b3C4d5E6f7G8h9I0j-kLmNoPqRsTuV`
   - Copia la serie de caracteres que está después de `folders/` (en el ejemplo: `1A2b3C4d5E6f7G8h9I0j-kLmNoPqRsTuV`). Ese es tu ID de carpeta.

7. **Variables de entorno (`.env`):**
   ```env
   GOOGLE_CLIENT_ID="tu-client-id"
   GOOGLE_CLIENT_SECRET="tu-client-secret"
   GOOGLE_REFRESH_TOKEN="el-token-generado"
   GOOGLE_DRIVE_FOLDER_ID="ID-copiado-en-el-paso-anterior"
   ```

---

## 3. Configuración de Google Gemini (Inteligencia Artificial)
Para la extracción y categorización de datos de los pasajes o PDFs (multimodalidad).

### Pasos:
1. Ingresa a [Google AI Studio](https://aistudio.google.com/app/apikey).
2. Asegúrate de estar logueado con una cuenta que no tenga restricciones institucionales bloqueantes.
3. Haz clic en el botón azul **"Create API Key"**.
4. Copia la cadena de texto (debe comenzar con `AIza...`).

5. **Variables de entorno (`.env`):**
   ```env
   GEMINI_API_KEY="AIza..."
   ```
