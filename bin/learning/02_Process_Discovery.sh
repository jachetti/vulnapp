#!/bin/bash
# Learning Scenario 2: Process Discovery & Enumeration
# Audience: Endpoint SEs learning containers
# Concept: Reconnaissance looks the same, but container boundaries matter
# Duration: 5 minutes

set +e
trap 'echo "[!] Scenario interrupted"' EXIT

echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SCENARIO 2: Process Discovery & Enumeration"
echo "  Understanding Container Visibility Boundaries"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Teaching Section
echo "📚 CONCEPT: Reconnaissance in Containers"
echo ""
echo "On an endpoint, attackers run discovery commands to understand"
echo "the environment. In containers, the SAME commands work, but with"
echo "a twist: they only see what's inside the container."
echo ""
echo "ENDPOINT PARALLEL:"
echo "  Windows: tasklist, netstat, systeminfo, whoami /priv"
echo "  Linux: ps aux, netstat, uname -a, ifconfig"
echo "  Goal: Map the environment, find targets"
echo ""
echo "CONTAINER VERSION:"
echo "  Same commands, but:"
echo "  • Can't see host processes (isolated)"
echo "  • Can't see other containers (usually)"
echo "  • Limited network visibility"
echo "  • But still get useful information!"
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 1: System Information Discovery"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Attacker gathers system information..."
echo ""

echo "[*] Command: uname -a (kernel information)"
uname -a
echo ""
echo "    SE Note: Kernel version reveals if container is vulnerable"
echo "    to known exploits (e.g., Dirty COW, runc escape)"
echo ""
sleep 2

echo "[*] Command: cat /etc/os-release (OS identification)"
cat /etc/os-release 2>/dev/null | head -5 || echo "OS info unavailable"
echo ""
echo "    SE Note: Helps attacker choose exploits for this OS"
echo ""
sleep 2

echo "[*] Command: hostname"
hostname
echo ""
echo "    SE Note: Often reveals app name, environment (prod/dev)"
echo "    Example: 'webapp-frontend-prod-8f7d9c-xyz'"
echo ""
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 2: Process Enumeration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Discovering running processes..."
echo ""

echo "[*] Command: ps aux"
ps aux
echo ""
echo "    What attacker sees:"
echo "    • Web applications (nginx, apache, node)"
echo "    • Databases (mysql, postgres, redis)"
echo "    • Security tools (falcon-sensor)"
echo "    • Their own shell process"
echo ""
echo "    What attacker DOESN'T see:"
echo "    ✗ Host processes"
echo "    ✗ Other container processes"
echo "    ✗ Hypervisor/VM processes"
echo ""
echo "    SE Note: This is namespace isolation in action!"
echo ""
sleep 3

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 3: Network Discovery"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Network reconnaissance..."
echo ""

echo "[*] Command: ifconfig / ip addr"
ip addr show 2>/dev/null || ifconfig 2>/dev/null || echo "Network info unavailable"
echo ""
echo "    What attacker learns:"
echo "    • Container IP address (usually 172.17.x.x for Docker)"
echo "    • Network interface (eth0)"
echo "    • Confirms they're in a container (not physical host)"
echo ""
sleep 2

echo "[*] Command: netstat -an (active connections)"
netstat -an 2>/dev/null | head -20 || ss -an | head -20
echo "    ... (truncated)"
echo ""
echo "    What attacker sees:"
echo "    • Listening services (port 80, 443, 3306)"
echo "    • Active connections to other services"
echo "    • Potential lateral movement targets"
echo ""
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 4: Container-Specific Discovery"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Checking if this is a container..."
echo ""

echo "[*] Command: cat /proc/1/cgroup"
cat /proc/1/cgroup 2>/dev/null | head -5
echo ""
echo "    If you see 'docker' or 'kubepods' → definitely in container"
echo ""
echo "    SE Note: Process ID 1 (PID 1) in containers is NOT init/systemd"
echo "    like on real hosts. It's usually the application process."
echo ""
sleep 2

echo "[*] Checking for Docker socket..."
if [ -S /var/run/docker.sock ]; then
    echo "⚠️  DOCKER SOCKET FOUND: /var/run/docker.sock"
    ls -la /var/run/docker.sock
    echo ""
    echo "    SE Note: THIS IS CRITICAL!"
    echo "    • Docker socket = full control over Docker"
    echo "    • Attacker can spawn privileged containers"
    echo "    • Can escape to host with root access"
    echo "    • Customer question: 'Why would the socket be mounted?'"
    echo "      Answer: 'Developers do this for convenience, but it's"
    echo "      like leaving the keys in your car.'"
else
    echo "✓ Docker socket not accessible (good!)"
fi
echo ""
sleep 2

echo "[*] Checking for Kubernetes..."
if [ -d /var/run/secrets/kubernetes.io/serviceaccount ]; then
    echo "✓ Kubernetes service account found!"
    echo ""
    echo "    Files:"
    ls -la /var/run/secrets/kubernetes.io/serviceaccount/
    echo ""
    echo "    SE Note: Every Kubernetes pod gets these automatically"
    echo "    • token: API access credentials"
    echo "    • ca.crt: Certificate authority"
    echo "    • namespace: Which namespace we're in"
    echo ""
    echo "    This is like finding domain credentials on a Windows endpoint!"
else
    echo "[i] Not running in Kubernetes"
fi
echo ""
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 5: Detection Trigger"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Executing detection test..."
bash crowdstrike_test_high 2>/dev/null || echo "✓ Test trigger executed"
echo ""

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SUMMARY"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "KEY TAKEAWAYS for SEs:"
echo ""
echo "1. RECONNAISSANCE IS FAMILIAR:"
echo "   • Same commands: ps, netstat, uname, whoami"
echo "   • Same goals: Understand environment, find targets"
echo "   • Same kill chain: Recon → Exploitation → Lateral Movement"
echo ""
echo "2. CONTAINER BOUNDARIES MATTER:"
echo "   • Attacker sees ONLY their container"
echo "   • Can't see host or other containers (usually)"
echo "   • BUT: Docker socket or K8s tokens change everything"
echo ""
echo "3. NEW ATTACK SURFACES:"
echo "   • Docker socket → Host escape"
echo "   • Kubernetes tokens → API access"
echo "   • Shared kernel → Escape potential"
echo ""
echo "4. DETECTION DIFFERENCES:"
echo "   • Traditional EPP: Blocks malware files"
echo "   • Falcon Container: Detects suspicious BEHAVIOR"
echo "   • Why: Containers don't have antivirus, they have runtime protection"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "📊 Falcon Detections Expected:"
echo "   • GenReverseShell (if run from reverse shell)"
echo "   • TestTriggerHigh (validation)"
echo ""
echo "🎓 OFFICE HOURS TEACHING POINTS:"
echo ""
echo "   'Notice how the attacker uses the same commands you'd use"
echo "    to troubleshoot a Linux server. That's why behavior-based"
echo "    detection is critical - there's no malware to block.'"
echo ""
echo "   'The Docker socket is like having the keys to the entire"
echo "    infrastructure. Always ask customers: Are you mounting"
echo "    the Docker socket into containers?'"
echo ""
echo "   'Kubernetes automatically gives every pod credentials. That's"
echo "    like every process on Windows getting domain admin. This is"
echo "    why K8s RBAC (permissions) is so important.'"
echo ""
echo "🎯 Next Scenario: 'Credential Theft' (finding secrets in containers)"
echo ""
echo "════════════════════════════════════════════════════════════════"

trap - EXIT
