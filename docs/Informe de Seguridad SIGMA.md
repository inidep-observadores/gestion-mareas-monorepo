# Informe de Seguridad — Sistema SIGMA
**INIDEP — Instituto Nacional de Investigación y Desarrollo Pesquero**
**Versión:** 1.0 | **Fecha:** Mayo 2026 | **Clasificación:** Uso Interno

---

## Resumen Ejecutivo

SIGMA (Sistema Integral de Gestión de Mareas) es una aplicación web institucional de arquitectura cliente-servidor compuesta por:

- **Backend**: API RESTful desarrollada en **NestJS** (Node.js / TypeScript), base de datos **PostgreSQL** gestionada mediante el ORM **Prisma**.
- **Frontend**: SPA (Single Page Application) desarrollada en **Vue 3** con TypeScript.
- **Infraestructura de producción**: Contenedores Docker detrás de un reverse proxy **Traefik** con terminación TLS/HTTPS automática vía Let's Encrypt.

El sistema fue diseñado con seguridad en capas (_defense in depth_), aplicando controles tanto en el frontend como en el backend. La principal preocupación institucional —la exfiltración no autorizada de datos— está mitigada mediante una combinación de controles de autenticación, autorización basada en roles, auditoría completa de acciones y transporte cifrado. A continuación se detalla cada capa.

---

## 1. Autenticación y Gestión de Sesiones

### 1.1 Mecanismo de Autenticación

La autenticación se implementa con **JSON Web Tokens (JWT)** usando la librería `passport-jwt` integrada a NestJS.

| Componente | Detalle |
|---|---|
| **Access Token** | JWT de corta duración (configurado en `JWT_SECRET`), enviado en el header `Authorization: Bearer <token>`. |
| **Refresh Token** | JWT de 7 días de duración, almacenado en una **cookie `HttpOnly`**, inaccesible desde JavaScript del navegador. |
| **Cookie de Refresh** | `httpOnly: true`, `secure: true` (solo HTTPS en producción), `sameSite: 'none'` en producción / `'lax'` en desarrollo. |

```typescript
// auth.controller.ts — configuración de la cookie de refresh
const cookieOptions = {
  httpOnly: true,
  secure: process.env.NODE_ENV === 'production',
  sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax',
};
```

**Por qué esto protege contra exfiltración:** El Refresh Token es la credencial de larga duración. Al estar en una cookie `HttpOnly`, un script malicioso inyectado (ataque XSS) **no puede leerla ni enviarla a un servidor externo**.

### 1.2 Validación de Token en Cada Solicitud

La estrategia JWT (`JwtStrategy`) valida en cada solicitud protegida que:

1. El token sea criptográficamente válido (firma con `JWT_SECRET`).
2. El usuario exista en la base de datos.
3. El usuario esté **activo** (`isActive = true`).

```typescript
// jwt.strategy.ts
async validate(payload: JwtPayload): Promise<User> {
  const user = await this.prisma.user.findUnique({ where: { id } });
  if (!user) throw new UnauthorizedException('Token no válido');
  if (!user.isActive) throw new UnauthorizedException('Usuario inactivo');
  delete user.password; // La contraseña NUNCA se retorna
  return user;
}
```

Un administrador puede **desactivar una cuenta** (`isActive = false`) y cualquier token activo de ese usuario queda invalidado en la próxima solicitud.

### 1.3 Hashing de Contraseñas

Las contraseñas se almacenan con **bcrypt** (10 rondas de salt). Nunca se almacena la contraseña en texto plano ni en logs.

```typescript
// hash.service.ts
hash(plainText: string, saltRounds: number = 10): string {
  return bcrypt.hashSync(plainText, saltRounds);
}
```

### 1.4 Recuperación de Contraseña

- Se genera un token criptográfico con `crypto.randomBytes(32)`.
- El token tiene **expiración de 30 minutos**.
- El token se marca como `used: true` tras ser utilizado (no es reutilizable).
- La actualización de contraseña y el marcado del token como usado ocurren en una **transacción atómica** de Prisma.

### 1.5 Política de Contraseñas

El DTO de creación de usuarios impone mediante `class-validator` que toda contraseña:
- Tenga entre 6 y 50 caracteres.
- Contenga al menos una mayúscula, una minúscula y un número o carácter especial.

---

## 2. Autorización Basada en Roles (RBAC)

### 2.1 Roles del Sistema

| Rol | Descripción |
|---|---|
| `admin` | Acceso total. Gestión de usuarios, auditoría, backups, exportación. |
| `coordinador` | Gestión operativa de mareas y protocolización. |
| `planificador` | Acceso al módulo de planificación. |
| `tecnico_datos` | Carga y edición de datos técnicos. |
| `asistente_administrativo` | Soporte administrativo básico. |
| `visitante` | Acceso de solo lectura (sin acceso a datos sensibles). |
| `invitado` | Redirigido a página de "Acceso Restringido", sin funcionalidad. |

### 2.2 Guardias de Autorización (Backend)

La autorización se aplica en el backend mediante dos guardias encadenados:

1. **`AuthGuard('jwt')`**: Verifica que el token sea válido.
2. **`UserRoleGuard`**: Compara los roles del usuario autenticado con los roles requeridos por el endpoint.

```typescript
// user-role.guard.ts
for (const role of user.roles) {
  if (validRoles.includes(role)) return true;
}
throw new ForbiddenException(`Usuario necesita rol: [${validRoles}]`);
```

El decorador `@Auth(ValidRoles.admin)` combina ambos guardias en una sola declaración. Esto garantiza que incluso si el frontend intenta acceder a un endpoint sin los permisos correctos, el backend rechaza la solicitud con **HTTP 403 Forbidden**.

### 2.3 Guardias de Navegación (Frontend)

El router Vue implementa un `beforeEach` que verifica antes de cada navegación:

1. Si la ruta requiere autenticación (`requiresAuth: true`) y el usuario no está autenticado → redirige al login.
2. Si la ruta requiere roles específicos y el usuario no los posee → redirige al Dashboard.
3. Si el usuario tiene rol `invitado` → queda atrapado en `/unauthorized`.

**Nota importante:** Esta verificación en el frontend es una **mejora de experiencia de usuario**, no un control de seguridad. El control real reside en el backend.

---

## 3. Protección de Datos en Tránsito (HTTPS/TLS)

En el entorno de producción recomendado, la comunicación externa entre el navegador del usuario y el reverse proxy (Traefik) se realiza sobre **HTTPS** con certificados TLS.

```yaml
# docker-compose-inidep.yaml (extracto)
labels:
  - "traefik.http.routers.sigma-backend.tls=true"
  - "traefik.http.routers.sigma-backend.entrypoints=websecure"
```

- **Cifrado en tránsito externo**: El tráfico entre el navegador del cliente y el proxy Traefik está cifrado con TLS. Esto mitiga de forma robusta el riesgo de espionaje pasivo de datos (como el sniffing en redes Wi-Fi compartidas).
- **Terminación TLS en el Proxy**: El cifrado TLS finaliza en Traefik. A partir de allí, el tráfico se redirige en texto plano (HTTP) a los contenedores correspondientes (`backend-inidep` y `frontend-inidep`) a través de la red virtual interna de Docker (`sigma-network`).
- **Consideraciones para Intranets**: Si la aplicación se despliega en servidores locales de INIDEP accesibles directamente por IP (ej: `http://192.168.x.x`) o bajo dominios sin certificados TLS firmados por una Autoridad de Certificación (CA) de confianza (como en el caso de certificados autofirmados que obligan al usuario a omitir las advertencias del navegador), no se garantizará la protección contra ataques Man-in-the-Middle (MITM) y el tráfico podría ser interceptado.
- **Entorno de Desarrollo**: En desarrollo local (`localhost`), la comunicación se realiza por HTTP en texto plano. No se debe transmitir información real ni sensible en este entorno.
- **Cookies de Sesión**: Las cookies que contienen el Refresh Token se configuran con la directiva `secure: true` en producción, garantizando que el navegador solo las transmita a través de conexiones HTTPS.

---

## 4. Protección contra Ataques Web Comunes

### 4.1 Inyección SQL

SIGMA utiliza **Prisma ORM** como capa de acceso a datos. Prisma utiliza **consultas parametrizadas** internamente, lo que elimina el riesgo de inyección SQL por construcción. Ninguna consulta concatena strings de entrada del usuario directamente en SQL.

### 4.2 Cross-Site Scripting (XSS)

- **Vue 3** escapa automáticamente el contenido dinámico en plantillas (interpolación `{{ }}`), previniendo XSS reflejado.
- El Refresh Token está protegido con `HttpOnly`, por lo que incluso si hubiera una vulnerabilidad XSS, el atacante **no puede robar la sesión de larga duración**.
- Los logs de auditoría sanitizan los datos antes de persistirlos.

### 4.3 Cross-Site Request Forgery (CSRF)

- La política `sameSite: 'none'` en la cookie de Refresh Token, combinada con la configuración de CORS restrictiva, reduce el vector de ataque CSRF.
- Las peticiones de mutación (POST/PUT/PATCH/DELETE) requieren el Access Token en el header `Authorization`, lo que CSRF no puede forjar desde otro origen.

### 4.4 Configuración CORS Estricta

Solo los orígenes explícitamente configurados pueden realizar solicitudes a la API:

```typescript
// main.ts
const rawOrigins = [
  'http://localhost:5173',
  'https://mareas-obs.netlify.app',
  // + FRONTEND_URL desde variable de entorno
];
app.enableCors({
  origin: cleanOrigins,
  credentials: true,
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
  allowedHeaders: 'Content-Type, Accept, Authorization',
});
```

Las peticiones desde dominios no autorizados son **rechazadas por el navegador** antes de llegar al servidor.

### 4.5 Validación de Input (Backend)

El `ValidationPipe` global de NestJS, configurado con `whitelist: true` y `forbidNonWhitelisted: true`, garantiza que:

- Solo los campos declarados en el DTO son procesados.
- Cualquier campo extra en el body de la petición es **rechazado automáticamente**.
- Los tipos y formatos son validados con `class-validator` antes de que la lógica de negocio los procese.

```typescript
// main.ts
app.useGlobalPipes(new ValidationPipe({
  whitelist: true,
  forbidNonWhitelisted: true,
  transform: true,
}));
```

---

## 5. Sistema de Auditoría

### 5.1 Alcance de la Auditoría

SIGMA cuenta con un sistema de auditoría de **cuatro dimensiones** persistidas en la base de datos:

| Tipo | Tabla | Qué registra |
|---|---|---|
| **API** | `AuditoriaApi` | Cada solicitud HTTP: ruta, método, código de respuesta, usuario, IP, tiempo de respuesta. |
| **Eventos** | `AuditoriaEvento` | Acciones de negocio: login, logout, creación/modificación de mareas, importaciones. |
| **Entidades** | `AuditoriaEntidad` | Cambios a datos: valores anteriores y nuevos de cada campo modificado (historial de cambios). |
| **Navegación** | `AuditoriaNavegacion` | Rutas visitadas por el usuario en el frontend, con sesión y timestamps. |

### 5.2 Implementación Técnica

- Un **interceptor global** (`AuditInterceptor` + `AuditEventInterceptor`) captura automáticamente todas las solicitudes y sus resultados sin necesidad de código adicional en cada controlador.
- Los registros se procesan de forma **asíncrona** mediante una cola Bull (Redis) para no impactar la performance de la API.
- Los registros tienen **3 reintentos automáticos** en caso de fallo de persistencia.
- Si falla la auditoría, el error se registra en `ErrorLog` para garantizar trazabilidad.

### 5.3 Sanitización de Datos en Logs

Antes de persistir cualquier registro de auditoría, la función `sanitizeObject` **oculta automáticamente** los campos sensibles:

```typescript
export const SENSITIVE_FIELDS = [
  'password', 'newPassword', 'token', 'accessToken',
  'refreshToken', 'authorization', 'cookie', 'secret', ...
];
// Los valores son reemplazados por '***REDACTED***'
```

Las contraseñas, tokens y credenciales **nunca aparecen en los logs de auditoría**.

### 5.4 Quién Puede Ver los Logs

El acceso al panel de auditoría (`/admin/audit`) está restringido exclusivamente al rol `admin`, tanto en el frontend (guard de navegación) como en el backend (guard de roles).

---

## 6. Protección de Datos Sensibles

### 6.1 Datos en Reposo

- La base de datos PostgreSQL reside en un contenedor Docker con **red interna privada** (`sigma-network`), inaccesible directamente desde internet.
- Los backups se almacenan en el directorio local del servidor (`./backups`), protegidos por los permisos del sistema operativo del VPS.

### 6.2 Variables de Entorno y Secretos

Todos los secretos (contraseña de BD, JWT Secret, credenciales SMTP) se gestionan mediante variables de entorno en el archivo `.env` del servidor, **nunca en el código fuente**. El `.gitignore` excluye los archivos `.env` del repositorio.

### 6.3 Contraseñas Nunca Expuestas

La contraseña del usuario es eliminada del objeto antes de cualquier respuesta:

```typescript
// En login, registro y validación JWT:
const { password: _, ...result } = user;
return { user: result, token: ... };
```

### 6.4 Exportación de Datos (Funcionalidad Controlada)

El módulo de exportación de datos (`/admin/data-export`) está restringido al rol `admin`. Toda exportación queda registrada en el sistema de auditoría.

---

## 7. Manejo Seguro de Errores

El filtro global `AllExceptionsFilter` intercepta todas las excepciones no controladas y garantiza que:

1. El stacktrace y detalles internos **nunca se exponen al cliente** (solo se retorna un mensaje genérico para errores 5xx).
2. Los errores quedan **registrados en la base de datos** (`ErrorLog`) con contexto completo para diagnóstico interno.
3. Se registra el usuario (si está autenticado) y la IP de origen.

```typescript
// Respuesta al cliente en error 500:
{ statusCode: 500, message: 'Se ha producido un error inesperado. Por favor, contacte al administrador.' }
```

---

## 8. Infraestructura y Despliegue

### 8.1 Aislamiento por Contenedores

Cada servicio (backend, base de datos) corre en su propio contenedor Docker:
- La BD no expone puertos públicos; solo es accesible desde la red interna `sigma-network`.
- El backend es el único punto de acceso a los datos.

### 8.2 Imagen Docker Multi-Stage

El Dockerfile usa construcción en dos etapas (_multi-stage build_):
- La etapa `builder` compila el código TypeScript.
- La imagen final solo contiene el código compilado y dependencias de producción, **sin herramientas de desarrollo, código fuente TypeScript ni archivos de configuración sensibles**.

### 8.3 Reverse Proxy Traefik

Traefik actúa como punto de entrada único:
- Termina TLS/HTTPS.
- Solo redirige al backend el tráfico del dominio configurado.
- Redirige automáticamente HTTP a HTTPS.

---

## 9. Análisis de Vectores de Ataque y Mitigaciones

| Vector de Ataque | Riesgo | Mitigación Implementada |
|---|---|---|
| Robo de sesión por XSS | 🟡 Medio | Refresh Token en `HttpOnly` cookie; Access Token de corta duración |
| Inyección SQL | 🟢 Bajo | Prisma ORM con consultas parametrizadas |
| Acceso no autorizado a API | 🟢 Bajo | JWT + RBAC en cada endpoint protegido |
| Exfiltración de contraseñas | 🟢 Bajo | bcrypt + nunca se retornan en respuestas |
| CSRF | 🟡 Medio | Token en header `Authorization` + `SameSite` en cookie |
| Exposición de datos por CORS | 🟢 Bajo | Lista blanca de orígenes estricta |
| Acceso a BD desde internet | 🟢 Bajo | BD en red interna Docker sin puertos públicos |
| Fuerza bruta de contraseñas | 🟠 Pendiente | No implementado aún (ver sección 10) |
| Intercepción de tráfico (MITM) | 🟡 Medio-Bajo | HTTPS/TLS en proxy; requiere correcta gestión de certificados en Intranets y desarrollo |
| Escalada de privilegios | 🟢 Bajo | Roles verificados en servidor, no solo en cliente |
| Exfiltración de logs con datos sensibles | 🟢 Bajo | Sanitización automática de campos sensibles |

---

## 10. Brechas de Seguridad Identificadas y Recomendaciones

Las siguientes son áreas donde la seguridad puede fortalecerse en versiones futuras:

### 10.1 Rate Limiting / Protección contra Fuerza Bruta (Prioridad Alta)

**Situación actual:** No existe un límite de intentos de login. Un atacante puede probar contraseñas de forma automatizada sin restricción.

**Recomendación:** Implementar `@nestjs/throttler` con una regla de, por ejemplo, máximo 10 intentos por IP en 15 minutos sobre el endpoint `POST /api/auth/login`.

```typescript
// Ejemplo de implementación recomendada:
@Throttle({ default: { limit: 10, ttl: 900000 } })
@Post('login')
loginUser(...) { ... }
```

### 10.2 Rotación y Lista Negra de Refresh Tokens (Prioridad Media)

**Situación actual:** Los Refresh Tokens no se invalidan en la base de datos al hacer logout. Aunque se borra la cookie, un atacante que haya capturado el token (ej: acceso físico al dispositivo) podría seguir usándolo hasta que expire (7 días).

**Recomendación:** Implementar una tabla `refresh_token_blacklist` o un modelo `ActiveSession` en la BD, y verificar su vigencia en cada uso del refresh endpoint.

### 10.3 Headers de Seguridad HTTP (Prioridad Media)

**Situación actual:** No se configuran headers de seguridad como `Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options` o `Strict-Transport-Security`.

**Recomendación:** Integrar el paquete `helmet` de NestJS:

```typescript
// En main.ts:
import helmet from 'helmet';
app.use(helmet());
```

### 10.4 Validación de Tipo de Archivo en Subidas (Prioridad Media)

**Situación actual:** El módulo `FilesModule` gestiona subida de archivos. Se recomienda verificar que se validen los tipos MIME y extensiones permitidas.

**Recomendación:** Validar el tipo MIME real del archivo (no solo la extensión), limitar el tamaño máximo y almacenar archivos fuera del directorio público del servidor web.

### 10.5 Endpoint de Registro Público (Prioridad Baja-Media)

**Situación actual:** El endpoint `POST /api/auth/register` es público. En un entorno institucional, el registro de usuarios debería ser gestionado exclusivamente por administradores.

**Recomendación:** Proteger el endpoint de registro con `@Auth(ValidRoles.admin)` y deshabilitar el acceso público, o implementar un flujo de "invitación por email" controlado.

### 10.6 Logging de Errores Interno con Datos de Request (Resuelta)

**Estado:** Mitigado / Resuelto.

**Detalle:** Se modificó el filtro global de excepciones `AllExceptionsFilter` para importar y aplicar la función `sanitizeObject` sobre el `request.body` antes de registrarlo en la propiedad `detail` del `ErrorLog`. Con esto, cualquier campo sensible como contraseñas, tokens u otros queda ofuscado como `'***REDACTED***'` automáticamente al ocurrir cualquier error o excepción en las solicitudes del backend.

### 10.7 Enumeración de Usuarios en la Recuperación de Contraseñas (Resuelta)

**Estado:** Mitigado / Resuelto.

**Detalle:** Se unificó el comportamiento del endpoint `POST /api/auth/forgot-password` en el `AuthService`. Si el correo electrónico suministrado no se encuentra en la base de datos o pertenece a una cuenta de usuario inactiva, el sistema ahora responde con un código de éxito y el mensaje genérico inespecífico: *"Si el correo existe y está activo, se enviaron instrucciones"*, en lugar de lanzar excepciones que delaten la existencia o estado del usuario. Se han verificado las pruebas unitarias para confirmar que en estos casos de error no se genera token de restablecimiento ni se intenta enviar correo electrónico de forma real.

---

## 11. Conclusión y Calificación General de Seguridad

SIGMA implementa un conjunto sólido de controles de seguridad alineados con las mejores prácticas de desarrollo web moderno. La arquitectura de separación entre frontend (SPA) y backend (API) implica que **todos los controles de acceso a datos están centralizados en el servidor**, independientemente de lo que el cliente pueda hacer o no.

**El riesgo de filtración de datos por fuera de la aplicación es BAJO** en el estado actual, dado que:
- Los datos solo son accesibles autenticándose con credenciales válidas.
- Todas las operaciones quedan registradas en el sistema de auditoría.
- El transporte externo recomendado se cifra mediante HTTPS/TLS en el reverse proxy (con las excepciones identificadas de entornos de desarrollo locales y redes internas sin configurar con certificados válidos).
- La base de datos no es accesible directamente desde internet.

Las brechas críticas identificadas como resueltas (sanitización de datos en logs de error y remediación de la enumeración de usuarios) fortalecen de forma sustancial la seguridad de la aplicación. Las brechas restantes (Rate Limiting, Refresh Token Blacklist, HTTP Security Headers) son mejoras incrementales que elevarían la postura de seguridad de **Nivel Aceptable** a **Nivel Robusto**, y se recomienda abordarlas en próximas iteraciones antes del despliegue en producción definitivo.

---

## Apéndice: Tecnologías de Seguridad Utilizadas

| Tecnología | Versión/Librería | Propósito |
|---|---|---|
| JWT | `@nestjs/jwt`, `passport-jwt` | Autenticación stateless |
| bcrypt | `bcrypt` | Hash de contraseñas |
| Prisma ORM | `prisma` | Prevención de SQL Injection |
| class-validator | `class-validator` | Validación de input |
| Passport.js | `@nestjs/passport` | Estrategias de autenticación |
| CORS | NestJS built-in | Control de orígenes permitidos |
| cookie-parser | `cookie-parser` | Gestión de cookies HttpOnly |
| Traefik + Let's Encrypt | Docker labels | TLS/HTTPS automático |
| Docker | Multi-stage build | Aislamiento y superficie reducida |
| Bull Queue | `@nestjs/bull` | Auditoría asíncrona resiliente |

---

*Documento preparado por el equipo de desarrollo SIGMA — INIDEP*
*Para consultas técnicas, contactar al área de Sistemas.*
