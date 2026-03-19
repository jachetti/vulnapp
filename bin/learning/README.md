# 🎓 VulnApp Learning Scenarios for SE Office Hours

## Overview

These 6 progressive learning scenarios are designed for **CrowdStrike endpoint SEs** learning container security. Each scenario bridges familiar endpoint security concepts to container-specific attacks.

## 🎯 CTF-Style Learning

Each scenario includes:
- **Capture The Flag** challenges with point values
- **Simulated stolen data** to show business impact
- **SE talking points** for customer conversations
- **Falcon detection explanations** in plain English

### Points System:
- **Scenarios 1-2:** 50 points each (Basics)
- **Scenario 3:** 100 points (Data theft)
- **Scenario 4:** 150 points (Container escape - KEY)
- **Scenario 5:** 200 points (Persistence)
- **Scenario 6:** 450 points (Master level)
- **Total:** 1,000 points for completion

---

## 📚 Learning Path

### **Level 1: Familiar Territory (Scenarios 1-2)**
*Map endpoint concepts to containers*

#### Scenario 1: Remote Access Shell (50 pts)
**Flag:** `FLAG{reverse_shell_works_same_in_containers}`
**Concept:** Containers are processes - shells work the same way
**Endpoint Parallel:** PsExec, Remote Desktop, PowerShell remoting
**Duration:** 5 min

#### Scenario 2: Process Discovery (50 pts)
**Flag:** `FLAG{discovered_container_boundaries_and_limits}`
**Concept:** Reconnaissance looks the same, but scope is limited
**Endpoint Parallel:** tasklist, netstat, systeminfo
**Teaches:** Namespace isolation, Docker socket detection, K8s discovery
**Duration:** 5 min

### **Level 2: Container Attacks (Scenarios 3-4)**
*Data theft and container-specific threats*

#### Scenario 3: Data Collection & Exfiltration (100 pts)
**Flag:** `FLAG{credentials_stolen_data_staged_for_exfiltration}`
**Concept:** Data theft business impact - credential hunting, data staging, C2 beacons
**Shows:** Simulated $147M data breach
**Endpoint Parallel:** Mimikatz, credential dumping, data exfiltration
**Duration:** 7 min

#### Scenario 4: Container Escape (150 pts)
**Flag:** `FLAG{container_isolation_bypassed_welcome_to_host}`
**Concept:** THE key difference - breaking container isolation
**Endpoint Parallel:** VM escape, sandbox breakout
**Duration:** 7 min
**⭐ Key SE Learning Moment:** This attack doesn't exist in traditional endpoint security!

### **Level 3: Advanced Threats (Scenarios 5-6)**
*Persistence and complete attack chains*

#### Scenario 5: Persistence Establishment (200 pts)
**Flag:** `FLAG{backdoors_established_attacker_can_return_anytime}`
**Concept:** Backdoor techniques and long-term threats
**Shows:** Binary masquerading, C2 beacons, supply chain poisoning, DaemonSets
**Endpoint Parallel:** Scheduled tasks, registry run keys, services
**Duration:** 8 min
**Teaches:** Dwell time costs ($4.5M breach average)

#### Scenario 6: Full Attack Chain (450 pts)
**Flag:** `FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}`
**Concept:** Web exploit → Container → Escape → Cloud compromise
**Shows:** Complete 10-minute breach timeline
**Duration:** 10 min
**Perfect for:** Demonstrating why customers need Falcon Container Security

---

## 🎓 For Office Hours Facilitators

### Session Structure (60 minutes):

**1. Introduction (5 min)**
- "Who here has worked with containers?"
- "Today we'll map what you know about endpoints to containers"
- "Each scenario has a CTF flag - track your points!"

**2. Scenarios 1-2: Basics (10 min)**
- Quick demos showing familiar attacks work the same
- Emphasize: "See? Same commands you already know"
- Pause for questions after each

**3. Scenario 3: Data Theft (7 min)**
- Show business impact with simulated $147M breach
- "This is why customers care about detection speed"

**4. Scenario 4: Container Escape (10 min)**
- **This is the KEY moment** - container escape
- This is where "aha!" happens
- "This attack doesn't exist on traditional endpoints!"

**5. Scenario 5: Persistence (10 min)**
- Show long-term threat and dwell time costs
- Backdoors, supply chain, DaemonSets

**6. Scenario 6: Full Chain (10 min)**
- Show complete breach
- Highlight Falcon detections at each stage
- Business impact discussion

**7. Q&A & Certification (5 min)**
- Common customer questions
- SE certification recognition
- Next steps for customer demos

---

## 💡 SE Teaching Points

### Key Messages to Reinforce:

1. **Containers Are Familiar:**
   - "Same commands, same techniques"
   - "If you've done endpoint security, you know 70% of this"

2. **Container Escapes Are The Difference:**
   - "This is why container security exists"
   - "Traditional EPP can't detect container escapes"

3. **Behavior Detection Is Critical:**
   - "No malware files to block"
   - "Falcon detects suspicious patterns, not signatures"

4. **Business Impact Is Clear:**
   - "$4.5M average breach cost"
   - "287 days average detection time without Falcon"
   - "Real-time detection = stopping breach before data theft"

---

## 🎬 Customer Demo Readiness

After completing all 6 scenarios, SEs can:

✅ Explain containers in < 5 minutes
✅ Demonstrate container escape (the "wow" moment)
✅ Answer technical questions confidently
✅ Position Falcon value with business impact
✅ Handle objections about RBAC, K8s security, etc.

---

## 📊 Expected Falcon Detections

Each scenario generates these detections:

| Scenario | Detections | Severity |
|----------|------------|----------|
| 1. Remote Shell | BashReverseShell, TestTriggerHigh | High |
| 2. Discovery | GenReverseShell (if in shell) | High |
| 3. Data Collection | GenericDataCollection, IntelDomainHigh | High |
| 4. Escape | **ContainerEscape** | Critical |
| 5. Persistence | ExecutionLin, IntelDomainHigh | Critical |
| 6. Full Chain | 10-15 detections across all tactics | Critical/High |

---

## 🚀 Quick Start for Office Hours

```bash
# On demo machine:
docker run -p 80:80 vulnapp:2.0

# Navigate to: http://localhost
# Click "🎓 Learning Scenarios"
# Follow scenarios 1-6 in order
# Collect all flags (1,000 points total!)
```

---

## 🏆 SE Certification

**Upon completing all 6 scenarios, SE earns:**
- ✅ VulnApp Container Security Certification
- ✅ 1,000 CTF points
- ✅ All 6 flags collected
- ✅ Ready to demo to customers
- ✅ Confident in container security positioning

---

## 📝 Common Customer Questions (Covered in Scenarios)

**Q: "How is this different from endpoint security?"**
**A:** Covered in Scenario 4 - Container escapes don't exist on traditional endpoints

**Q: "What's the business impact of a container breach?"**
**A:** Covered in Scenario 3 - Simulated $147M data breach example

**Q: "How do attackers maintain access?"**
**A:** Covered in Scenario 5 - Persistence techniques including supply chain poisoning

**Q: "What's the ROI?"**
**A:** Covered in Scenario 6 - $4.5M average breach cost avoided with real-time detection

---

## 🎯 Next Steps

After office hours, SEs can:
1. Practice 1-2 scenarios again on their own (~45 minutes)
2. Run customer demo using specific scenarios
3. Use scenarios in POCs and workshops
4. Customize scenarios for specific industries

---

**Built for CrowdStrike SE Education | Office Hours Ready | CTF-Style Learning**
