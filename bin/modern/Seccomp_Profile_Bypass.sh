#!/bin/bash
# Attack: Seccomp Profile Bypass
# MITRE ATT&CK: Defense Evasion - T1562.001
# Severity: MEDIUM
# Description: Attempts to bypass or disable seccomp security profiles

set -e
echo "[+] Starting: Seccomp Profile Bypass"
echo "[+] MITRE ATT&CK: T1562.001 - Impair Defenses: Disable or Modify Tools"
echo "[+] Severity: MEDIUM"
echo ""

echo "[*] Step 1: Detecting current seccomp status..."
if [ -f /proc/self/status ]; then
    SECCOMP_STATUS=$(grep Seccomp /proc/self/status | awk '{print $2}')
    echo "[*] Seccomp status: $SECCOMP_STATUS"
    echo "    0 = Disabled"
    echo "    1 = Strict mode"
    echo "    2 = Filter mode (most common)"

    case $SECCOMP_STATUS in
        0) echo "[+] Seccomp is DISABLED - no restrictions!" ;;
        1) echo "[!] Seccomp strict mode - very limited syscalls allowed" ;;
        2) echo "[*] Seccomp filter mode - filtered syscalls" ;;
        *) echo "[?] Unknown seccomp status" ;;
    esac
fi

echo ""
echo "[*] Step 2: Listing seccomp filters (if available)..."
if [ -f /proc/self/syscall ]; then
    echo "[*] Current syscall: $(cat /proc/self/syscall 2>/dev/null | head -c 50 || echo 'unknown')"
fi

echo ""
echo "[*] Step 3: Testing restricted syscalls..."
echo "[*] Common syscalls blocked by seccomp:"
echo "    - ptrace (process debugging)"
echo "    - mount/umount (filesystem operations)"
echo "    - reboot (system reboot)"
echo "    - swapon/swapoff (swap management)"
echo "    - kexec_load (kernel loading)"
echo "    - personality (execution domain)"

echo ""
echo "[*] Step 4: Testing ptrace syscall..."
if command -v strace &> /dev/null; then
    echo "[*] Attempting to use strace (requires ptrace):"
    timeout 1 strace ls / > /dev/null 2>&1 && echo "[+] ptrace allowed!" || echo "[!] ptrace blocked by seccomp"
else
    echo "[*] strace not available for testing"
fi

echo ""
echo "[*] Step 5: Testing mount syscall..."
mkdir -p /tmp/test_mount 2>/dev/null || true
if mount -t tmpfs tmpfs /tmp/test_mount 2>/dev/null; then
    echo "[+] mount syscall allowed!"
    umount /tmp/test_mount 2>/dev/null || true
else
    echo "[!] mount syscall blocked"
fi
rmdir /tmp/test_mount 2>/dev/null || true

echo ""
echo "[*] Step 6: Seccomp bypass techniques..."
echo "[*] Technique 1 - Exec to unconfined process:"
echo "    If seccomp is only on parent, fork+exec may escape"
echo ""
echo "[*] Technique 2 - Syscall number confusion:"
echo "    Use alternate syscall numbers (32-bit vs 64-bit)"
echo ""
echo "[*] Technique 3 - Time-of-check-time-of-use (TOCTOU):"
echo "    Race conditions in seccomp filter evaluation"
echo ""
echo "[*] Technique 4 - Container escape:"
echo "    Escape container to bypass seccomp entirely"

echo ""
echo "[*] Step 7: Checking for unconfined profile..."
if grep -q "unconfined" /proc/self/attr/current 2>/dev/null; then
    echo "[+] Running with unconfined profile!"
else
    echo "[*] Not running unconfined"
fi

echo ""
echo "[*] Step 8: Testing dangerous syscalls..."
echo "[*] Attempting to call personality()..."
# personality syscall often blocked
python3 -c "import ctypes; ctypes.CDLL(None).personality(0)" 2>/dev/null && \
    echo "[+] personality() allowed" || echo "[!] personality() blocked"

echo ""
echo "[*] Step 9: Seccomp profile recommendations..."
echo "[*] Kubernetes seccomp profiles:"
echo "    - Unconfined: No restrictions (dangerous)"
echo "    - RuntimeDefault: Docker's default (recommended)"
echo "    - Localhost/<profile>: Custom profile"
echo ""
echo "[*] Check pod's seccomp profile:"
echo "    kubectl get pod \$POD_NAME -o jsonpath='{.spec.securityContext.seccompProfile}'"

echo ""
echo "[*] Step 10: Creating custom seccomp policy bypass..."
echo "[*] If running unconfined, all syscalls available:"
echo ""
echo "    # Allow dangerous operations"
echo "    mount /dev/sda1 /mnt"
echo "    ptrace attach to processes"
echo "    reboot system"

echo ""
echo "[✓] Seccomp bypass simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Identify missing or weak seccomp profile"
echo "    - Execute blocked syscalls"
echo "    - Use alternate syscall paths"
echo "    - Escape via container breakout"
echo "    - Disable security controls"
echo ""
echo "[!] Expected detections:"
echo "    - Container running without seccomp"
echo "    - Attempts to use blocked syscalls"
echo "    - Seccomp violations in audit logs"
echo "    - Privilege escalation attempts"
