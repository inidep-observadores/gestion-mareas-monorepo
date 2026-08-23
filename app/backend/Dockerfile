FROM node:22-alpine AS builder
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@9.15.4 --activate
RUN apk add --no-cache python3 make g++ cairo-dev pango-dev giflib-dev
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --no-frozen-lockfile
COPY . .
RUN pnpm prisma generate
RUN NODE_OPTIONS=--max-old-space-size=4096 pnpm build
# Transpilar semillas para producción
RUN npx tsc prisma/*.ts --lib es2021,dom --skipLibCheck --module commonjs --target es2021 --esModuleInterop --moduleResolution node --outDir prisma
RUN pnpm prune --prod

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
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/prisma.config.js ./prisma.config.js
COPY --from=builder /app/static ./static
CMD ["node", "dist/main"]

