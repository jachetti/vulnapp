#!/bin/bash
# Attack: Defense Evasion via Rootkit
# MITRE ATT&CK: Defense Evasion - T1014
# Severity: HIGH
# Description: Demonstrates rootkit installation to hide malicious processes

set -e
echo "[+] Starting: Defense Evasion via Rootkit"
echo "[+] MITRE ATT&CK: T1014 - Rootkit"
echo "[+] Severity: HIGH"
echo ""

echo "[*] Step 1: Checking for root privileges..."
if [ "$(id -u)" -ne 0 ]; then
    echo "[!] Warning: Not running as root - some operations may fail"
fi

echo "[*] Step 2: Simulating rootkit installation..."
echo "[*] Creating hidden directory: /usr/.hidden"
mkdir -p /tmp/.hidden_rootkit 2>/dev/null || true

echo "[*] Step 3: Creating rootkit components..."
cat > /tmp/.hidden_rootkit/loader.sh << 'EOF'
#!/bin/bash
# Simulated rootkit loader
echo "Rootkit loaded - hiding processes..."
EOF
chmod +x /tmp/.hidden_rootkit/loader.sh

echo "[*] Step 4: Simulating process hiding..."
ps aux | grep -v grep | grep bash | head -1

echo "[*] Step 5: Simulating file hiding..."
touch /tmp/.hidden_rootkit/.malware
ls -la /tmp/.hidden_rootkit/

echo ""
echo "[✓] Rootkit simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Load kernel modules to hide processes"
echo "    - Hook system calls"
echo "    - Hide files and network connections"
echo "    - Maintain persistent access"
echo ""
echo "🚩 FLAG CAPTURED!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  FLAG{rootkit_detected_before_kernel_compromise}"
echo ""
echo "  Copy this flag and submit it to earn 50 points!"
echo "════════════════════════════════════════════════════════════════"
