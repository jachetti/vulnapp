#!/bin/bash
# Attack: Defense Evasion via Masquerading
# MITRE ATT&CK: Defense Evasion - T1036
# Severity: MEDIUM
# Description: Demonstrates process masquerading by disguising malicious processes

set -e
echo "[+] Starting: Defense Evasion via Masquerading"
echo "[+] MITRE ATT&CK: T1036 - Masquerading"
echo "[+] Severity: MEDIUM"
echo ""

echo "[*] Step 1: Creating malicious script disguised as system process..."
cat > /tmp/systemd << 'EOF'
#!/bin/bash
# Malicious script disguised as systemd
while true; do
    sleep 60
done
EOF
chmod +x /tmp/systemd

echo "[*] Step 2: Running malicious script with legitimate-sounding name..."
/tmp/systemd &
MALWARE_PID=$!
echo "[*] Malicious process started with PID: $MALWARE_PID"

echo "[*] Step 3: Checking process list..."
ps aux | grep -v grep | grep systemd | tail -3

echo "[*] Step 4: Creating fake system binary..."
cp /bin/sh /tmp/[kworker]
ls -la /tmp/[kworker]

echo "[*] Step 5: Cleaning up..."
kill $MALWARE_PID 2>/dev/null || true
rm -f /tmp/systemd /tmp/[kworker]

echo ""
echo "[✓] Masquerading simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Use names like 'systemd', 'kworker', 'cron'"
echo "    - Place binaries in legitimate-looking paths"
echo "    - Match file metadata of legitimate binaries"
echo "    - Evade process-based detection"
