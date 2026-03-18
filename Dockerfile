# VulnApp v2.0 - Multi-stage Dockerfile
# Stage 1: Build React Frontend
# Stage 2: Build Go Backend
# Stage 3: Final Runtime Image

# ========================================
# Stage 1: Frontend Builder (Node)
# ========================================
FROM node:20-alpine AS frontend-builder

WORKDIR /frontend

# Copy frontend package files
COPY frontend/package*.json ./

# Install dependencies (including dev dependencies needed for build)
RUN npm install

# Copy frontend source
COPY frontend/ ./

# Build React app for production
RUN npm run build

# Output will be in /frontend/dist/

# ========================================
# Stage 2: Backend Builder (Go)
# ========================================
FROM golang:1.23-alpine AS backend-builder

# Install build dependencies
RUN apk add --no-cache git ca-certificates

WORKDIR /build

# Copy Go module files
COPY go.mod ./

# Copy source code (needed for go mod tidy to work)
COPY *.go ./
COPY backend/ ./backend/

# Generate go.sum with all dependencies
RUN go mod tidy

# Download dependencies
RUN go mod download

# Build Go binary
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

RUN go build -v -trimpath \
    -ldflags="-w -s -X 'main.version=2.0.0'" \
    -o /shell2http .

# ========================================
# Stage 3: Final Runtime Image
# ========================================
FROM quay.io/crowdstrike/detection-container

LABEL org.opencontainers.image.source="https://github.com/CrowdStrike/vulnapp"
LABEL org.opencontainers.image.description="VulnApp v2.0 - Container Security Testing Platform"
LABEL org.opencontainers.image.version="2.0.0"

# Create necessary directories
RUN mkdir -p /static /bin/existing /bin/modern /images /home/eval

# Copy Go binary from backend builder
COPY --from=backend-builder /shell2http /shell2http

# Copy React frontend from frontend builder
COPY --from=frontend-builder /frontend/dist/ /static/

# Copy attack scripts
COPY bin/existing/ /bin/existing/
COPY bin/modern/ /bin/modern/

# Make scripts executable
RUN chmod +x /bin/existing/*.sh /bin/modern/*.sh

# Copy images
COPY images/ /images/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working directory
WORKDIR /home/eval

# Expose port 80 (changed from 8080)
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q --spider http://localhost/api/health || exit 1

# Run entrypoint
ENTRYPOINT ["/entrypoint.sh"]
