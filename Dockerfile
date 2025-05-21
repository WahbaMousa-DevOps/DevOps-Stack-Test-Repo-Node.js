# ===============================
# 🏗️ Stage 1: Build the app
# ===============================
FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .


# ===============================
# 🚀 Stage 2: Production runtime
# ===============================

FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /app /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app
USER appuser
EXPOSE 3000
CMD ["node", "server.js"]