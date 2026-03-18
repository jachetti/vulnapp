#!/bin/bash
# Attack: Execution via Command-Line Interface
# MITRE ATT&CK: Execution - T1059.004
# Severity: MEDIUM
# Description: Executes malicious commands via command-line interface

set -e
echo "[+] Starting: Execution via Command-Line Interface"
echo "[+] MITRE ATT&CK: T1059.004 - Command and Scripting Interpreter: Unix Shell"
echo "[+] Severity: MEDIUM"
echo ""

echo "[*] Step 1: System reconnaissance..."
echo "[*] Hostname: $(hostname)"
echo "[*] User: $(whoami)"
echo "[*] Current directory: $(pwd)"

echo ""
echo "[*] Step 2: Process enumeration..."
echo "[*] Current processes:"
ps aux | head -10

echo ""
echo "[*] Step 3: Network enumeration..."
echo "[*] Network interfaces:"
ip addr show 2>/dev/null || ifconfig 2>/dev/null | grep -E "inet |UP" | head -10

echo ""
echo "[*] Step 4: File system enumeration..."
echo "[*] Disk usage:"
df -h | head -5

echo ""
echo "[*] Step 5: Executing payload commands..."
echo "[*] Checking for internet connectivity..."
ping -c 1 8.8.8.8 2>/dev/null && echo "[+] Internet accessible" || echo "[*] No internet"

echo ""
echo "[*] Step 6: Checking for container runtime..."
if [ -f /.dockerenv ]; then
    echo "[+] Running in Docker container"
elif grep -q docker /proc/1/cgroup 2>/dev/null; then
    echo "[+] Running in Docker container (cgroup detected)"
elif grep -q kubepods /proc/1/cgroup 2>/dev/null; then
    echo "[+] Running in Kubernetes pod"
else
    echo "[*] Not in a container"
fi

echo ""
echo "[✓] Command execution completed"
echo "[i] In a real attack, this would:"
echo "    - Execute reconnaissance commands"
echo "    - Download additional payloads"
echo "    - Establish persistence mechanisms"
echo "    - Elevate privileges"
