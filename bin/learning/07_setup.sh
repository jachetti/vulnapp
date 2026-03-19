#!/bin/bash
# Setup Script for Scenario 6: Full Attack Chain
# Plants multiple flags for each stage of the attack

set -e

echo "[SETUP] Preparing Full Attack Chain scenario..."

# Stage 1: Web vulnerability
mkdir -p /var/www/html
echo "<?php system(\$_GET['cmd']); ?>" > /var/www/html/vulnerable.php

# Stage 2: Container credentials
mkdir -p /tmp/.stage2
echo "KUBE_TOKEN=eyJhbGciOiJSUzI1NiIsImtpZCI6IkRFRkFVTFQifQ" > /tmp/.stage2/token

# Stage 3: Host access prep
if [ -d /host ]; then
    mkdir -p /host/tmp/vulnapp_chain
    echo "FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}" > /host/tmp/vulnapp_chain/final_flag.txt
    chmod 644 /host/tmp/vulnapp_chain/final_flag.txt
    echo "[SETUP] ✓ Final flag planted on host"
else
    mkdir -p /tmp/.final_flag
    echo "FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}" > /tmp/.final_flag/flag.txt
    echo "[SETUP] ⚠️  Using fallback flag location"
fi

echo "[SETUP] ✓ Multi-stage attack chain prepared"
echo "[SETUP] ✓ Attacker must complete all stages to get flag"
echo "[SETUP] Ready for exploitation!"
