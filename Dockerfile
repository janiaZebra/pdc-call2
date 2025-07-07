# --- Etapa de compilación ---
FROM node:20-alpine AS builder
WORKDIR /app

# Instala dependencias solo si cambian
COPY package*.json tsconfig.json ./
RUN npm ci

COPY src ./src

# Compila el TypeScript
RUN npm run build

# Copia el twiml.xml (y otros assets si necesitas) a la carpeta compilada
RUN cp src/twiml.xml dist/

# --- Etapa final para producción ---
FROM node:20-alpine
WORKDIR /app

# Solo copia el código ya compilado y el twiml.xml
COPY --from=builder /app/dist ./dist

ENV NODE_ENV=production
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/server.js"]
