# Informe de Seguridad del Sistema SIGMA
### Para la Dirección del INIDEP

**Sistema:** SIGMA — Sistema Integral de Gestión de Mareas
**Fecha:** Mayo 2026
**Destinatarios:** Dirección General, Autoridades Institucionales

---

## ¿De qué trata este documento?

Este informe responde a la pregunta central que toda autoridad responsable de un sistema informático debe poder contestar:

> **¿Pueden los datos registrados en SIGMA ser vistos, copiados o utilizados por personas no autorizadas?**

La respuesta corta es: **no, y a continuación explicamos por qué.**

---

## ¿Qué información maneja SIGMA y por qué es importante protegerla?

SIGMA centraliza información operativa y científica del programa de Observadores de Pesca del INIDEP: datos de mareas, buques, observadores, capturas y producción pesquera. Esta información tiene valor estratégico y su divulgación no autorizada podría comprometer:

- La integridad de la investigación científica institucional.
- Información sensible sobre flotas y operaciones pesqueras.
- Datos personales y laborales de los observadores.

El sistema fue diseñado con la premisa de que **la información solo debe ser accesible para quienes tienen una necesidad legítima y autorizada de verla**.

---

## Los cinco principios de seguridad que protegen a SIGMA

### Principio 1: Solo entra quien tiene contraseña y permiso

Para acceder a cualquier dato del sistema, un usuario debe:

1. Conocer su dirección de correo electrónico registrada.
2. Conocer su contraseña personal (que solo él conoce).
3. Tener un **nivel de acceso** asignado por el administrador del sistema.

Las contraseñas son almacenadas de forma que **ni siquiera los administradores del sistema pueden verlas**. El sistema guarda una "huella matemática" de la contraseña (similar a guardar la sombra de algo en lugar de la cosa misma), de modo que si alguien accediera a la base de datos, no podría recuperar las contraseñas originales.

Si un usuario escribe mal su contraseña, el sistema **no da pistas** sobre cuál fue el error (no indica si el correo existe o si la contraseña es incorrecta). Esto impide que un atacante pueda deducir información probando distintas combinaciones.

---

### Principio 2: Cada usuario solo puede ver lo que le corresponde

No todos los usuarios de SIGMA tienen acceso a la misma información. El sistema establece **niveles de acceso diferenciados**, similares a los distintos tipos de llave de un edificio: algunas abren solo su oficina, otras abren pisos completos, y solo el administrador general tiene acceso a todo.

| Perfil de usuario | Qué puede hacer |
|---|---|
| **Administrador** | Acceso completo. Gestiona usuarios, ve registros de actividad, realiza copias de seguridad. |
| **Coordinador** | Supervisa y gestiona el flujo de mareas. |
| **Planificador** | Accede al módulo de planificación de coberturas. |
| **Técnico de datos** | Carga y edita información técnica de mareas. |
| **Asistente administrativo** | Apoyo en gestión administrativa básica. |
| **Visitante** | Solo puede consultar, no puede modificar nada. |
| **Invitado** | Acceso denegado a toda funcionalidad. |

Este sistema de perfiles garantiza que, por ejemplo, un técnico de datos **no pueda acceder** al listado completo de usuarios del sistema, ni a los registros de auditoría, ni a las herramientas de exportación masiva de datos. Cada perfil tiene exactamente los permisos que necesita, ni más ni menos.

Esta restricción se aplica tanto en la pantalla que ve el usuario **como en el servidor que procesa los datos**. Aunque alguien intentara "engañar" al sistema accediendo directamente al servidor, las mismas reglas de acceso se aplican allí también.

---

### Principio 3: La comunicación entre el usuario y el sistema está protegida

Toda la información que viaja entre el navegador del usuario y el servidor de SIGMA viaja **cifrada**, de la misma manera que una carta en un sobre sellado que solo el destinatario puede abrir.

Esto significa que si alguien interceptara el tráfico de red (por ejemplo, en una red Wi-Fi compartida), no vería nada útil: solo vería datos ilegibles. Nadie en el camino entre el usuario y el servidor puede espiar la información que se transmite.

---

### Principio 4: Toda acción queda registrada

SIGMA mantiene un **registro completo y permanente** de toda actividad realizada en el sistema. Este registro, conocido como "auditoría", captura automáticamente:

- **Quién** realizó cada acción (nombre de usuario y correo).
- **Qué** hizo exactamente (creó una marea, modificó un dato, exportó un listado, etc.).
- **Cuándo** lo hizo (fecha y hora exactas).
- **Desde dónde** lo hizo (dirección de red del dispositivo utilizado).
- **El resultado** de la acción (si fue exitosa o si fue rechazada).

Este registro es **automático e inmutable**: no puede ser borrado ni modificado por un usuario común. Solo el administrador puede consultarlo, y cada consulta al registro también queda registrada.

La utilidad práctica es doble: **disuade** comportamientos indebidos (los usuarios saben que sus acciones quedan registradas) y **permite investigar** cualquier incidente si este llegara a ocurrir.

Un ejemplo concreto: si alguien descargara un listado masivo de datos a las 2 de la madrugada, el sistema registraría ese evento con todos los datos mencionados arriba, y el administrador podría detectarlo y actuar.

---

### Principio 5: La base de datos no está expuesta a internet

La base de datos donde reside toda la información de SIGMA **no es accesible desde internet**. Vive en una "sala blindada virtual" dentro del servidor, y la única forma de acceder a ella es a través de la aplicación SIGMA misma, que aplica todas las reglas de seguridad descritas en este informe.

Esto significa que aunque alguien conociera la dirección del servidor, no podría conectarse directamente a la base de datos para extraer información. Necesitaría pasar por todas las capas de seguridad de la aplicación.

---

## ¿Qué pasaría si alguien intentara "hackear" el sistema?

A continuación describimos los escenarios de ataque más comunes y cómo SIGMA los enfrenta:

### Escenario A: Alguien intenta adivinar la contraseña de un usuario

**Qué intentaría el atacante:** Probar miles de combinaciones de contraseñas automáticamente hasta dar con la correcta.

**Cómo lo dificulta SIGMA:** Las contraseñas deben cumplir requisitos mínimos de complejidad (mayúsculas, minúsculas, números). El sistema no revela si el intento fue "casi correcto". Adicionalmente, se recomienda implementar un bloqueo automático tras varios intentos fallidos (mejora planificada).

---

### Escenario B: Un usuario autorizado intenta ver datos que no le corresponden

**Qué intentaría:** Modificar la dirección web del sistema para acceder a secciones restringidas, o usar herramientas técnicas para consultar datos de otros usuarios.

**Cómo lo impide SIGMA:** Las restricciones de acceso se verifican en el servidor, no solo en la pantalla. Aunque el usuario manipule lo que ve en su navegador, el servidor rechazará cualquier solicitud que no corresponda a sus permisos. La respuesta del servidor es simplemente "acceso denegado", sin dar información adicional.

---

### Escenario C: Alguien roba la contraseña de un usuario legítimo

**Qué podría hacer:** Iniciar sesión como ese usuario y acceder a su información.

**Cómo lo mitiga SIGMA:** El sistema tiene sesiones de corta duración. Si no hay actividad, la sesión expira y requiere nueva autenticación. Un administrador puede desactivar la cuenta comprometida de forma inmediata, bloqueando todo acceso futuro aunque el atacante tenga la contraseña. Además, el registro de auditoría permitiría detectar accesos inusuales (horario atípico, acciones no habituales del usuario).

---

### Escenario D: Un ex-empleado intenta acceder al sistema

**Qué podría intentar:** Usar sus credenciales anteriores para seguir accediendo.

**Cómo lo impide SIGMA:** El administrador puede desactivar una cuenta en segundos. Desde ese momento, **ningún intento de inicio de sesión con esas credenciales tendrá éxito**, incluso si el sistema no "olvida" la cuenta de inmediato. El desactivado es instantáneo.

---

### Escenario E: Alguien intercepta la conexión de red

**Qué podría intentar:** Capturar el tráfico de red para robar datos o credenciales.

**Cómo lo impide SIGMA:** Todo el tráfico viaja cifrado (equivalente al servicio de correspondencia certificada con sobre inviolable). Incluso capturando el tráfico, el atacante solo obtendría datos ilegibles.

---

## ¿Qué ocurre si algo sale mal dentro del sistema?

SIGMA registra automáticamente cualquier error o anomalía técnica que ocurra, con información de contexto que permite al equipo técnico diagnosticar el problema. Crucialmente, cuando el sistema tiene un error, **el mensaje que ve el usuario es siempre genérico** ("Ocurrió un error inesperado"); los detalles técnicos nunca se muestran al usuario, para no dar información a posibles atacantes.

---

## ¿Qué hay en los archivos de respaldo (backups)?

El sistema genera copias de seguridad periódicas de toda la base de datos. Estas copias:

- Se almacenan en el servidor, en una carpeta protegida.
- Solo el administrador del sistema puede iniciar o restaurar una copia de seguridad.
- Cada operación de backup queda registrada en el sistema de auditoría.

Se recomienda, como buena práctica adicional, replicar estas copias en una ubicación física separada (otro servidor o soporte externo) para mayor resiliencia ante fallas de hardware.

---

## Resumen: ¿Qué nivel de seguridad tiene SIGMA?

A continuación se presenta una evaluación simplificada de los principales aspectos de seguridad:

| Aspecto | Estado | Observación |
|---|---|---|
| Control de acceso por usuario y contraseña | ✅ Implementado | Contraseñas con requisitos de complejidad |
| Perfiles de usuario diferenciados | ✅ Implementado | 7 niveles de acceso distintos |
| Comunicación cifrada | ✅ Implementado | Activo en el entorno de producción |
| Registro de auditoría completo | ✅ Implementado | Todas las acciones quedan registradas |
| Base de datos protegida de acceso externo | ✅ Implementado | No expuesta a internet |
| Bloqueo de cuentas comprometidas | ✅ Implementado | Desactivación inmediata por administrador |
| Almacenamiento seguro de contraseñas | ✅ Implementado | No recuperables, ni por el administrador |
| Bloqueo automático por intentos fallidos | ⚠️ Pendiente | Se recomienda implementar antes del lanzamiento definitivo |
| Copias de seguridad en sitio externo | ⚠️ Recomendado | Para mayor resiliencia ante desastres |

---

## Conclusión

El sistema SIGMA fue construido aplicando estándares modernos de seguridad informática. La probabilidad de que un actor externo acceda a los datos del sistema **sin contar con credenciales válidas** es muy baja. La probabilidad de que un usuario interno acceda a información que no le corresponde también es baja, y cualquier intento queda registrado.

Las dos mejoras identificadas como pendientes (bloqueo automático por intentos fallidos y replicación externa de backups) no representan una vulnerabilidad crítica en el estado actual, pero se recomienda incorporarlas antes del despliegue institucional definitivo para elevar la postura de seguridad al nivel más robusto posible.

El equipo de desarrollo queda a disposición de la Dirección para ampliar cualquier punto de este informe o realizar demostraciones del funcionamiento del sistema.

---

*Documento preparado por el equipo de desarrollo SIGMA — INIDEP*
*Para consultas, contactar al área de Sistemas e Informática.*
