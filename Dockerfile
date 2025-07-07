FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json tsconfig.json ./
RUN npm ci
COPY src ./src
RUN npm run build
RUN cp src/twiml.xml dist/

FROM node:20-alpine
WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev      # Instala solo las dependencias "production"
COPY --from=builder /app/dist ./dist

ENV NODE_ENV=production
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/server.js"]
