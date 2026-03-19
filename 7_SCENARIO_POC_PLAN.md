# 7-Scenario POC Plan - Teaching-Focused

## Goal
Create a working POC with 7 high-quality teaching scenarios. Get flags working, then expand later.

## The 7 Scenarios (1,000 points)

### 1. Remote Access Shell (100 points)
- **File**: `/bin/learning/01_Remote_Access_Shell.sh`
- **Flag**: `FLAG{reverse_shell_works_same_in_containers}`
- **Teaching**: Containers are processes - shells work the same way
- **Duration**: 5 min
- **Status**: ✅ EXISTS with flag

### 2. Process Discovery (150 points)
- **File**: `/bin/learning/02_Process_Discovery.sh`
- **Flag**: `FLAG{discovered_container_boundaries_and_limits}`
- **Teaching**: Reconnaissance looks same, but container boundaries matter
- **Duration**: 5 min
- **Status**: ✅ EXISTS with flag

### 3. Container Escape (200 points) ⭐ KEY DIFFERENTIATOR
- **File**: `/bin/learning/04_Container_Escape.sh`
- **Flag**: `FLAG{container_isolation_bypassed_welcome_to_host}`
- **Teaching**: Containers are NOT VMs - escape techniques
- **Duration**: 7 min
- **Status**: ✅ EXISTS with flag

### 4. Data Theft & Exfiltration (150 points)
- **File**: `/bin/learning/03_Data_Collection_Exfiltration.sh`
- **Flag**: `FLAG{credentials_stolen_data_staged_for_exfiltration}`
- **Teaching**: Impact of data theft in containerized environments
- **Duration**: 7 min
- **Status**: ✅ EXISTS with flag

### 5. Persistence (150 points)
- **File**: `/bin/learning/05_Persistence_Establishment.sh`
- **Flag**: `FLAG{backdoors_established_attacker_can_return_anytime}`
- **Teaching**: Maintaining long-term access
- **Duration**: 8 min
- **Status**: ✅ EXISTS with flag

### 6. Defense Evasion (100 points)
- **File**: `/bin/learning/07_Defense_Evasion_Masquerading.sh`
- **Flag**: `FLAG{svchost_exe_on_linux_fooled_nobody}`
- **Teaching**: Behavior-based detection vs signature-based
- **Duration**: 6 min
- **Status**: ✅ EXISTS with flag

### 7. Full Attack Chain (150 points) - MASTER LEVEL
- **File**: `/bin/learning/06_Full_Attack_Chain.sh`
- **Flag**: `FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}`
- **Teaching**: How attacks progress through multiple stages
- **Duration**: 10 min
- **Status**: ✅ EXISTS with flag

**Total: 7 scenarios = 1,000 points**

## Critical Fixes Needed

### Fix 1: Terminal Output Showing Full Flag
**Problem**: Flags exist in scripts but terminal cuts off before showing them

**Solution**: Force scroll to bottom when execution completes + increase terminal height

**File**: `frontend/src/components/ExecutionPanel.tsx`
```typescript
// When status changes to 'completed', force scroll to bottom
useEffect(() => {
  if (status === 'completed' && outputRef.current) {
    setTimeout(() => {
      outputRef.current!.scrollTop = outputRef.current!.scrollHeight;
    }, 100);
  }
}, [status]);
```

### Fix 2: Consistent Flag Styling
**Problem**: Different scenarios have different flag output styles

**Solution**: Ensure all 7 scripts use EXACT same flag format:
```bash
echo ""
echo "🚩 FLAG CAPTURED!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  FLAG{flag_text_here}"
echo ""
echo "  Copy this flag and submit it to earn XXX points!"
echo "════════════════════════════════════════════════════════════════"
```

### Fix 3: Update Backend Metadata
Remove all non-learning scenarios, keep only 7.

**File**: `backend/attack_metadata.go`

### Fix 4: Update Frontend
- Progress bar: 7 scenarios (not 17)
- Welcome banner: "7 Teaching Scenarios"

## Implementation Steps

1. ✅ **Fix terminal auto-scroll** (ExecutionPanel.tsx)
2. ✅ **Verify all 7 scripts have consistent flag format**
3. ✅ **Update attack_metadata.go** (remove 10 scenarios, keep 7)
4. ✅ **Update ProgressHeader.tsx** (maxScenarios = 7)
5. ✅ **Update WelcomeSection.tsx** (7 scenarios messaging)
6. ✅ **Test flag visibility** for all 7
7. ✅ **Test progress tracking**
8. ✅ **Verify 1,000 points total**

## Success Criteria

✅ Exactly 7 scenarios visible on homepage
✅ All 7 flags visible at end of terminal output
✅ Progress bar shows "X / 7"
✅ Total points = 1,000
✅ Flag submission works for all 7
✅ Consistent styling across all 7

## After POC Works

Once this 7-scenario POC is solid:
1. Add 4 more teaching scenarios (get to 11)
2. Then consider detection scenarios
3. But first: GET 7 WORKING!
