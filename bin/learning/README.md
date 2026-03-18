# 🎓 VulnApp Learning Scenarios for SE Office Hours

## Overview

These 7 progressive learning scenarios are designed for **CrowdStrike endpoint SEs** learning container security. Each scenario bridges familiar endpoint security concepts to container-specific attacks.

## 🎯 CTF-Style Learning

Each scenario includes:
- **Capture The Flag** challenges with point values
- **Simulated stolen data** to show business impact
- **SE talking points** for customer conversations
- **Falcon detection explanations** in plain English

### Points System:
- **Scenario 1-3:** 50 points each (Basics)
- **Scenario 4-5:** 100-150 points (Container-specific)
- **Scenario 6:** 200 points (Kubernetes/Cloud)
- **Scenario 7:** 300 points (Master level)
- **Total:** 1,000 points for completion

---

## 📚 Learning Path

### **Level 1: Familiar Territory (Scenarios 1-3)**
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

#### Scenario 3: Credential Theft (50 pts)
**Flag:** `FLAG{credentials_hidden_in_environment_variables}`
**Concept:** Credentials in different places (env vars, K8s secrets)
**Endpoint Parallel:** Mimikatz, /etc/shadow, SSH keys
**Duration:** 5 min

### **Level 2: Container-Specific Threats (Scenarios 4-5)**
*New attack surfaces that don't exist on traditional endpoints*

#### Scenario 4: Container Escape (100 pts)
**Flag:** `FLAG{container_isolation_bypassed_welcome_to_host}`
**Concept:** THE key difference - breaking container isolation
**Endpoint Parallel:** VM escape, sandbox breakout
**Duration:** 7 min
**⭐ Key SE Learning Moment:** This attack doesn't exist in traditional endpoint security!

#### Scenario 5: Docker Socket Exploitation (150 pts)
**Flag:** `FLAG{docker_socket_gives_root_access_to_everything}`
**Concept:** API abuse for instant host root
**Endpoint Parallel:** Finding domain admin credentials
**Duration:** 6 min
**Shows:** 30-second path from container → host root

### **Level 3: Cloud-Native Attacks (Scenario 6)**
*Kubernetes and cloud-specific threats*

#### Scenario 6: Kubernetes API Exploitation (200 pts)
**Flag:** `FLAG{kubernetes_token_equals_cluster_admin_oops}`
**Concept:** Service account token theft → cluster compromise
**Endpoint Parallel:** Every process having domain admin credentials
**Duration:** 8 min
**Teaches:** #1 Kubernetes attack vector, RBAC importance

### **Level 4: Master Challenge (Scenario 7)**
*Complete attack chain combining all concepts*

#### Scenario 7: Full Attack Chain (300 pts)
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

**2. Scenarios 1-3: Basics (15 min)**
- Quick demos showing familiar attacks work the same
- Emphasize: "See? Same commands you already know"
- Pause for questions after each

**3. Scenarios 4-5: Container-Specific (20 min)**
- **Scenario 4 is the KEY moment** - container escape
- This is where "aha!" happens
- "This attack doesn't exist on traditional endpoints!"

**4. Scenario 6: Cloud-Native (10 min)**
- For cloud-focused SEs
- Connect to AWS/Azure IAM concepts they may know

**5. Scenario 7: Full Chain (10 min)**
- Show complete breach
- Highlight Falcon detections at each stage
- Business impact discussion

**6. Q&A & Certification (5 min)**
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

After completing all 7 scenarios, SEs can:

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
| 3. Credentials | GenericDataCollection | High |
| 4. Escape | **ContainerEscape** | Critical |
| 5. Docker Socket | ContainerEscape, ExecutionLin | Critical |
| 6. K8s API | IntelDomainHigh, GenReverseShell | High |
| 7. Full Chain | 10-15 detections across all tactics | Critical/High |

---

## 🚀 Quick Start for Office Hours

```bash
# On demo machine:
docker run -p 8080:80 vulnapp:latest

# Navigate to: http://localhost:8080
# Click "🎓 Learning Mode"
# Follow scenarios 1-7 in order
# Collect all flags (1,000 points total!)
```

---

## 🏆 SE Certification

**Upon completing all 7 scenarios, SE earns:**
- ✅ VulnApp Container Security Certification
- ✅ 1,000 CTF points
- ✅ All 7 flags collected
- ✅ Ready to demo to customers
- ✅ Confident in container security positioning

---

## 📝 Common Customer Questions (Covered in Scenarios)

**Q: "How is this different from endpoint security?"**
**A:** Covered in Scenario 4 - Container escapes don't exist on traditional endpoints

**Q: "Why can't we just use RBAC and least privilege?"**
**A:** Covered in Scenario 6 - RBAC is critical, but you need detection when it's bypassed

**Q: "Can't DevOps teams just not run privileged containers?"**
**A:** Covered in Scenario 5 - Yes, but you need visibility into what's actually running

**Q: "What's the ROI?"**
**A:** Covered in Scenario 7 - $4.5M average breach cost avoided with real-time detection

---

## 🎯 Next Steps

After office hours, SEs can:
1. Practice 1-2 scenarios again on their own
2. Run customer demo scenario (Scenario 8 - separate file)
3. Use scenarios in POCs and workshops
4. Customize scenarios for specific industries

---

**Built for CrowdStrike SE Education | Office Hours Ready | CTF-Style Learning**
