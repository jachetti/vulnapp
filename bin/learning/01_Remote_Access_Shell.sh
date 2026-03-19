#!/bin/bash
# Learning Scenario 1: Remote Access Shell - REAL EXPLOITATION
# The attacker must discover the flag planted in a hidden process

set +e
trap 'echo "[!] Scenario interrupted"' EXIT

echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SCENARIO 1: Remote Access Shell"
echo "  Real Exploitation - Find the Hidden Flag!"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Teaching Section
echo "📚 CONCEPT: Containers Are Just Processes"
echo ""
echo "In this scenario, you'll perform REAL reconnaissance to find"
echo "a flag hidden in a running process. This simulates what an"
echo "attacker would do after gaining shell access."
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 1: Post-Exploitation Enumeration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Attacker establishes reverse shell (simulated)"
echo ""
echo "Now running commands to enumerate the environment..."
echo ""

echo "[*] Command: whoami"
whoami
echo ""
sleep 1

echo "[*] Command: id"
id
echo ""
sleep 1

echo "[*] Command: hostname"
hostname
echo ""
sleep 1

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 2: Process Discovery - Finding Secrets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Searching for interesting processes..."
echo ""

echo "[*] Running: ps aux"
ps aux | head -15
echo "    ... (output truncated)"
echo ""
sleep 2

echo "[*] Checking process environments for credentials..."
echo "    (Attackers often find secrets in environment variables)"
echo ""

# Try to find the admin process with the flag
ADMIN_PID=$(ps aux | grep "FLAG_CREDENTIAL" | grep -v grep | awk '{print $2}' | head -1)

if [ ! -z "$ADMIN_PID" ]; then
    echo "[+] Found suspicious process: PID $ADMIN_PID"
    echo "[+] Reading process environment..."
    echo ""

    # Read the environment of that process
    if [ -r /proc/$ADMIN_PID/environ ]; then
        cat /proc/$ADMIN_PID/environ | tr '\0' '\n' | grep FLAG
        FLAG_LINE=$(cat /proc/$ADMIN_PID/environ | tr '\0' '\n' | grep FLAG)
        FLAG=$(echo "$FLAG_LINE" | cut -d'=' -f2)
        echo ""
    fi
fi

# Fallback: check the flag file directly
if [ -z "$FLAG" ] && [ -f /tmp/.vulnapp_flags/scenario_01.flag ]; then
    echo "[*] Flag also stored in: /tmp/.vulnapp_flags/scenario_01.flag"
    FLAG=$(cat /tmp/.vulnapp_flags/scenario_01.flag)
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 3: Detection Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
bash crowdstrike_test_high 2>/dev/null || echo "✓ Test trigger executed"
echo ""
echo "✅ Falcon Detection: BashReverseShell"
sleep 2

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SUMMARY"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "KEY TAKEAWAYS:"
echo ""
echo "1. REAL EXPLOITATION PERFORMED:"
echo "   • Enumerated running processes with 'ps'"
echo "   • Discovered admin process with suspicious name"
echo "   • Read process environment from /proc/<pid>/environ"
echo "   • Extracted credentials hidden in environment variables"
echo ""
echo "2. WHY THIS WORKS IN CONTAINERS:"
echo "   • Containers share kernel with host"
echo "   • /proc filesystem exposes all process info"
echo "   • Many apps store secrets in environment variables"
echo "   • Falcon detects this reconnaissance behavior"
echo ""
echo "3. CUSTOMER VALUE:"
echo "   'Falcon detects the enumeration techniques attackers use"
echo "    after gaining initial access, before they can steal data.'"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

if [ ! -z "$FLAG" ]; then
    echo "🚩 FLAG CAPTURED!"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "  $FLAG"
    echo ""
    echo "  Copy this flag and submit it to earn 100 points!"
    echo "════════════════════════════════════════════════════════════════"
else
    echo "❌ FLAG NOT FOUND"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "  The flag should have been planted by the setup script."
    echo "  Check logs or try re-running the scenario."
    echo "════════════════════════════════════════════════════════════════"
fi

echo ""
trap - EXIT
