# VulnApp CTF Restructuring: 17 Scenarios

## Goal
Transform entire app into CTF-style learning tool with flags for every scenario.
- **7 Learning Scenarios** (SE training path)
- **10 Detection Scenarios** (proven Falcon detections)
- **Total: 17 scenarios = 1,000 points**

---

## Part 1: Learning Scenarios (7 scenarios, 500 points)

**Progressive SE training path with CTF flags**

### Level 1: Fundamentals (100 points)
1. **Scenario 1: Remote Access Shell** (50 pts)
   - Flag: `FLAG{reverse_shell_works_same_in_containers}`
   - Detections: BashReverseShell, TestTriggerHigh
   - Duration: 5 min
   - Status: ✅ Complete with flag

2. **Scenario 2: Process Discovery** (50 pts)
   - Flag: `FLAG{discovered_container_boundaries_and_limits}`
   - Detections: GenReverseShell, TestTriggerHigh
   - Duration: 5 min
   - Status: ✅ Complete with flag

### Level 2: Container Attacks (250 points)
3. **Scenario 3: Data Collection & Exfiltration** (100 pts)
   - Flag: `FLAG{credentials_stolen_data_staged_for_exfiltration}`
   - Detections: GenericDataCollection, IntelDomainHigh, TestTriggerHigh
   - Duration: 7 min
   - Status: ✅ Complete with flag

4. **Scenario 4: Container Escape** (150 pts) ⭐ **KEY DIFFERENTIATOR**
   - Flag: `FLAG{container_isolation_bypassed_welcome_to_host}`
   - Detections: **ContainerEscape** (CRITICAL), TestTriggerHigh
   - Duration: 7 min
   - Status: ✅ Complete with flag

### Level 3: Advanced Threats (150 points)
5. **Scenario 5: Persistence Establishment** (200 pts)
   - Flag: `FLAG{backdoors_established_attacker_can_return_anytime}`
   - Detections: ExecutionLin, IntelDomainHigh, TestTriggerHigh
   - Duration: 8 min
   - Status: ✅ Complete with flag

6. **Scenario 6: Full Attack Chain** (450 pts) - **MASTER LEVEL**
   - Flag: `FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}`
   - Detections: 15+ (all types)
   - Duration: 10 min
   - Status: ✅ Complete with flag

7. **Scenario 7: Defense Evasion & Masquerading** (100 pts) - **NEW**
   - Flag: `FLAG{svchost_exe_on_linux_fooled_nobody}`
   - Detections: ExecutionLin, In-Memory Threat
   - Duration: 6 min
   - Source: Adapt from existing "Defense_Evasion_via_Masquerading.sh"
   - Status: ❌ Need to create learning version

**Learning Scenarios Total: 7 scenarios, 500 points, ~45 minutes**

---

## Part 2: Detection Scenarios (10 scenarios, 500 points)

**Advanced scenarios showcasing Falcon detection capabilities**

### Category: Privilege Escalation (200 points)

8. **Privileged Container Escape** (100 pts)
   - Flag: `FLAG{privileged_mode_equals_root_on_host}`
   - Detections: ContainerEscape ✓✓✓
   - Source: bin/modern/Privileged_Container_Escape.sh
   - Status: ❌ Add flag

9. **Docker Socket Exploitation** (100 pts)
   - Flag: `FLAG{docker_socket_is_the_keys_to_the_kingdom}`
   - Detections: ContainerEscape, ExecutionLin
   - Source: bin/modern/Docker_Socket_Exploitation.sh
   - Status: ❌ Add flag

### Category: Defense Evasion (100 points)

10. **Binary Masquerading** (50 pts)
    - Flag: `FLAG{fake_extensions_cant_hide_from_falcon}`
    - Detections: ExecutionLin
    - Source: bin/existing/Defense_Evasion_via_Masquerading.sh
    - Status: ❌ Add flag

11. **Rootkit Installation** (50 pts)
    - Flag: `FLAG{rootkit_detected_before_kernel_compromise}`
    - Detections: Rootkit behavior detection
    - Source: bin/existing/Defense_Evasion_via_Rootkit.sh
    - Status: ❌ Add flag

### Category: Command & Control (100 points)

12. **C2 Remote Access** (50 pts)
    - Flag: `FLAG{c2_beacon_caught_by_threat_intelligence}`
    - Detections: GenReverseShell, IntelDomainHigh
    - Source: bin/existing/Command_Control_via_Remote_Access.sh
    - Status: ❌ Add flag

13. **Reverse Shell Trojan** (50 pts)
    - Flag: `FLAG{netcat_listener_detected_instantly}`
    - Detections: BashReverseShell
    - Source: bin/existing/Reverse_Shell_Trojan.sh
    - Status: ❌ Add flag

### Category: Impact & Detection (100 points)

14. **Container Drift Detection** (50 pts)
    - Flag: `FLAG{runtime_changes_trigger_drift_alert}`
    - Detections: ContainerDrift
    - Source: bin/existing/ContainerDrift_Via_File_Creation_and_Execution.sh
    - Status: ❌ Add flag

15. **Credential Dumping** (50 pts)
    - Flag: `FLAG{memory_credentials_extracted_and_detected}`
    - Detections: Credential Access
    - Source: bin/existing/Credential_Access_via_Credential_Dumping.sh
    - Status: ❌ Add flag

### Category: Multi-Stage Attacks (100 points)

16. **Full Breach Simulation** (50 pts)
    - Flag: `FLAG{complete_breach_chain_stopped_by_falcon}`
    - Detections: 10-15 across all tactics
    - Source: bin/chains/Full_Breach_Simulation.sh
    - Status: ❌ Add flag

17. **Enumeration & Exfiltration Chain** (50 pts)
    - Flag: `FLAG{data_exfiltration_blocked_before_loss}`
    - Detections: GenericDataCollection, IntelDomainHigh
    - Source: bin/chains/Enumeration_And_Exfiltration.sh
    - Status: ❌ Add flag

**Detection Scenarios Total: 10 scenarios, 500 points, ~60 minutes**

---

## Total Score Breakdown

**Grand Total: 17 scenarios = 1,000 points**

### By Category:
- Learning Scenarios: 500 points (7 scenarios)
- Privilege Escalation: 200 points (2 scenarios)
- Defense Evasion: 100 points (2 scenarios)
- Command & Control: 100 points (2 scenarios)
- Impact & Detection: 100 points (2 scenarios)
- Multi-Stage Attacks: 100 points (2 scenarios)

### By Level:
- Easy (50 pts): 8 scenarios = 400 points
- Medium (100 pts): 5 scenarios = 500 points
- Hard (150-200 pts): 2 scenarios = 350 points
- Master (450 pts): 1 scenario = 450 points (moved this down actually)

Wait, let me recalculate:

Learning: 50+50+100+150+200+450 = 1000 (but should be 500)
Detection: 100+100+50+50+50+50+50+50+50+50 = 600 (but should be 500)

Let me adjust:

### Adjusted Point Distribution

**Learning Scenarios (500 points):**
1. Remote Shell: 50
2. Process Discovery: 50
3. Data Collection: 75
4. Container Escape: 100 (THE KEY)
5. Persistence: 75
6. Defense Evasion: 50
7. Full Attack Chain: 100

**Detection Scenarios (500 points):**
8. Privileged Container Escape: 75
9. Docker Socket Exploitation: 75
10. Binary Masquerading: 50
11. Rootkit Installation: 50
12. C2 Remote Access: 50
13. Reverse Shell Trojan: 50
14. Container Drift: 50
15. Credential Dumping: 50
16. Full Breach Simulation: 50
17. Enumeration & Exfiltration: 50

Total: 1,000 points

---

## Scenarios to REMOVE (18 scenarios)

These will be deleted from attack_metadata.go:

**From existing/ (9 removed, keeping 3):**
- ❌ Exfiltration_via_Exfiltration_Over_Alternative_Protocol.sh
- ❌ Command_Control_via_Remote_Access-obfuscated.sh
- ❌ Collection_via_Automated_Collection.sh
- ❌ Execution_via_Command-Line_Interface.sh
- ❌ Malware_Linux_Trojan_Local.sh
- ❌ Malware_Linux_Trojan_Remote.sh

**From modern/ (10 removed, keeping 2):**
- ❌ CAP_DAC_READ_SEARCH_Bypass.sh
- ❌ CAP_SYS_ADMIN_Abuse.sh
- ❌ CAP_SYS_PTRACE_Injection.sh
- ❌ CVE_2019_5736_runc_Escape.sh
- ❌ DaemonSet_Persistence.sh
- ❌ HostPath_Volume_Backdoor.sh
- ❌ Image_Supply_Chain_Poison.sh
- ❌ Namespace_Escape_nsenter.sh
- ❌ Seccomp_Profile_Bypass.sh
- ❌ Service_Account_Token_Theft.sh

**From chains/ (2 removed, keeping 2):**
- ❌ Container_Breakout.sh
- ❌ Persistence_Establishment.sh (already covered in learning)

---

## Implementation Steps

### Phase 1: Create New Scenario
1. Create learning scenario 7 (Defense Evasion) from masquerading attack
2. Add flag section to script
3. Test execution and flag capture

### Phase 2: Add Flags to Detection Scenarios
1. Add flag sections to 10 detection scenario scripts
2. Ensure consistent format
3. Test each flag appears at end of output

### Phase 3: Update Backend Metadata
1. Edit attack_metadata.go
2. Remove 18 old scenarios
3. Keep only 17 scenarios (7 learning + 10 detection)
4. Update point values
5. Update categories ("Learning Scenarios" and "Detection Scenarios")

### Phase 4: Update Frontend
1. Fix progress bar (should show 17 total scenarios)
2. Update categories display
3. Test CTF flag submission for all 17

### Phase 5: Update Documentation
1. Update README.md
2. Update TEST_GUIDE.md
3. Update bin/learning/README.md
4. Remove old scenario references

---

## Success Criteria

✅ Exactly 17 scenarios (7 learning + 10 detection)
✅ All 17 scenarios have CTF flags
✅ Total points = 1,000
✅ All scenarios generate proven Falcon detections
✅ Progress bar shows correct count (17)
✅ Categories organized: "Learning Scenarios" and "Detection Scenarios"
✅ No old/unused scenarios in metadata
✅ Complete CTF experience from start to finish

---

**Ready to implement? This will be a major cleanup and improvement!**
