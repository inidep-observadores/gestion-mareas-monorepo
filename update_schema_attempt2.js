const fs = require('fs');
const path = require('path');

const schemaPath = path.join(__dirname, '../../app/backend/prisma/schema.prisma');
console.log(`Leyendo schema de: ${schemaPath}`);

try {
    let content = fs.readFileSync(schemaPath, 'utf8');

    // 1. Actualizar generator para incluir multiSchema
    if (!content.includes('multiSchema')) {
        content = content.replace(
            /generator client \{[\s\S]*?\}/,
            `generator client {
  provider        = "prisma-client-js"
  binaryTargets   = ["native", "linux-musl-openssl-3.0.x"]
  previewFeatures = ["multiSchema"]
}`
        );
        console.log('✅ Generator actualizado');
    }

    // 2. Actualizar datasource para incluir schemas
    if (!content.includes('schemas  = ["public", "audit"]')) {
        content = content.replace(
            /datasource db \{[\s\S]*?\}/,
            `datasource db {
  provider = "postgresql"
  schemas  = ["public", "audit"]
}`
        );
        console.log('✅ Datasource actualizado');
    }

    // 3. Agregar @@schema("public") a todos los modelos existentes
    // Buscar todos los @@map() y agregar @@schema("public") después si no existe
    let modelsUpdated = 0;
    content = content.replace(
        /(@@map\("[^"]+"\))(\s*\n)(?!\s*@@schema)/g,
        (match, p1, p2) => {
            modelsUpdated++;
            return `${p1}\n  @@schema("public")${p2}`;
        }
    );
    console.log(`✅ ${modelsUpdated} modelos actualizados con @@schema("public")`);

    // 4. Actualizar modelo User para agregar relaciones con auditoría
    if (!content.includes('auditoriasApi')) {
        content = content.replace(
            /(model User \{[\s\S]*?)(  @@map\("users"\))/,
            `$1  
  // Relaciones con auditoría
  auditoriasApi        AuditoriaApi[]
  auditoriasNavegacion AuditoriaNavegacion[]
  auditoriasEntidad    AuditoriaEntidad[]
  auditoriasEventos    AuditoriaEvento[]

$2`
        );
        console.log('✅ Modelo User actualizado');
    }

    // 5. Agregar modelos de auditoría al final si no existen
    if (!content.includes('model AuditoriaApi')) {
        const auditModels = `
// ============================================
// ESQUEMA AUDIT - Sistema de Auditoría
// ============================================

// Auditoría de peticiones HTTP al backend
model AuditoriaApi {
  id              String   @id @default(uuid()) @db.Uuid
  timestamp       DateTime @default(now()) @db.Timestamptz(6)
  
  // Usuario y sesión
  usuarioId       String?  @map("usuario_id") @db.Uuid
  usuarioEmail    String?  @map("usuario_email")
  sessionId       String?  @map("session_id")
  
  // Request
  metodoHttp      String   @map("metodo_http")
  ruta            String
  rutaBase        String   @map("ruta_base")
  queryParams     Json?    @map("query_params")
  requestBody     Json?    @map("request_body")
  
  // Response
  statusCode      Int      @map("status_code")
  responseBody    Json?    @map("response_body")
  responseTimeMs  Int      @map("response_time_ms")
  
  // Contexto
  ip              String?
  userAgent       String?  @map("user_agent")
  
  // Clasificación
  categoria       String
  accion          String?
  entidadTipo     String?  @map("entidad_tipo")
  entidadId       String?  @map("entidad_id")
  
  // Flags
  esError         Boolean  @default(false) @map("es_error")
  esCritico       Boolean  @default(false) @map("es_critico")
  
  usuario         User?    @relation(fields: [usuarioId], references: [id], onDelete: SetNull)
  
  @@index([usuarioId, timestamp])
  @@index([ruta, timestamp])
  @@index([categoria, timestamp])
  @@index([esError, timestamp])
  @@index([esCritico, timestamp])
  @@map("auditoria_api")
  @@schema("audit")
}

// Auditoría de navegación en el frontend
model AuditoriaNavegacion {
  id              String   @id @default(uuid()) @db.Uuid
  timestamp       DateTime @default(now()) @db.Timestamptz(6)
  
  usuarioId       String?  @map("usuario_id") @db.Uuid
  sessionId       String   @map("session_id")
  
  rutaOrigen      String?  @map("ruta_origen")
  rutaDestino     String   @map("ruta_destino")
  parametros      Json?
  tiempoVistaMs   Int?     @map("tiempo_vista_ms")
  
  usuario         User?    @relation(fields: [usuarioId], references: [id], onDelete: SetNull)
  
  @@index([usuarioId, timestamp])
  @@index([sessionId])
  @@map("auditoria_navegacion")
  @@schema("audit")
}

// Auditoría de cambios en entidades críticas (vía triggers)
model AuditoriaEntidad {
  id                String   @id @default(uuid()) @db.Uuid
  timestamp         DateTime @default(now()) @db.Timestamptz(6)
  
  usuarioId         String?  @map("usuario_id") @db.Uuid
  usuarioEmail      String?  @map("usuario_email")
  
  entidadTipo       String   @map("entidad_tipo")
  entidadId         String   @map("entidad_id")
  operacion         String   // 'INSERT', 'UPDATE', 'DELETE'
  
  valoresAnteriores Json?    @map("valores_anteriores")
  valoresNuevos     Json?    @map("valores_nuevos")
  camposModificados String[] @map("campos_modificados")
  
  contexto          Json?
  
  usuario           User?    @relation(fields: [usuarioId], references: [id], onDelete: SetNull)
  
  @@index([entidadTipo, entidadId, timestamp])
  @@index([usuarioId, timestamp])
  @@index([operacion, timestamp])
  @@map("auditoria_entidad")
  @@schema("audit")
}

// Auditoría de eventos de negocio específicos
model AuditoriaEvento {
  id                    String   @id @default(uuid()) @db.Uuid
  timestamp             DateTime @default(now()) @db.Timestamptz(6)
  
  usuarioId             String?  @map("usuario_id") @db.Uuid
  usuarioEmail          String?  @map("usuario_email")
  
  tipoEvento            String   @map("tipo_evento")
  categoria             String
  
  entidadPrincipal      Json     @map("entidad_principal")
  entidadesRelacionadas Json?    @map("entidades_relacionadas")
  
  descripcion           String
  metadata              Json?
  
  resultado             String   // 'EXITO', 'ERROR', 'PARCIAL'
  mensajeError          String?  @map("mensaje_error")
  
  usuario               User?    @relation(fields: [usuarioId], references: [id], onDelete: SetNull)
  
  @@index([tipoEvento, timestamp])
  @@index([usuarioId, timestamp])
  @@index([categoria, timestamp])
  @@index([resultado, timestamp])
  @@map("auditoria_eventos")
  @@schema("audit")
}
`;
        content += auditModels;
        console.log('✅ Modelos de auditoría agregados');
    }

    fs.writeFileSync(schemaPath, content, 'utf8');
    console.log('✅ Schema actualizado correctamente');
} catch (error) {
    console.error('ERROR:', error.message);
}
