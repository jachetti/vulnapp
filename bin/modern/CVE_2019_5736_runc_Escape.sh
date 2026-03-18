#!/bin/bash
# Attack: CVE-2019-5736 runc Container Escape
# MITRE ATT&CK: Privilege Escalation - T1611, T1068
# Severity: CRITICAL
# Description: Demonstrates the CVE-2019-5736 vulnerability concept
# CVE: CVE-2019-5736

set -e
echo "[+] Starting: CVE-2019-5736 runc Container Escape"
echo "[+] MITRE ATT&CK: T1611 - Escape to Host, T1068 - Exploitation for Privilege Escalation"
echo "[+] Severity: CRITICAL"
echo "[+] CVE: CVE-2019-5736"
echo ""

echo "[*] Step 1: Understanding CVE-2019-5736..."
echo "[*] Vulnerability Details:"
echo "    - Affects: runc < 1.0-rc6"
echo "    - Impact: Container escape to host root"
echo "    - Method: Overwrite host runc binary"
echo "    - Trigger: When host executes 'docker exec'"
echo ""
echo "[*] Technical explanation:"
echo "    1. Attacker runs malicious code in container"
echo "    2. Code waits for 'docker exec' from host"
echo "    3. When triggered, opens /proc/self/exe (runc)"
echo "    4. Overwrites runc binary on host"
echo "    5. Next container operation executes malicious runc"
echo "    6. Attacker gains root on host"

echo ""
echo "[*] Step 2: Checking runc version..."
if command -v runc &> /dev/null; then
    RUNC_VERSION=$(runc --version 2>/dev/null | head -1)
    echo "[*] runc version: $RUNC_VERSION"

    # Check if vulnerable
    if echo "$RUNC_VERSION" | grep -qE "runc version 1\.0-rc[1-5]|runc version 0\."; then
        echo "[!] VULNERABLE: runc version is < 1.0-rc6"
    else
        echo "[+] Not vulnerable: runc is patched"
    fi
else
    echo "[!] runc command not available in container"
    echo "[*] This is expected - runc runs on host, not in container"
fi

echo ""
echo "[*] Step 3: Exploit technique overview..."
echo "[*] The exploit requires:"
echo "    1. Running container with malicious payload"
echo "    2. Wait for 'docker exec' or 'kubectl exec'"
echo "    3. Overwrite /proc/self/exe (points to host runc)"
echo "    4. Next container operation triggers backdoor"

echo ""
echo "[*] Step 4: Exploit code structure (simplified)..."
cat << 'EOF'
// Pseudocode for CVE-2019-5736 exploit

func main() {
    // Wait for docker exec to be called
    waitForExec()

    // Open /proc/self/exe - points to host runc
    fd := openRunceexe("/proc/self/exe", O_RDONLY | O_CLOEXEC)

    // Read current runc binary
    runcBinary := readRuncBinary(fd)

    // Overwrite with malicious payload
    maliciousPayload := createBackdoor()
    overwriteRunc(fd, maliciousPayload)

    // Host is now compromised
    // Next 'docker run' will execute backdoor
}
EOF

echo ""
echo "[*] Step 5: Checking exploit conditions..."
echo "[*] Exploit prerequisites:"
echo "    - Container must be privileged OR"
echo "    - Container has CAP_SYS_ADMIN OR"
echo "    - AppArmor/SELinux not enforcing"

echo ""
echo "[*] Checking if /proc/self/exe is accessible..."
if [ -L /proc/self/exe ]; then
    echo "[+] /proc/self/exe is accessible"
    SELF_EXE=$(readlink /proc/self/exe)
    echo "[*] Points to: $SELF_EXE"
else
    echo "[!] Cannot access /proc/self/exe"
fi

echo ""
echo "[*] Step 6: Exploitation scenario..."
echo "[*] Real attack flow:"
echo ""
echo "    Terminal 1 (Attacker in container):"
echo "    # Run exploit and wait for docker exec"
echo "    ./exploit"
echo "    [*] Waiting for docker exec..."
echo ""
echo "    Terminal 2 (Victim on host):"
echo "    # Admin runs docker exec"
echo "    docker exec -it container_id /bin/bash"
echo ""
echo "    Terminal 1 (Attacker):"
echo "    [+] docker exec detected!"
echo "    [+] Overwriting runc binary..."
echo "    [+] Host compromised!"
echo ""
echo "    Terminal 2 (Victim):"
echo "    # Next container operation:"
echo "    docker run alpine echo hello"
echo "    # ^ Executes attacker's backdoor as root!"

echo ""
echo "[*] Step 7: Post-exploitation..."
echo "[*] After successful exploit:"
echo "    1. Attacker's code runs as root on host"
echo "    2. Full control of Docker host"
echo "    3. Access to all containers"
echo "    4. Can install persistent backdoors"
echo "    5. Compromise entire container infrastructure"

echo ""
echo "[*] Step 8: Mitigation and detection..."
echo "[*] Mitigation:"
echo "    - Update runc to >= 1.0-rc6"
echo "    - Use SELinux/AppArmor"
echo "    - Avoid privileged containers"
echo "    - Monitor /proc/self/exe access"
echo ""
echo "[*] Detection:"
echo "    - Monitor for runc binary modifications"
echo "    - Alert on /proc/self/exe write attempts"
echo "    - Watch for suspicious docker exec usage"
echo "    - File integrity monitoring on /usr/bin/runc"

echo ""
echo "[*] Step 9: Checking host for signs of compromise..."
echo "[*] In a real scenario, check:"
echo "    - Verify runc binary integrity:"
echo "      sha256sum /usr/bin/runc"
echo "    - Check runc modification time:"
echo "      stat /usr/bin/runc"
echo "    - Review docker logs for suspicious exec:"
echo "      journalctl -u docker | grep exec"

echo ""
echo "[*] Step 10: Related vulnerabilities..."
echo "[*] Similar container escape CVEs:"
echo "    - CVE-2019-5736: runc overwrite (this one)"
echo "    - CVE-2020-15257: containerd TOCTOU"
echo "    - CVE-2022-0847: Dirty Pipe (kernel)"
echo "    - CVE-2021-30465: runc mount"

echo ""
echo "[✓] CVE-2019-5736 simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Wait for docker/kubectl exec"
echo "    - Overwrite host runc binary"
echo "    - Gain root access on host"
echo "    - Compromise all containers"
echo "    - Install persistent backdoors"
echo ""
echo "[!] Expected detections:"
echo "    - runc binary modification"
echo "    - /proc/self/exe access from container"
echo "    - File integrity monitoring alerts"
echo "    - Suspicious container behavior"
echo "    - Privilege escalation attempts"
echo ""
echo "[i] References:"
echo "    - https://nvd.nist.gov/vuln/detail/CVE-2019-5736"
echo "    - https://blog.dragonsector.pl/2019/02/cve-2019-5736-escape-from-docker-and.html"
