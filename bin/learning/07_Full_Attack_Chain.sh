#!/bin/bash
# Learning Scenario 7: Complete Attack Chain
# CTF FLAG: FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}
# Points: 300 - MASTER LEVEL

set +e
echo "════════════════════════════════════════════════════════════════"
echo "  🎯 LEARNING SCENARIO 7: Complete Attack Chain"
echo "  Web Exploit → Container → Escape → Cloud Compromise"
echo "  CTF Points: 300 | Difficulty: ★★★★★ MASTER"
echo "════════════════════════════════════════════════════════════════"
echo ""

echo "📚 BRINGING IT ALL TOGETHER"
echo ""
echo "This scenario combines everything you've learned:"
echo "  ✓ Remote shell (Scenario 1)"
echo "  ✓ Process discovery (Scenario 2)"
echo "  ✓ Credential theft (Scenario 3)"
echo "  ✓ Container escape (Scenario 4)"
echo "  ✓ Docker socket (Scenario 5)"
echo "  ✓ Kubernetes API (Scenario 6)"
echo ""
echo "Real-world attack timeline: 10-15 minutes"
echo "Without detection: 287 days average to discover"
echo ""
sleep 3

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏱️  MINUTE 0-2: Initial Compromise"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[+] Attacker finds SQL injection in web app..."
echo "[+] Escalates to command injection..."
echo "[+] Establishes reverse shell..."
echo "✅ Initial access achieved"
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏱️  MINUTE 2-4: Discovery"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
whoami
echo "[*] Running as root in container ✓"
cat /proc/1/cgroup | head -2
echo "[*] Confirmed in container ✓"
ls -la /var/run/docker.sock 2>/dev/null && echo "[!] Docker socket accessible!" || echo "[*] No docker socket"
test -f /var/run/secrets/kubernetes.io/serviceaccount/token && echo "[!] K8s token found!" || echo "[*] Not in K8s"
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏱️  MINUTE 4-6: Credential Theft"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[+] Dumping environment variables..."
env | grep -iE "key|secret|password" | head -3 || echo "[Simulated] AWS_SECRET_KEY=wJalrXUt..."
echo "[+] Reading K8s token..."
test -f /var/run/secrets/kubernetes.io/serviceaccount/token && cat /var/run/secrets/kubernetes.io/serviceaccount/token | cut -c1-40 || echo "[Simulated] eyJhbGciOiJSUzI1NiIsImtpZCI6..."
echo "✅ Credentials stolen"
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏱️  MINUTE 6-8: Container Escape Attempt"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[+] Attempting escape..."
chroot / echo "Host access!" 2>/dev/null || echo "[Simulated] Escape successful - now on host"
echo "✅ Host compromised"
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏱️  MINUTE 8-10: Lateral Movement"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[Simulated] Using K8s token to:"
echo "  • List all pods across all namespaces"
echo "  • Deploy cryptominer to all nodes"
echo "  • Steal database credentials"
echo "  • Exfiltrate customer data"
echo "✅ Full cluster compromised"
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 MASTER CTF CHALLENGE COMPLETE!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🏆 CONGRATULATIONS! 🏆"
echo ""
echo "You've completed all 7 learning scenarios and understand:"
echo "  ✓ How container attacks work"
echo "  ✓ Why containers are different from endpoints"
echo "  ✓ What makes container escapes possible"
echo "  ✓ How Kubernetes adds new attack surfaces"
echo "  ✓ Why behavior detection is critical"
echo ""
echo "🚩 MASTER FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}"
echo "   Points: 300"
echo "   Total Points: 1,000 (all scenarios)"
echo ""
echo "FINAL BREACH IMPACT:"
cat << 'FINALIMPACT'

╔════════════════════════════════════════════════════════════╗
║            COMPLETE INFRASTRUCTURE COMPROMISE               ║
╠════════════════════════════════════════════════════════════╣
║ Timeline: 10 minutes                                       ║
║ Systems compromised: 47 containers, 12 nodes, 1 cluster   ║
║ Data stolen: Customer DB (2.3M records), API keys, certs  ║
║ Estimated cost: $4.5M + regulatory fines                   ║
║                                                            ║
║ WITH FALCON:                                               ║
║ • 12 detections in real-time                               ║
║ • Security team alerted in <1 minute                       ║
║ • Attack stopped before data exfiltration                  ║
║ • Cost avoided: $4.5M                                      ║
╚════════════════════════════════════════════════════════════╝

FINALIMPACT
echo ""
sleep 3

bash crowdstrike_test_high 2>/dev/null || true

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  🎓 SE CERTIFICATION COMPLETE"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "You're now ready to:"
echo "  ✅ Demo container security to customers"
echo "  ✅ Explain container vs endpoint security"
echo "  ✅ Answer technical questions with confidence"
echo "  ✅ Position Falcon Container Security value"
echo ""
echo "CUSTOMER DEMO TIPS:"
echo ""
echo "1. Start with familiar concepts (processes, shells)"
echo "2. Show the container escape (the 'wow' moment)"
echo "3. Highlight Falcon detections at each stage"
echo "4. End with business impact ($4.5M saved)"
echo ""
echo "OFFICE HOURS TALKING POINTS:"
echo ""
echo "'Container security isn't about antivirus anymore. It's about"
echo " detecting attackers abusing the infrastructure. Falcon sees"
echo " the behavior patterns that indicate compromise - reverse shells,"
echo " escape attempts, abnormal API calls - in real-time.'"
echo ""
echo "🚩 Master Flag: FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}"
echo "🎯 Next: Customer Demo Scenario (ready for real calls!)"
echo ""
echo "════════════════════════════════════════════════════════════════"
