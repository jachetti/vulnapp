#!/bin/bash
# Attack: Container Drift via File Creation and Execution
# MITRE ATT&CK: Defense Evasion - T1612
# Severity: HIGH
# Description: Demonstrates container drift by creating and executing files

set -e
echo "[+] Starting: Container Drift via File Creation and Execution"
echo "[+] MITRE ATT&CK: T1612 - Build Image on Host"
echo "[+] Severity: HIGH"
echo ""

echo "[*] Step 1: Detecting container environment..."
if [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup 2>/dev/null; then
    echo "[+] Running in Docker container"
elif grep -q kubepods /proc/1/cgroup 2>/dev/null; then
    echo "[+] Running in Kubernetes pod"
fi

echo ""
echo "[*] Step 2: Identifying writable locations..."
echo "[*] Testing write permissions in various directories..."
for dir in /tmp /var/tmp /dev/shm /home; do
    if [ -w "$dir" ]; then
        echo "[+] Writable: $dir"
    fi
done

echo ""
echo "[*] Step 3: Creating drift files (files not in original image)..."
DRIFT_DIR="/tmp/container_drift_$(date +%s)"
mkdir -p "$DRIFT_DIR"

echo "[*] Creating malicious binary..."
cat > "$DRIFT_DIR/malware.sh" << 'EOF'
#!/bin/bash
echo "Malware executed - container drift detected!"
echo "This file was NOT in the original container image"
whoami
id
EOF
chmod +x "$DRIFT_DIR/malware.sh"

echo ""
echo "[*] Step 4: Executing drifted file..."
echo "[+] Running: $DRIFT_DIR/malware.sh"
"$DRIFT_DIR/malware.sh"

echo ""
echo "[*] Step 5: Creating additional drift artifacts..."
echo "sensitive_data" > "$DRIFT_DIR/data.txt"
dd if=/dev/zero of="$DRIFT_DIR/binary.bin" bs=1M count=1 2>/dev/null
echo "[+] Created drift files:"
ls -lh "$DRIFT_DIR"

echo ""
echo "[*] Step 6: Simulating persistence attempt..."
echo "[*] Creating startup script..."
cat > "$DRIFT_DIR/startup.sh" << 'EOF'
#!/bin/bash
# This would run on container start
nohup /tmp/malware.sh > /dev/null 2>&1 &
EOF
chmod +x "$DRIFT_DIR/startup.sh"

echo ""
echo "[*] Step 7: Calculating drift size..."
DRIFT_SIZE=$(du -sh "$DRIFT_DIR" | cut -f1)
echo "[*] Total drift size: $DRIFT_SIZE"

echo ""
echo "[*] Cleanup..."
rm -rf "$DRIFT_DIR"

echo ""
echo "[✓] Container drift simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Download malware into container"
echo "    - Execute code not in original image"
echo "    - Create persistence mechanisms"
echo "    - Modify container filesystem"
echo ""
echo "[!] Drift detection tools should detect:"
echo "    - New executable files"
echo "    - File creation in unexpected locations"
echo "    - Process execution from drift files"
echo ""
echo "🚩 FLAG CAPTURED!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  FLAG{runtime_changes_trigger_drift_alert}"
echo ""
echo "  Copy this flag and submit it to earn 50 points!"
echo "════════════════════════════════════════════════════════════════"
