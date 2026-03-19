# Recommended Scenario Structure for 1-Hour Training

## Analysis: Current vs Optimal

### Current State (7 Learning Scenarios)
- **Total Time:** ~45-60 minutes execution
- **Total Points:** 1,000 (50+50+50+100+150+200+300)
- **Detection Quality:** Mixed (some don't generate unique detections)

### Detection Quality Assessment

| Scenario | Duration | Unique Detections | Setup Complexity | Keep? |
|----------|----------|-------------------|------------------|-------|
| 1. Remote Shell | 5 min | ✅ BashReverseShell, GenReverseShell | ✅ Simple | **YES** |
| 2. Process Discovery | 5 min | ❌ None unique | ✅ Simple | MAYBE |
| 3. Credential Theft | 5 min | ❌ None seen | ✅ Simple | NO |
| 4. Container Escape | 7 min | ✅ **ContainerEscape (CRITICAL)** | ✅ Simple | **YES** |
| 5. Docker Socket | 6 min | ✅ ContainerEscape | ❌ Needs socket mount | NO |
| 6. Kubernetes API | 8 min | ✅ Tokens | ❌ Needs K8s | NO |
| 7. Full Chain | 10 min | ✅ 15+ detections | ✅ Simple | **YES** |

### Additional Available Scenarios (from Attack Chains)

| Attack Chain | Duration | Detections | Educational Value |
|--------------|----------|------------|-------------------|
| Full Breach Simulation | 8 min | 10-15 | ✅ High - Complete lifecycle |
| Enumeration & Exfiltration | 7 min | 8-12 | ✅ High - Tool downloads |
| Container Breakout | 6 min | 5-8 | ✅ Medium - Overlaps with #4 |
| Persistence Establishment | 8 min | 6-10 | ✅ High - Backdoor techniques |

---

## Recommendation: 5 Core Scenarios (Optimal)

### Rationale
- **Total execution time:** ~35-40 minutes
- **Buffer for presentation:** 15-20 minutes
- **Total session:** ~60 minutes ✅
- **All generate proven detections**
- **No special setup required**
- **Progressive difficulty**

### Proposed Structure

#### **Level 1: Fundamentals (150 points)**

**Scenario 1: Remote Access Shell (50 pts)**
- **Duration:** 5 minutes
- **Detections:** BashReverseShell, GenReverseShell, TestTriggerHigh
- **Teaches:** Containers are processes, shells work the same
- **Flag:** `FLAG{reverse_shell_works_same_in_containers}`
- **Why keep:** Foundation concept, reliable detections

**Scenario 2: Process Discovery & Enumeration (50 pts)**
- **Duration:** 5 minutes
- **Detections:** GenReverseShell, TestTriggerHigh
- **Teaches:** Namespace isolation, container boundaries, Docker socket detection
- **Flag:** `FLAG{discovered_container_boundaries_and_limits}`
- **Why keep:** Shows reconnaissance phase, teaches isolation concept

**Scenario 3: Data Collection & Exfiltration (50 pts)**
- **Duration:** 7 minutes
- **Detections:** GenericDataCollection, CurlWgetMalwareDownload, ExecutionLin
- **Teaches:** Credential hunting, data staging, tool downloads
- **Flag:** `FLAG{credentials_stolen_data_staged_for_exfiltration}`
- **Why add:** Shows business impact, demonstrates data theft
- **Source:** Adapted from "Enumeration & Exfiltration Chain"

#### **Level 2: Container-Specific Attacks (250 points)**

**Scenario 4: Container Escape (100 pts)** ⭐ **KEY MOMENT**
- **Duration:** 7 minutes
- **Detections:** **ContainerEscape (CRITICAL)**, TestTriggerHigh
- **Teaches:** THE difference - breaking isolation
- **Flag:** `FLAG{container_isolation_bypassed_welcome_to_host}`
- **Why keep:** Critical detection, doesn't exist on endpoints, "aha!" moment

**Scenario 5: Persistence Establishment (150 pts)**
- **Duration:** 8 minutes
- **Detections:** ExecutionLin, IntelDomainHigh, TestTriggerHigh
- **Teaches:** Backdoor techniques, binary masquerading, persistence methods
- **Flag:** `FLAG{backdoors_established_attacker_can_return_anytime}`
- **Why add:** Shows post-exploitation, demonstrates long-term threat
- **Source:** Adapted from "Persistence Establishment Chain"

#### **Level 3: Master Challenge (600 points)**

**Scenario 6: Complete Attack Chain (600 pts)**
- **Duration:** 10 minutes
- **Detections:** 15+ (all types)
- **Teaches:** Full breach timeline, business impact, ROI
- **Flag:** `FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}`
- **Why keep:** Ties everything together, shows complete story

**Total:** 6 scenarios, 1,000 points, ~42 minutes execution time

---

## Alternative: 6 Scenarios (Balanced)

If you want slightly more content but still under 1 hour:

### Option B: Add "Binary Masquerading" (6 scenarios, 45 min)

**Scenario 3: Binary Masquerading & Defense Evasion (100 pts)**
- **Duration:** 6 minutes
- **Detections:** ExecutionLin, In-Memory Threat
- **Teaches:** Evasion techniques, file extension tricks
- **Flag:** `FLAG{svchost_exe_is_actually_whoami_on_linux}`
- **Source:** From existing "Defense Evasion via Masquerading"

Then adjust points:
- Scenarios 1-2: 50 points each (100 total)
- Scenario 3: 100 points
- Scenario 4: 150 points (Container Escape)
- Scenario 5: 200 points (Persistence)
- Scenario 6: 400 points (Full Chain)
- **Total:** 1,000 points, 6 scenarios

---

## Alternative: 8 Scenarios (Comprehensive)

If you want maximum coverage for advanced students:

### Option C: Full Coverage (8 scenarios, 55 min)

Add these two to the 6-scenario structure:

**Scenario 7: Command & Control Communication (150 pts)**
- **Duration:** 5 minutes
- **Detections:** IntelDomainHigh, GenReverseShell
- **Teaches:** C2 beacons, callback mechanisms
- **Flag:** `FLAG{c2_beacon_established_commands_awaiting}`
- **Source:** From existing "Command_Control_via_Remote_Access"

**Scenario 8: Container Drift Detection (100 pts)**
- **Duration:** 5 minutes
- **Detections:** ContainerDrift, TestTriggerHigh
- **Teaches:** Runtime file creation, image vs running container
- **Flag:** `FLAG{container_modified_after_deployment_drift_detected}`
- **Source:** From existing "ContainerDrift_Via_File_Creation"

Adjust points to total 1,200 for 8 scenarios (or keep at 1,000 with smaller increments).

---

## Final Recommendation: **6 Scenarios**

### Why 6 is Optimal:

✅ **Timing:** 45 minutes execution + 15 minutes presentation = perfect 1-hour session
✅ **Detection Quality:** Every scenario generates proven detections
✅ **No Special Setup:** All work in basic Docker environment
✅ **Progressive Learning:** Clear difficulty curve (50→50→100→150→200→400)
✅ **Complete Story:** Covers full attack lifecycle
✅ **Memorable:** Not too many to confuse, not too few to be superficial
✅ **Repeatable:** Students can complete solo in ~45 minutes after your presentation

### Structure:

```
Level 1: Basics (100 pts, 10 min)
  ├─ Scenario 1: Remote Shell (50 pts)
  └─ Scenario 2: Discovery (50 pts)

Level 2: Container Attacks (250 pts, 15 min)
  ├─ Scenario 3: Data Theft (100 pts)
  └─ Scenario 4: Container Escape (150 pts) ⭐

Level 3: Advanced (650 pts, 18 min)
  ├─ Scenario 5: Persistence (200 pts)
  └─ Scenario 6: Full Chain (450 pts)

Total: 1,000 points, 6 scenarios, ~43 minutes
```

---

## Next Steps

**Choose your approach:**

1. **Option A (5 scenarios, 40 min)** - Minimal, highly focused
2. **Option B (6 scenarios, 45 min)** - ⭐ **RECOMMENDED** - Balanced and complete
3. **Option C (8 scenarios, 55 min)** - Comprehensive, for advanced training

**I recommend Option B (6 scenarios)** for these reasons:
- Perfect timing for 1-hour total session
- Covers all critical concepts
- Every scenario generates detections
- Students finish feeling accomplished, not exhausted
- Leaves buffer time for questions and troubleshooting

**Would you like me to:**
1. Implement the 6-scenario structure?
2. Go with a different option?
3. Customize the scenario mix?
