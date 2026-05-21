# Build stage
FROM node:22-alpine AS build-stage

WORKDIR /app

# Instalar pnpm
RUN npm install -g pnpm@9.15.4

# Copiar archivos de definición de dependencias
# Nota: En un monorepo, a veces es necesario copiar archivos de la raíz
# Pero como este frontend parece ser independiente en sus dependencias, 
# intentaremos construirlo directamente.
COPY package.json pnpm-lock.yaml* ./

# Instalar dependencias
RUN pnpm install --frozen-lockfile

# Copiar el resto del código
COPY . .

# Construir la aplicación para staging
RUN pnpm build:staging

# Production stage
FROM nginx:stable-alpine AS production-stage

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar archivos estáticos compilados desde la etapa de build
# Vite por defecto compila a 'dist', pero según vite.config.ts,
# en modo staging el outDir es 'dist-staging'.
COPY --from=build-stage /app/dist-staging /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
