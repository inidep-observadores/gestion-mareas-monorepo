FROM node:22-alpine AS builder
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@9.15.4 --activate
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --no-frozen-lockfile
COPY . .
RUN pnpm prisma generate
RUN pnpm build
# Transpilar semillas para producción
RUN npx tsc prisma/*.ts --lib es2021,dom --skipLibCheck --module commonjs --target es2021 --esModuleInterop --moduleResolution node --outDir prisma

FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production
RUN corepack enable && corepack prepare pnpm@9.15.4 --activate
# postgresql-client: migraciones y healthchecks
# cairo, pango, libjpeg-turbo, giflib: requeridos por @napi-rs/canvas en runtime
# fontconfig, ttf-dejavu: gestión de fuentes y fallback sans-serif para Chart.js (Calibri no disponible en Linux)
RUN apk add --no-cache \
    postgresql-client \
    cairo \
    pango \
    libjpeg-turbo \
    giflib \
    fontconfig \
    ttf-dejavu
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --prod --no-frozen-lockfile
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/prisma.config.js ./prisma.config.js
COPY --from=builder /app/static ./static
# Generamos el cliente de Prisma en la imagen final para evitar problemas de rutas con pnpm
RUN npx prisma generate
CMD ["node", "dist/src/main"]
