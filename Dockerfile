# ===============================
# Stage 1: Build the app
# ===============================
FROM node:20-slim AS builder

# Set working directory
WORKDIR /app

# Copy only package files first for layer caching
COPY package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev

# Copy the rest of the app source code
COPY . .

# ===============================
# Stage 2: Runtime optimized image
# ===============================
FROM node:20-alpine AS runtime

# Set working directory
WORKDIR /app

# Copy built app from builder stage
COPY --from=builder /app /app

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose default Express port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
