FROM node:18-alpine

# Install curl for the HEALTHCHECK instruction
RUN apk add --no-cache curl

WORKDIR /Backend

# Only copy package files first for better layer caching
COPY package*.json ./
RUN npm install

# Copy application source code
COPY . .

# Native Docker Healthcheck using the /healthz endpoint
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/healthz || exit 1

# Run as a non-root user
# USER node

EXPOSE 3000

CMD ["node", "server.js"]