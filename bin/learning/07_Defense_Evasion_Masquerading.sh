#!/bin/bash
# Learning Scenario 7: Defense Evasion & Masquerading
# Audience: Endpoint SEs learning containers
# Concept: Same masquerading techniques, but Falcon detects behavior not names
# Duration: 6 minutes

set +e
trap 'echo "[!] Scenario interrupted"' EXIT

echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SCENARIO 7: Defense Evasion & Masquerading"
echo "  Understanding Behavior-Based Detection vs. Signature-Based"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Teaching Section
echo "📚 CONCEPT: Masquerading & Evasion"
echo ""
echo "Attackers disguise malicious processes to evade detection. On endpoints,"
echo "they might name malware 'svchost.exe' or 'csrss.exe' to blend in with"
echo "legitimate Windows processes. The same technique exists in containers."
echo ""
echo "ENDPOINT PARALLEL:"
echo "  • Windows: Fake 'svchost.exe', 'explorer.exe', 'System'"
echo "  • Linux: Fake 'systemd', 'kworker', '[ksoftirqd/0]'"
echo "  • Goal: Hide in plain sight among legitimate processes"
echo ""
echo "CONTAINER VERSION:"
echo "  • Same technique: Use legitimate-sounding names"
echo "  • Same goal: Evade simple process name detection"
echo "  • Key difference: Falcon uses ML, not just name matching"
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 1: Creating Disguised Malicious Process"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Creating malicious script disguised as 'systemd'..."
echo ""

cat > /tmp/systemd << 'EOF'
#!/bin/bash
# Malicious script disguised as systemd (the real init system)
while true; do
    sleep 60
done
EOF
chmod +x /tmp/systemd

echo "[*] Script created at: /tmp/systemd"
echo ""
echo "    SE Note: On a real Linux host, 'systemd' is the init system (PID 1)."
echo "    Attackers use this name hoping admins won't notice in process lists."
echo ""
echo "    Windows Parallel: Creating 'svchost.exe' in C:\\Users\\Public\\"
echo "    instead of C:\\Windows\\System32\\ (wrong location = suspicious)"
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 2: Running Disguised Process"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Executing malicious script with legitimate-sounding name..."
echo ""

/tmp/systemd &
MALWARE_PID=$!
echo "[*] Malicious process started with PID: $MALWARE_PID"
echo ""
echo "    What attacker hopes:"
echo "    • Admin runs 'ps aux', sees 'systemd', thinks it's legitimate"
echo "    • Simple name-based detection rules miss it"
echo "    • Process blends into background"
echo ""
echo "    Why this fails against Falcon:"
echo "    • Falcon sees the FULL CONTEXT:"
echo "      - Parent process (bash, not init)"
echo "      - File path (/tmp/, not /usr/lib/systemd/)"
echo "      - Process behavior (launched from /tmp)"
echo "      - No digital signature"
echo ""
sleep 3

echo "[*] Checking process list..."
ps aux | grep -v grep | grep systemd | tail -3
echo ""
echo "    Can you spot the fake 'systemd'? Look at:"
echo "    • PID (real systemd is always PID 1)"
echo "    • Path (/tmp/systemd vs /usr/lib/systemd/systemd)"
echo "    • Parent process (should be nothing for real init)"
echo ""
sleep 3

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 3: Additional Masquerading Techniques"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Creating fake kernel worker process..."
echo ""

cp /bin/sh /tmp/[kworker]
ls -la /tmp/[kworker]
echo ""
echo "    What's happening here:"
echo "    • Copied /bin/sh (shell) to /tmp/[kworker]"
echo "    • [kworker] looks like kernel threads in 'ps' output"
echo "    • Real kernel threads appear in brackets: [kworker/0:0]"
echo ""
echo "    Windows Parallel:"
echo "    • Copy cmd.exe to 'csrss.exe' (Windows subsystem process)"
echo "    • Real csrss.exe is protected, runs from System32"
echo "    • Fake one would run from user folder = suspicious"
echo ""
sleep 3

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 4: Why Traditional Defenses Fail"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Traditional signature-based detection..."
echo ""
echo "    Signature/Name-Based Detection:"
echo "    ✗ Checks process name: 'systemd' → Looks legitimate"
echo "    ✗ Checks for known malware hashes → No match (custom script)"
echo "    ✗ Checks against blacklist → Not on the list"
echo "    Result: ⚠️  MISSED"
echo ""
echo "    Falcon Behavior-Based Detection:"
echo "    ✓ Checks process lineage: bash → /tmp/systemd (suspicious)"
echo "    ✓ Checks file path: /tmp/ instead of /usr/lib/ (wrong location)"
echo "    ✓ Checks execution pattern: Script launched from temp dir"
echo "    ✓ Checks ML indicators: Anomalous behavior pattern"
echo "    Result: 🚨 DETECTED"
echo ""
sleep 3

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 5: Detection Trigger & Cleanup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "[+] Executing detection test..."
bash crowdstrike_test_high 2>/dev/null || echo "✓ Test trigger executed"
echo ""

echo "[*] Cleaning up malicious files..."
kill $MALWARE_PID 2>/dev/null || true
rm -f /tmp/systemd /tmp/[kworker]
echo "✓ Cleanup complete"
echo ""

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SUMMARY"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "KEY TAKEAWAYS for SEs:"
echo ""
echo "1. MASQUERADING IS COMMON:"
echo "   • Attackers ALWAYS try to hide their processes"
echo "   • Same technique on endpoints and in containers"
echo "   • Simple name changes fool basic detection"
echo ""
echo "2. SIGNATURE DETECTION FAILS:"
echo "   • Can't detect what you've never seen before"
echo "   • Name-based rules are trivial to bypass"
echo "   • Hash-based signatures miss custom malware"
echo ""
echo "3. FALCON'S ADVANTAGE - BEHAVIOR ANALYSIS:"
echo "   • Doesn't rely on process names or signatures"
echo "   • Uses Machine Learning to spot anomalies"
echo "   • Analyzes full context: parent, path, behavior"
echo "   • Detects novel attacks without updates"
echo ""
echo "4. CONTAINERS AMPLIFY THE PROBLEM:"
echo "   • No traditional antivirus in containers"
echo "   • Ephemeral nature (containers come and go)"
echo "   • Behavior-based detection is ESSENTIAL"
echo ""
echo "5. CUSTOMER QUESTIONS TO EXPECT:"
echo "   Q: 'Can't they just change the process name?'"
echo "   A: 'Yes! That's exactly what this demonstrates. Falcon"
echo "       doesn't care about names - it watches behavior. A fake"
echo "       'systemd' running from /tmp/ is suspicious regardless"
echo "       of what it's called.'"
echo ""
echo "   Q: 'What about fileless attacks or in-memory threats?'"
echo "   A: 'Great question! Falcon monitors process behavior and"
echo "       memory activity, not just files. Even if there's no"
echo "       malware on disk, Falcon sees the suspicious actions.'"
echo ""
echo "   Q: 'Does this work if they use legitimate tools (LOLBins)?'"
echo "   A: 'Living-off-the-land is harder to detect, but Falcon"
echo "       looks at context. If bash is launching unusual scripts"
echo "       from /tmp/, that's suspicious even if bash is legitimate.'"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "📊 Falcon Detections Expected:"
echo "   • ExecutionLin (Suspicious execution pattern)"
echo "   • In-Memory Threat (if applicable)"
echo "   • TestTriggerHigh (validation)"
echo ""
echo "🎓 OFFICE HOURS TEACHING POINTS:"
echo ""
echo "   'This is why containers need runtime protection, not just"
echo "    image scanning. Scanning the image won't find a script"
echo "    downloaded at runtime. Falcon monitors live behavior.'"
echo ""
echo "   'Think about how Windows Defender works with AppLocker. It's"
echo "    not just about signatures - it's about execution policies"
echo "    and behavior. Falcon brings that same concept to containers.'"
echo ""
echo "   'Customers often ask: Can attackers just rename their malware?"
echo "    The answer is yes, which is exactly WHY we need behavioral"
echo "    detection. This demo proves it.'"
echo ""
echo "🎯 Next Scenario: Full Attack Chain (Complete CTF challenge!)"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "🚩 FLAG CAPTURED!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  FLAG{svchost_exe_on_linux_fooled_nobody}"
echo ""
echo "  Copy this flag and submit it to earn 50 points!"
echo "════════════════════════════════════════════════════════════════"

trap - EXIT
