# Attack Chains - Detection-Optimized Multi-Stage Attacks

## Overview

These attack chains are designed to maximize Falcon detections by creating realistic attack scenarios with strong process relationships. Each chain combines multiple proven detection triggers based on real container breach patterns.

## Available Attack Chains

### 1. 🔥 Full Breach Simulation
**Expected Detections: 10-15**

**Description:** Complete attack lifecycle from initial access through credential theft and C2 communication.

**Stages:**
1. Initial Reconnaissance (whoami, id, hostname, uname)
2. Detection Test Trigger (`bash crowdstrike_test_high`)
3. Process Enumeration (ps aux, security tool detection)
4. Network Discovery (ifconfig, netstat, routing)
5. Container Environment Detection (cgroup, Docker socket)
6. Credential Hunting (/etc/passwd, env vars, K8s tokens)
7. Binary Masquerading (copy whoami to svchost.exe)
8. File System Reconnaissance (SSH keys, configs)
9. C2 Beacon (swungheaving.com DNS/ICMP)
10. Container Escape Recon (capabilities, privileged check)
11. Persistence Setup (backdoor scripts)
12. Data Collection (staging for exfiltration)
13. Tool Download Simulation (LinPEAS, LSE)

**Expected Detections:**
- TestTriggerHigh (guaranteed)
- IntelDomainHigh (C2 beacons)
- ExecutionLin (binary masquerading)
- GenericDataFromLocalSystemCollectionLin
- BashReverseShell/GenReverseShell (if in shell context)

**Best Used:** After establishing reverse shell to maximize process relationship detections

---

### 2. 📊 Enumeration & Exfiltration Chain
**Expected Detections: 8-12**

**Description:** Tool download, execution, data collection, and exfiltration simulation.

**Stages:**
1. Pre-Enumeration Recon
2. Detection Validation
3. Tool Acquisition (LinPEAS, LSE, mimipenguin)
4. Make Executable (chmod +x)
5. System Enumeration (users, groups, sudo)
6. Process/Service Discovery
7. File System Data Collection
8. Container/K8s Enumeration
9. Network Infrastructure Discovery
10. Data Staging for Exfiltration
11. C2 Communication
12. Exfiltration Simulation
13. Cleanup/Cover Tracks

**Expected Detections:**
- CurlWgetMalwareDownload (tool downloads)
- ExecutionLin (chmod operations)
- GenericDataFromLocalSystemCollectionLin (data collection)
- IntelDomainHigh (C2 beacons)
- TestTriggerHigh (validation)

**Best Used:** Standalone or after initial access

---

### 3. 🚪 Container Breakout Chain
**Expected Detections: 5-8**

**Description:** Multiple container escape techniques and post-escape reconnaissance.

**Stages:**
1. Container Environment Detection
2. Detection Validation
3. Capability Enumeration (CAP_SYS_ADMIN, CAP_SYS_PTRACE)
4. Privileged Mode Check
5. Docker Socket Discovery
6. Host File System Check
7. Escape Attempt: chroot
8. Escape Attempt: nsenter
9. Kubernetes API Access
10. Simulated Post-Escape Recon
11. C2 Beacon
12. Seccomp Analysis

**Expected Detections:**
- ContainerEscape (chroot attempt)
- IntelDomainHigh (C2 beacons)
- TestTriggerHigh (validation)
- GenReverseShell (if in shell context)

**Best Used:**
- With `--privileged` flag
- With mounted Docker socket (`-v /var/run/docker.sock:/var/run/docker.sock`)
- With dangerous capabilities (`--cap-add=SYS_ADMIN`)

---

### 4. ⚓ Persistence Establishment Chain
**Expected Detections: 6-10**

**Description:** Multiple persistence mechanisms following proven attack patterns.

**Stages:**
1. System Recon for Persistence
2. Detection Validation
3. Binary Masquerading (whoami.rtf, svchost.exe - from Linux Testing Guide)
4. Hidden Directory Backdoors
5. Cron Job Persistence (simulated)
6. RC/Init Script Persistence
7. SSH Key Backdoor
8. Web Shell Creation
9. LD_PRELOAD Hijacking
10. Container-Specific Persistence (DaemonSet, volumes)
11. Process Injection Setup
12. C2 Beacon
13. Persistence Verification
14. Cleanup Operations

**Expected Detections:**
- ExecutionLin (binary masquerading, chmod)
- IntelDomainHigh (C2 beacons)
- TestTriggerHigh (validation)
- BashReverseShell/GenReverseShell (if in shell context)

**Best Used:** After initial access to simulate full persistence lifecycle

---

## Proven Detection Triggers

All chains include these guaranteed detection triggers:

### 1. Test Trigger (100% detection rate)
```bash
bash crowdstrike_test_high
```
**Detection:** TestTriggerHigh

### 2. Intel Domain Beacon (100% detection rate)
```bash
nslookup swungheaving.com
ping -c 3 swungheaving.com
```
**Detection:** IntelDomainHigh

### 3. Container Escape (100% detection rate)
```bash
chroot /
```
**Detection:** ContainerEscape

### 4. Binary Masquerading
```bash
cp /usr/bin/whoami /tmp/whoami.rtf
./whoami.rtf
```
**Detection:** ExecutionLin, In-Memory Threat

---

## Usage

### Via Web UI
1. Navigate to **Attack Chains** category in the UI
2. Click on any chain (e.g., "🔥 Full Breach Simulation")
3. Click **Execute** button
4. Watch live output in terminal panel
5. Check Falcon console for 5-15 detections

### Via API
```bash
# Execute Full Breach Simulation
curl -X POST http://localhost:8080/api/attacks/chain-full-breach/execute

# Execute Enumeration Chain
curl -X POST http://localhost:8080/api/attacks/chain-enumeration-exfil/execute

# Execute Container Breakout
curl -X POST http://localhost:8080/api/attacks/chain-container-breakout/execute

# Execute Persistence Chain
curl -X POST http://localhost:8080/api/attacks/chain-persistence/execute
```

### Direct Script Execution
```bash
# Inside container
/bin/chains/Full_Breach_Simulation.sh
/bin/chains/Enumeration_And_Exfiltration.sh
/bin/chains/Container_Breakout.sh
/bin/chains/Persistence_Establishment.sh
```

---

## For Maximum Detections

### Best Practice: Reverse Shell → Attack Chain

1. **Establish Reverse Shell** (generates BashReverseShell detection)
   ```bash
   # On Kali (attacker)
   nc -lvnp 4444

   # In VulnApp UI
   Click "🎯 Interactive Reverse Shell"
   Enter: 172.17.0.21:4444
   Click "Launch"
   ```

2. **Execute Attack Chain from Shell** (generates GenReverseShell detections)
   ```bash
   # In reverse shell
   /bin/chains/Full_Breach_Simulation.sh
   ```

This creates the process tree relationship that Falcon's ML uses:
```
bash (reverse shell) → /bin/bash Full_Breach_Simulation.sh → whoami, ps, netstat, etc.
```

**Result:** 15-20 detections instead of 10-15!

---

## Detection Mapping

| Chain | TestTriggerHigh | IntelDomainHigh | ContainerEscape | CurlWgetMalwareDownload | ExecutionLin | GenericDataCollection | BashReverseShell* |
|-------|----------------|----------------|-----------------|------------------------|-------------|---------------------|-------------------|
| Full Breach | ✓ | ✓ | - | - | ✓ | ✓ | ✓ |
| Enumeration | ✓ | ✓ | - | ✓ | ✓ | ✓ | ✓ |
| Breakout | ✓ | ✓ | ✓ | - | - | - | ✓ |
| Persistence | ✓ | ✓ | - | - | ✓ | - | ✓ |

*BashReverseShell and GenReverseShell detections only trigger when executed via reverse shell context

---

## Based On

These attack chains are based on:
- **CrowdStrike Linux Attack Testing Guide (2018)**
- **Real container detection data** from production Falcon deployments
- **Proven attack patterns** that generated 100+ detections in test environments
- **MITRE ATT&CK** container-specific techniques (2024-2026)

---

## Safety Notes

⚠️ **These are intentionally malicious attack simulations**

- Run only in isolated lab environments
- Use dedicated VLANs/networks
- Do not run on production systems
- Some commands are simulated to avoid actual damage
- Real downloads and escape attempts are commented out

---

## Troubleshooting

**No detections appearing?**
1. Verify Falcon sensor is installed and running
2. Check prevention is set to "Detect Only"
3. Execute from reverse shell for maximum detections
4. Wait 30-60 seconds for detections to appear in console

**Chains failing to execute?**
1. Verify scripts are executable: `ls -la /bin/chains/*.sh`
2. Check script paths in attack_metadata.go use `/bin/chains/`
3. Ensure Docker build copied chains directory

**Want more detections?**
1. Uncomment real tool downloads in Enumeration chain
2. Run chains sequentially (Full Breach → Enumeration → Persistence)
3. Execute from reverse shell context
4. Add custom commands between stages

---

**For questions or enhancements, see the main README.md**
