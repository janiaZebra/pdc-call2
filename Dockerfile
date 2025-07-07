# ─── Etapa de build ─────────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json tsconfig.json ./
RUN npm ci

COPY src ./src
COPY twiml.xml ./               # ⬅️ Añade el XML antes de compilar
RUN npm run build
RUN cp twiml.xml dist/          # ⬅️ O muévelo después de compilar

# ─── Imagen final ───────────────────────────────────────────────
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
ENV NODE_ENV=production PORT=8080
EXPOSE 8080
CMD ["node","dist/server.js"]
