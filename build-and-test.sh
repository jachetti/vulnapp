#!/bin/bash
# VulnApp v2.0 - Docker Build & Test Script

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=================================================="
echo "  VulnApp v2.0 - Docker Build & Test"
echo "=================================================="
echo ""

# Configuration
IMAGE_NAME="vulnapp"
IMAGE_TAG="2.0"
CONTAINER_NAME="vulnapp-test"
PORT="80"

# Step 1: Build Frontend
echo "📦 Step 1: Building React Frontend"
echo "---------------------------------------------------"
cd frontend

if [ ! -d "node_modules" ]; then
    echo "Installing npm dependencies..."
    npm install
fi

echo "Building production frontend..."
npm run build

if [ ! -d "dist" ]; then
    echo -e "${RED}❌ Frontend build failed - dist/ directory not found${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Frontend built successfully${NC}"
cd ..

# Step 2: Build Docker Image
echo ""
echo "🐳 Step 2: Building Docker Image"
echo "---------------------------------------------------"
echo "Building ${IMAGE_NAME}:${IMAGE_TAG}..."

docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Docker build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker image built successfully${NC}"

# Step 3: Check Image Size
echo ""
echo "📊 Step 3: Image Information"
echo "---------------------------------------------------"
docker images ${IMAGE_NAME}:${IMAGE_TAG}

IMAGE_SIZE=$(docker images ${IMAGE_NAME}:${IMAGE_TAG} --format "{{.Size}}")
echo "Image size: $IMAGE_SIZE"

# Step 4: Start Container
echo ""
echo "🚀 Step 4: Starting Container"
echo "---------------------------------------------------"

# Stop and remove existing container if it exists
docker rm -f ${CONTAINER_NAME} 2>/dev/null || true

echo "Starting container on port ${PORT}..."
docker run -d -p ${PORT}:80 --name ${CONTAINER_NAME} ${IMAGE_NAME}:${IMAGE_TAG}

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to start container${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Container started${NC}"

# Wait for container to be ready
echo ""
echo "⏳ Waiting for container to be ready..."
sleep 5

# Step 5: Test Health
echo ""
echo "🏥 Step 5: Testing Health Endpoint"
echo "---------------------------------------------------"

HEALTH_STATUS=$(curl -s http://localhost:${PORT}/api/health | grep -o '"status":"[^"]*"' | cut -d'"' -f4)

if [ "$HEALTH_STATUS" != "healthy" ]; then
    echo -e "${RED}❌ Health check failed${NC}"
    echo "Container logs:"
    docker logs ${CONTAINER_NAME}
    exit 1
fi

echo -e "${GREEN}✅ Health check passed: $HEALTH_STATUS${NC}"

# Step 6: Test API Endpoints
echo ""
echo "🔍 Step 6: Testing API Endpoints"
echo "---------------------------------------------------"

# Test attacks endpoint
ATTACK_COUNT=$(curl -s http://localhost:${PORT}/api/attacks | grep -o '"count":[0-9]*' | cut -d':' -f2)

if [ "$ATTACK_COUNT" != "24" ]; then
    echo -e "${YELLOW}⚠ Warning: Expected 24 attacks, got ${ATTACK_COUNT}${NC}"
else
    echo -e "${GREEN}✅ Attacks endpoint: ${ATTACK_COUNT} attacks${NC}"
fi

# Test system info
HOSTNAME=$(curl -s http://localhost:${PORT}/api/system/info | grep -o '"hostname":"[^"]*"' | cut -d'"' -f4)
echo -e "${GREEN}✅ System info endpoint: hostname=${HOSTNAME}${NC}"

# Step 7: Test Frontend
echo ""
echo "🌐 Step 7: Testing Frontend"
echo "---------------------------------------------------"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${PORT}/)

if [ "$HTTP_STATUS" != "200" ]; then
    echo -e "${RED}❌ Frontend not accessible (HTTP ${HTTP_STATUS})${NC}"
else
    echo -e "${GREEN}✅ Frontend accessible (HTTP ${HTTP_STATUS})${NC}"
fi

# Test static assets
ASSET_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${PORT}/static/assets/)

echo "Static assets status: HTTP ${ASSET_STATUS}"

# Step 8: Test Attack Execution
echo ""
echo "⚔️  Step 8: Testing Attack Execution"
echo "---------------------------------------------------"

echo "Executing test attack..."
EXEC_RESPONSE=$(curl -s -X POST http://localhost:${PORT}/api/attacks/execution-cli/execute)
EXEC_ID=$(echo $EXEC_RESPONSE | grep -o '"execution_id":"[^"]*"' | cut -d'"' -f4)

if [ -n "$EXEC_ID" ]; then
    echo -e "${GREEN}✅ Attack executed: ${EXEC_ID}${NC}"

    # Wait for execution to complete
    sleep 3

    # Check execution status
    EXEC_STATUS=$(curl -s http://localhost:${PORT}/api/executions/${EXEC_ID} | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
    echo "Execution status: ${EXEC_STATUS}"
else
    echo -e "${YELLOW}⚠ Could not execute attack${NC}"
fi

# Step 9: Show Container Info
echo ""
echo "📋 Step 9: Container Information"
echo "---------------------------------------------------"
docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "Container logs (last 20 lines):"
docker logs --tail 20 ${CONTAINER_NAME}

# Step 10: Summary
echo ""
echo "=================================================="
echo "  ✅ Build & Test Complete!"
echo "=================================================="
echo ""
echo "Container is running and accessible at:"
echo "  Frontend: http://localhost:${PORT}"
echo "  API:      http://localhost:${PORT}/api/attacks"
echo "  Health:   http://localhost:${PORT}/api/health"
echo ""
echo "To view logs:   docker logs -f ${CONTAINER_NAME}"
echo "To stop:        docker stop ${CONTAINER_NAME}"
echo "To remove:      docker rm -f ${CONTAINER_NAME}"
echo ""
echo "Interactive mode:"
echo "  docker exec -it ${CONTAINER_NAME} /bin/sh"
echo ""
echo "Test reverse shell (from attacker machine):"
echo "  1. On attacker: nc -lvnp 4444"
echo "  2. In browser: Navigate to Interactive Reverse Shell"
echo "  3. Enter your attacker IP and execute"
echo ""
echo "=================================================="
