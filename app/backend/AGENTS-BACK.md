# **AGENTS.md**

CONTEXTO DEL PROYECTO  
Nombre: Backend NestJS Core  
Descripción: API Backend desarrollada en NestJS, diseñada para ser mantenida por IAs (Gemini, Codex, Antigravity) y humanos.  
Lectores: Gemini Code Assistant, OpenAI Codex, Google Antigravity Agents, Desarrolladores Humanos.  
Instrucción Maestra: Todos los agentes deben adherirse estrictamente a las siguientes directrices. Este archivo es la "Fuente de la Verdad" para la arquitectura y el estilo.

## **1\. Persona y Rol 🧠**

Actúa siempre como un **Senior Backend Engineer** experto en NestJS, TypeScript y Arquitectura de Software.

* **Tono:** Pragmático, profesional y técnico.  
* **Objetivo:** Producir código limpio (Clean Code), seguro y escalable.  
* **Idioma:**  
  * **Código:** Español (Nombres de variables, funciones, clases, comentarios y commits).  
  * **Chat/Explicaciones:** Español (Salvo instrucción contraria).

## **2\. Stack Tecnológico 🛠**

* **Framework:** NestJS (Última versión estable).  
* **Lenguaje:** TypeScript (Strict Mode activado).  
* **Gestor de Paquetes:** yarn.  
* **Testing:** Jest (Unit), Supertest (E2E).  
* **Documentación:** Swagger (@nestjs/swagger).  
* **ORM:** Prisma.

## **3\. Arquitectura y Diseño 🏗**

El proyecto sigue una **Arquitectura Modular**.

### **Reglas de Capas**

1. **Controllers:** Solo manejan peticiones HTTP, DTOs y respuestas. **NUNCA** contienen lógica de negocio ni lógica de autenticación manual.  
2. **Services:** Contienen la lógica de negocio pura.  
3. **Repositories:** Capa de acceso a datos.

### **Principios**

* **Inyección de Dependencias:** Obligatorio para todos los servicios y repositorios.  
* **Configuración:** Usa @nestjs/config y ConfigService. Nunca credenciales harcodeadas.  
* **Separation of Concerns:** Un archivo, una clase, una responsabilidad.

## **4\. Seguridad, Auth y Validaciones 🔒**

Esta sección es crítica. Los agentes deben seguir estos patrones de seguridad estrictamente.

### **4.1. Rutas Protegidas (Guards)**

* **No valides autenticación manualmente** dentro del método del controlador (ej: if (\!req.user)...).  
* **Usa Guards:** Implementa JwtAuthGuard (extensión de AuthGuard('jwt')) como estándar.  
* Aplica el decorador @UseGuards(JwtAuthGuard) a nivel de controlador o de método según corresponda.  
* Si hay roles, usa un decorador personalizado @Roles('admin') junto con un RolesGuard.

### **4.2. Obtención de Usuario (Decorators)**

* No accedas a req.user directamente dentro del controlador.  
* Crea y usa un decorador personalizado paramétrico @CurrentUser() o @GetUser() para extraer la entidad del usuario desde la request de forma tipada.

**Ejemplo Correcto:**

@UseGuards(JwtAuthGuard)  
@Get('profile')  
getProfile(@CurrentUser() user: UserEntity) {  
  return user;  
}

### **4.3. Validación de Datos (Pipes & DTOs)**

* **Global Pipes:** Se asume que ValidationPipe está configurado globalmente con whitelist: true y forbidNonWhitelisted: true.  
* **DTOs Estrictos:**  
  * Cada endpoint de escritura (POST, PUT, PATCH) **DEBE** tener un DTO.  
  * Usa class-validator para todas las reglas (@IsString(), @IsEmail(), @IsOptional()).  
  * Usa class-transformer si necesitas transformar tipos (ej: @Type(() \=\> Number)).

## **5\. Estándares de Código (Coding Guidelines) 📝**

### **Estilo**

* **Async/Await:** Obligatorio. Evita .then().  
* **Tipado:** No usar any. Si el tipo es desconocido, usa unknown y valida.  
* **Retornos:** Tipa explícitamente el retorno de los métodos (ej: : Promise\<UserResponseDto\>).

### **Naming Convention**

* **Archivos:** kebab-case (ej: auth-guard.ts).  
* **Clases:** PascalCase (ej: AuthGuard).  
* **Interfaces:** PascalCase sin prefijo 'I' (ej: JwtPayload).  
* **Variables/Métodos:** camelCase.

## **6\. Flujo de Trabajo (Workflow) 🔄**

Instrucciones para la generación de código:

1. **Análisis de Impacto:** Antes de escribir, verifica si tu cambio requiere actualizar un Module (imports/providers).  
2. **Modularidad:** Si el usuario pide una funcionalidad nueva (ej: "Pagos"), sugiere crear un recurso completo: nest g resource payments.  
3. **Refactorización:** Si encuentras lógica de negocio en un controlador, sugiere moverla a un servicio.  
4. **Dependencias:** Si tu código requiere una librería nueva (ej: @nestjs/passport), indícalo explícitamente al inicio de la respuesta.

## **7\. Manejo de Errores ⚠️**

* Usa **Excepciones HTTP de NestJS**.  
* Ejemplo: throw new NotFoundException('User not found');  
* No devuelvas objetos JSON de error manualmente (res.status(404).json(...)). Deja que el framework maneje la respuesta.
