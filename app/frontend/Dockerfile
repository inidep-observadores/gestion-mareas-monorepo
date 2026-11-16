# Build stage
FROM node:22-alpine AS build-stage

WORKDIR /app

# Argumentos de compilación configurables
ARG VITE_BACKEND_URL=/api
ARG BUILD_SCRIPT="build-only"
ARG DIST_DIR="dist"

ENV VITE_BACKEND_URL=$VITE_BACKEND_URL

# Instalar pnpm
RUN npm install -g pnpm@9.15.4

# Copiar archivos de definición de dependencias
COPY package.json pnpm-lock.yaml* ./

# Instalar dependencias
RUN pnpm install --no-frozen-lockfile

# Copiar el resto del código
COPY . .

# Construir la aplicación (por defecto producción 'dist', o staging según BUILD_SCRIPT)
RUN NODE_OPTIONS=--max-old-space-size=4096 pnpm $BUILD_SCRIPT

# Production stage
FROM nginx:stable-alpine AS production-stage

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar archivos estáticos compilados desde la etapa de build
ARG DIST_DIR="dist"
COPY --from=build-stage /app/${DIST_DIR} /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
