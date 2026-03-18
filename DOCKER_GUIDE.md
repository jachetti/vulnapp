# Docker Build & Deployment Guide

## Overview

VulnApp v2.0 uses a **multi-stage Docker build** to create an optimized container image:

1. **Stage 1 (Node):** Builds React frontend → `/static/`
2. **Stage 2 (Go):** Builds Go backend → `/shell2http`
3. **Stage 3 (Runtime):** Combines everything in CrowdStrike detection-container base

---

## Quick Build & Run

### Standard Build

```bash
# Build the image
docker build -t vulnapp:2.0 .

# Run the container
docker run -p 80:80 --name vulnapp vulnapp:2.0

# Access the application
open http://localhost
```

### Build with Cache Busting

```bash
# Force rebuild without cache
docker build --no-cache -t vulnapp:2.0 .
```

---

## Build Process

### What Happens During Build

**Stage 1: Frontend Builder**
```bash
[1/3] Building React frontend...
  ✓ Installing npm dependencies
  ✓ Running TypeScript compiler
  ✓ Building with Vite
  ✓ Optimizing assets
  → Output: /frontend/dist/
```

**Stage 2: Backend Builder**
```bash
[2/3] Building Go backend...
  ✓ Downloading Go modules
  ✓ Compiling Go code
  ✓ Stripping debug symbols
  → Output: /shell2http
```

**Stage 3: Runtime Assembly**
```bash
[3/3] Assembling runtime image...
  ✓ Copying Go binary
  ✓ Copying React build
  ✓ Copying attack scripts (24)
  ✓ Copying images
  ✓ Setting permissions
  → Final image ready
```

### Expected Build Time

- **First build:** 3-5 minutes (downloading dependencies)
- **Subsequent builds:** 30-60 seconds (cached layers)
- **No-cache build:** 3-5 minutes

### Expected Image Size

- **Final image:** ~150-200 MB
- **Base image (detection-container):** ~100 MB
- **Application layer:** ~50-100 MB

---

## Run Configurations

### Basic Run

```bash
docker run -p 80:80 vulnapp:2.0
```

### Run with Docker Socket (for Docker socket exploitation demo)

```bash
docker run -p 80:80 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  vulnapp:2.0
```

⚠️ **Warning:** This grants the container access to Docker socket. Only use in isolated lab environments.

### Run with HostPath Mount (for HostPath attack demo)

```bash
docker run -p 80:80 \
  -v /tmp:/host-tmp \
  vulnapp:2.0
```

### Run in Privileged Mode (for privileged escape demo)

```bash
docker run -p 80:80 --privileged vulnapp:2.0
```

⚠️ **Warning:** Privileged mode disables security features. Lab use only.

### Run with Specific Capabilities

```bash
docker run -p 80:80 \
  --cap-add=SYS_ADMIN \
  --cap-add=SYS_PTRACE \
  vulnapp:2.0
```

### Run on Host Network (for LAN testing)

```bash
docker run --network host vulnapp:2.0
```

This binds directly to port 80 on the host (no port mapping needed).

### Run with Custom Port

```bash
# Map port 8080 on host to port 80 in container
docker run -p 8080:80 vulnapp:2.0

# Access at http://localhost:8080
```

### Run in Background (Detached)

```bash
docker run -d -p 80:80 --name vulnapp vulnapp:2.0
```

### Run with Environment Variables

```bash
docker run -p 80:80 \
  -e ATTACK_MODE=advanced \
  -e LOG_LEVEL=debug \
  vulnapp:2.0
```

---

## Container Management

### View Logs

```bash
# Follow logs in real-time
docker logs -f vulnapp

# View last 100 lines
docker logs --tail 100 vulnapp
```

### Execute Commands Inside Container

```bash
# Get a shell
docker exec -it vulnapp /bin/sh

# Run specific command
docker exec vulnapp ps aux

# Run attack script directly
docker exec vulnapp /bin/existing/Execution_via_Command-Line_Interface.sh
```

### Check Health

```bash
# Health status
docker inspect vulnapp | grep -A 5 Health

# Manual health check
docker exec vulnapp wget -q --spider http://localhost/api/health && echo "Healthy" || echo "Unhealthy"
```

### Stop and Remove

```bash
# Stop container
docker stop vulnapp

# Remove container
docker rm vulnapp

# Stop and remove in one command
docker rm -f vulnapp
```

---

## Advanced Docker Configurations

### Docker Compose

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  vulnapp:
    image: vulnapp:2.0
    container_name: vulnapp
    ports:
      - "80:80"
    volumes:
      # Optional: Mount Docker socket for socket exploitation demo
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost/api/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 5s
```

Run with:
```bash
docker-compose up -d
```

### Multi-Container LAN Setup

For your Docker + LAN environment with attacker machines:

```yaml
version: '3.8'

networks:
  vulnapp-lab:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

services:
  vulnapp:
    image: vulnapp:2.0
    container_name: vulnapp
    networks:
      vulnapp-lab:
        ipv4_address: 172.20.0.10
    ports:
      - "80:80"
    restart: unless-stopped

  # Simulated attacker (Kali-like)
  attacker:
    image: kalilinux/kali-rolling
    container_name: attacker
    networks:
      vulnapp-lab:
        ipv4_address: 172.20.0.100
    stdin_open: true
    tty: true
    command: /bin/bash
```

---

## Building for Different Architectures

### ARM64 (Apple Silicon, ARM servers)

```bash
docker build --platform linux/arm64 -t vulnapp:2.0-arm64 .
```

### Multi-Architecture Build

```bash
# Build for both AMD64 and ARM64
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t vulnapp:2.0 \
  --push \
  .
```

---

## Pushing to Registry

### Docker Hub

```bash
# Tag image
docker tag vulnapp:2.0 yourusername/vulnapp:2.0

# Login
docker login

# Push
docker push yourusername/vulnapp:2.0
```

### Private Registry

```bash
# Tag for private registry
docker tag vulnapp:2.0 registry.company.com/security/vulnapp:2.0

# Push
docker push registry.company.com/security/vulnapp:2.0
```

### CrowdStrike Quay.io

```bash
# Tag for Quay
docker tag vulnapp:2.0 quay.io/crowdstrike/vulnapp:2.0

# Login to Quay
docker login quay.io

# Push
docker push quay.io/crowdstrike/vulnapp:2.0
```

---

## Troubleshooting

### Build Fails at Frontend Stage

**Error:** `npm install` fails

**Solution:**
```bash
# Clear npm cache
cd frontend
rm -rf node_modules package-lock.json
npm cache clean --force

# Rebuild
docker build --no-cache -t vulnapp:2.0 .
```

### Build Fails at Backend Stage

**Error:** `go mod download` fails

**Solution:**
```bash
# Verify go.mod is valid
go mod verify

# Try building locally first
go build -v .

# Rebuild Docker image
docker build -t vulnapp:2.0 .
```

### Container Won't Start

**Check logs:**
```bash
docker logs vulnapp
```

**Common issues:**
- Port 80 already in use → Use different port: `-p 8080:80`
- Permission denied → Run with sudo or add user to docker group
- Health check failing → Verify `/api/health` endpoint works

### Frontend Not Loading

**Verify static files:**
```bash
# Check if dist directory was created
docker exec vulnapp ls -la /static/

# Check if frontend files exist
docker exec vulnapp ls -la /static/assets/
```

**If missing:**
```bash
# Rebuild frontend locally first
cd frontend
npm run build

# Verify dist/ exists
ls -la dist/

# Rebuild Docker image
docker build -t vulnapp:2.0 .
```

### API Endpoints Not Working

**Test directly:**
```bash
docker exec vulnapp wget -q -O- http://localhost/api/health
```

**Check if shell2http is running:**
```bash
docker exec vulnapp ps aux | grep shell2http
```

### Attack Scripts Not Executing

**Verify scripts exist:**
```bash
docker exec vulnapp ls -la /bin/existing/
docker exec vulnapp ls -la /bin/modern/
```

**Check permissions:**
```bash
docker exec vulnapp ls -la /bin/existing/Defense_Evasion_via_Rootkit.sh
```

Should show: `-rwxr-xr-x` (executable)

**Test script directly:**
```bash
docker exec vulnapp /bin/existing/Execution_via_Command-Line_Interface.sh
```

---

## Security Considerations

### ⚠️ WARNING: INTENTIONALLY VULNERABLE

This container is **INTENTIONALLY VULNERABLE** for security training:

**DO NOT:**
- ❌ Deploy on production networks
- ❌ Expose to public internet
- ❌ Run on systems with sensitive data
- ❌ Use without proper network isolation

**DO:**
- ✅ Run only in isolated lab environments
- ✅ Use dedicated VLANs/subnets
- ✅ Implement firewall rules
- ✅ Monitor all activities
- ✅ Document usage

### Network Isolation

```bash
# Create isolated network
docker network create --driver bridge \
  --subnet 172.25.0.0/16 \
  --opt com.docker.network.bridge.name=vulnapp-isolated \
  vulnapp-lab

# Run in isolated network
docker run -p 80:80 \
  --network vulnapp-lab \
  vulnapp:2.0
```

### Resource Limits

```bash
# Limit CPU and memory
docker run -p 80:80 \
  --cpus="1.0" \
  --memory="512m" \
  vulnapp:2.0
```

---

## Performance Optimization

### Build Optimization

```bash
# Use BuildKit for faster builds
DOCKER_BUILDKIT=1 docker build -t vulnapp:2.0 .

# Use build cache from registry
docker build \
  --cache-from vulnapp:2.0 \
  -t vulnapp:2.0 \
  .
```

### Runtime Optimization

```bash
# Read-only root filesystem (where possible)
docker run -p 80:80 --read-only \
  --tmpfs /tmp \
  --tmpfs /home/eval \
  vulnapp:2.0
```

---

## Testing the Build

### Quick Validation

```bash
# Build
docker build -t vulnapp:2.0 .

# Run
docker run -d -p 80:80 --name vulnapp vulnapp:2.0

# Wait for startup
sleep 5

# Test health
curl http://localhost/api/health

# Test frontend
curl -I http://localhost/

# Test attack list
curl http://localhost/api/attacks | jq '.count'

# Expected output: 24
```

### Comprehensive Test

```bash
#!/bin/bash
# test-docker.sh

echo "Building image..."
docker build -q -t vulnapp:2.0 . || exit 1

echo "Starting container..."
docker run -d -p 80:80 --name vulnapp-test vulnapp:2.0
sleep 5

echo "Testing health endpoint..."
curl -sf http://localhost/api/health || { echo "FAIL"; exit 1; }

echo "Testing attacks endpoint..."
COUNT=$(curl -s http://localhost/api/attacks | jq -r '.count')
if [ "$COUNT" != "24" ]; then
  echo "FAIL: Expected 24 attacks, got $COUNT"
  exit 1
fi

echo "Testing frontend..."
curl -sf http://localhost/ > /dev/null || { echo "FAIL"; exit 1; }

echo "Cleaning up..."
docker rm -f vulnapp-test

echo "✅ All tests passed!"
```

---

## Next Steps

After building and testing:

1. **Deploy to Kubernetes** - Use updated manifests in `vulnerable.example.yaml`
2. **Set up LAN environment** - Configure Docker network with attacker machines
3. **Test attack scenarios** - Execute all 24 attacks
4. **Validate Falcon detection** - Check CrowdStrike Falcon console
5. **Document findings** - Create test report

---

## Support

For issues:
1. Check logs: `docker logs vulnapp`
2. Verify build: Review build output for errors
3. Test locally: Build and run on local Docker
4. Review documentation: Check README.md files

---

**Docker Configuration: ✅ COMPLETE**
**Ready for: Build & Deployment**
