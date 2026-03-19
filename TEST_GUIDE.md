# VulnApp v2.0 - Complete System Test Guide

## Overview
This guide walks through testing the complete interactive CTF flag submission system, enhanced terminal visualization, and progress tracking.

---

## Prerequisites

**Lab Setup:**
- ✅ Linux host with Docker (victim/VulnApp host)
- ✅ Windows host with browser (user interface)
- ✅ Kali host (optional - for reverse shell scenarios)
- ✅ All hosts on same network/subnet

**Before Testing:**
- Code pushed to GitHub: ✅ (commit 3a95a68)
- Backend API: ✅ Flag submission + Progress tracking
- Frontend: ✅ Interactive UI with CTF system

---

## Phase 1: Build and Deploy (5 minutes)

### On Linux Lab Host

```bash
# 1. Stop old container
docker stop vulnapp 2>/dev/null || true
docker rm vulnapp 2>/dev/null || true

# 2. Remove old directory and download latest code
cd ~
rm -rf vulnapp-main main.zip*
wget https://github.com/jachetti/vulnapp/archive/refs/heads/main.zip
unzip main.zip
cd vulnapp-main

# 3. Verify new files are present
ls -la frontend/src/hooks/useProgress.ts
ls -la frontend/src/components/ProgressHeader.tsx
ls -la frontend/src/components/FlagSubmissionBox.tsx
ls -la backend/progress_tracker.go

# 4. Check Apache is stopped
sudo lsof -i :80 | grep httpd && sudo service httpd stop

# 5. Build Docker image (takes 3-5 minutes)
docker build --no-cache -t vulnapp .

# 6. Run container
docker run -d -p 80:80 --name vulnapp vulnapp

# 7. Verify it's running
docker ps
docker logs vulnapp | head -20

# Expected output should show:
# - "API routes registered"
# - "POST /api/progress/submit-flag"
# - "GET /api/progress?session_id=xxx"
# - "Starting server on :80"

# 8. Test API from command line
curl http://localhost/api/health
curl http://localhost/api/attacks | jq '.count'
# Should show 35 attacks (12 existing + 12 modern + 7 learning + 4 chains)
```

---

## Phase 2: UI Verification (3 minutes)

### On Windows Host Browser

**Open:** `http://<linux-host-ip>`

### ✅ Checklist 1: Main Page Load

- [ ] Page loads successfully
- [ ] CrowdStrike logo and branding visible
- [ ] **Progress header visible at top** (NEW!)
  - Shows "0 / 1000 points"
  - Shows "0 / 6 scenarios"
  - Progress bar at 0%
- [ ] Attack categories visible
- [ ] "Learning Scenarios (6)" tab present

### ✅ Checklist 2: Learning Scenarios Tab

Click on **"Learning Scenarios (6)"** tab:

- [ ] 6 scenario cards appear
- [ ] Each card shows:
  - 🎓 emoji in name
  - Point value in top-right corner (50, 50, 100, 150, 200, 450)
  - 🔒 "locked" icon for unsolved
  - "Execute ▶" button (red)
- [ ] No green checkmarks yet (none solved)

---

## Phase 3: Test Learning Scenario Execution (10 minutes)

### Test Scenario 1: Remote Access Shell (50 points)

**Click:** "🎓 Scenario 1: Remote Access Shell (50 pts)" → **Execute ▶**

### ✅ Checklist 3: Enhanced Execution Panel

**Left Panel (Attack Details):**
- [ ] Scenario name and description
- [ ] Severity badge
- [ ] MITRE ATT&CK techniques
- [ ] Execution info (ID, duration, exit code)

**Right Panel (Enhanced Terminal):**
- [ ] **Current Stage Header visible** (NEW!)
  - Shows "STAGE X/5"
  - Shows current command being executed
  - Timer showing elapsed time (MM:SS)
  - Progress bar animating
- [ ] Terminal output with enhanced formatting:
  - [ ] Stage headers in red boxes
  - [ ] Command execution in blue boxes (▶ EXECUTING)
  - [ ] Teaching notes in yellow highlights
  - [ ] Regular output in green text

**Watch for these visual elements:**
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ STAGE 2: Post-Exploitation     ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

╔═════════════════════════════════╗
║ ▶ EXECUTING: whoami             ║
╚═════════════════════════════════╝

vulnapp

╔═════════════════════════════════╗
║ ✓ COMPLETED: whoami             ║
╚═════════════════════════════════╝
```

**Flag Appearance:**
- [ ] Scroll to bottom of output
- [ ] Look for animated green box with 🚩 emoji
- [ ] Flag should be: `FLAG{reverse_shell_works_same_in_containers}`

**Example:**
```
════════════════════════════════════════
  🚩 FLAG CAPTURED!
════════════════════════════════════════

  FLAG{reverse_shell_works_same_in_containers}

  Copy this flag and submit it to earn 50 points!
════════════════════════════════════════
```

**When scenario completes:**
- [ ] Status changes to "✓ COMPLETED"
- [ ] Exit code shown (should be 0)
- [ ] Duration displayed

### ✅ Checklist 4: Flag Submission (NEW!)

**Scroll down in LEFT panel to bottom:**

- [ ] **Flag submission box appears** after completion
- [ ] Shows: "🚩 Found the flag?"
- [ ] Input field with placeholder "FLAG{...}"
- [ ] "Submit Flag →" button (red)
- [ ] Hint text: "💡 Tip: Look for lines containing 'FLAG{...}'"

**Test 1: Submit Incorrect Flag**
1. Type: `FLAG{wrong_flag}`
2. Click "Submit Flag →"
3. **Expected Result:**
   - [ ] ❌ Red error box appears
   - [ ] Message: "Incorrect flag. Read the output carefully!"
   - [ ] Points unchanged (still 0/1000)

**Test 2: Submit Correct Flag**
1. Clear input
2. Type: `FLAG{reverse_shell_works_same_in_containers}`
3. Click "Submit Flag →"
4. **Expected Result:**
   - [ ] 🎉 Green success box appears
   - [ ] Message: "Correct! Flag captured!"
   - [ ] Shows: "+50 POINTS" badge
   - [ ] Progress header updates automatically**:
     - Points: 50 / 1000
     - Scenarios: 1 / 6
     - Progress bar: 5%
   - [ ] Flag input disappears, replaced with "✅ Solved!"

**Test 3: Try Submitting Again**
1. Close execution panel (X button)
2. Re-execute same scenario
3. Scroll to flag submission
4. **Expected Result:**
   - [ ] Shows "✅ Solved! You earned 50 points"
   - [ ] No input field (already solved)

**Test 4: Check Scenario Card**
1. Close execution panel
2. Go back to "Learning Scenarios" tab
3. Find "Scenario 1: Remote Access Shell"
4. **Expected Result:**
   - [ ] Card has **green border**
   - [ ] Shows "✓ 50 pts" badge (green, top-right)
   - [ ] Button changed to "View ✓" (green)

---

## Phase 4: Test Multiple Scenarios (15 minutes)

### Execute Scenario 2: Process Discovery (50 pts)

**Repeat the test process:**
1. Click "🎓 Scenario 2: Process Discovery (50 pts)"
2. Execute and watch enhanced terminal
3. Find flag: `FLAG{discovered_container_boundaries_and_limits}`
4. Submit flag
5. **Verify:**
   - [ ] +50 points → Total: 100/1000
   - [ ] Scenarios: 2/6
   - [ ] Progress bar: 10%
   - [ ] Card turns green

### Execute Scenario 4: Container Escape (150 pts)

**This is the KEY scenario with CRITICAL detection:**

1. Execute "🎓 Scenario 4: Container Escape"
2. Watch for:
   - [ ] Multiple stages (5+)
   - [ ] chroot command execution
   - [ ] "THIS IS THE KEY DIFFERENCE" messaging
   - [ ] Flag: `FLAG{container_isolation_bypassed_welcome_to_host}`
3. Submit flag
4. **Verify:**
   - [ ] +150 points → Total: 250/1000
   - [ ] Scenarios: 3/6
   - [ ] Progress bar: 25%

### Skip to Scenario 6: Full Attack Chain (450 pts)

**Test the master scenario:**

1. Execute "🎓 Scenario 6: Full Attack Chain"
2. This is longer (~10 minutes)
3. Watch enhanced terminal show multiple stages
4. Find flag: `FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}`
5. Submit flag
6. **Verify:**
   - [ ] +450 points → Total: 700/1000
   - [ ] Scenarios: 4/6
   - [ ] Progress bar: 70%

---

## Phase 5: Progress Persistence (2 minutes)

### Test Session Persistence

**Test 1: Refresh Page**
1. Press F5 to refresh browser
2. **Expected Result:**
   - [ ] Progress header still shows 500/1000 points
   - [ ] Solved scenarios still show green checkmarks
   - [ ] Session persists across refresh

**Test 2: New Browser Tab**
1. Open new tab to same URL
2. **Expected Result:**
   - [ ] Same session (LocalStorage)
   - [ ] Same progress visible

**Test 3: New Browser (Incognito)**
1. Open Incognito/Private window
2. Go to same URL
3. **Expected Result:**
   - [ ] NEW session created
   - [ ] Progress: 0/1000 points
   - [ ] All scenarios unsolved
   - [ ] Proves session isolation works

---

## Phase 6: Complete Certification (15 minutes)

### Solve Remaining Scenarios

**Complete all 6 scenarios to reach 1000 points:**

| Scenario | Points | Flag |
|----------|--------|------|
| 1. Remote Shell | 50 | `FLAG{reverse_shell_works_same_in_containers}` |
| 2. Process Discovery | 50 | `FLAG{discovered_container_boundaries_and_limits}` |
| 3. Data Collection | 100 | `FLAG{credentials_stolen_data_staged_for_exfiltration}` |
| 4. Container Escape | 150 | `FLAG{container_isolation_bypassed_welcome_to_host}` |
| 5. Persistence | 200 | `FLAG{backdoors_established_attacker_can_return_anytime}` |
| 6. Full Chain | 450 | `FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}` |

**After reaching 1000 points:**

### ✅ Checklist 5: Certification Badge

- [ ] Progress header shows "1000 / 1000 points"
- [ ] Progress bar: 100% (full green)
- [ ] **Certification badge appears** (NEW!):
  ```
  ┌────────────────────────────────┐
  │ 🏆 CERTIFIED!                  │
  │ VulnApp Container Security SE  │
  └────────────────────────────────┘
  ```
- [ ] All 6 scenario cards show green borders
- [ ] All buttons show "View ✓"

---

## Phase 7: Falcon Detection Verification (5 minutes)

### Check Falcon Console

**Expected Detections (from previous test run):**

| Detection Name | Count | Source Scenarios |
|----------------|-------|------------------|
| TestTriggerHigh | 21 | All scenarios (validation) |
| IntelDomainHigh | 12 | C2 beacon scenarios |
| GenReverseShell | 6 | Shell-based scenarios |
| BashReverseShell | 4 | Scenario 1 |
| ExecutionLin | 3 | Binary masquerading |
| ContainerEscape | 2 | **Scenario 4** (CRITICAL) |

**Verify:**
- [ ] At least 30+ detections generated
- [ ] ContainerEscape detection present (most important)
- [ ] BashReverseShell from Scenario 1
- [ ] IntelDomainHigh from C2 beacons

---

## Phase 8: Edge Cases and Error Handling (5 minutes)

### Test Error Scenarios

**Test 1: Submit Empty Flag**
1. Execute any scenario
2. Leave flag input blank
3. Click Submit
4. **Expected:** Error message "Please enter a flag"

**Test 2: Submit While Already Submitting**
1. Submit a flag
2. During "Checking..." state, button should be disabled
3. **Expected:** Cannot submit twice

**Test 3: Close Panel During Execution**
1. Execute a scenario
2. Click X to close while still running
3. Re-open same scenario
4. **Expected:** New execution starts fresh

**Test 4: Network Error Simulation**
1. Stop Docker container: `docker stop vulnapp`
2. Try to submit a flag
3. **Expected:** Error message "Failed to submit flag"
4. Restart: `docker start vulnapp`

---

## Phase 9: Visual Elements Verification (3 minutes)

### Enhanced Terminal Features

**Test Auto-Scroll:**
1. Execute long scenario (Scenario 6)
2. As output streams:
   - [ ] Terminal auto-scrolls to bottom
3. Scroll up manually
4. **Expected:**
   - [ ] "Scroll to Bottom ↓" button appears (red, bottom-right)
5. Click button
6. **Expected:** Scrolls back to bottom

**Test Stage Progress:**
1. During execution, watch sticky header
2. **Verify:**
   - [ ] Stage number updates (1/5 → 2/5 → 3/5...)
   - [ ] Command display updates as new commands execute
   - [ ] Timer increments every second
   - [ ] Progress bar fills left-to-right

**Test Command Visualization:**
1. Watch terminal output
2. **Verify command boxes appear:**
   ```
   ╔═══════════════════════════╗
   ║ ▶ EXECUTING              ║
   ╚═══════════════════════════╝
   $ netstat -an
   ```
3. **Verify stage headers:**
   ```
   ┌─────────────────────────────┐
   │ STAGE 2                     │
   │ Network Discovery           │
   └─────────────────────────────┘
   ```

---

## Success Criteria

### ✅ All Systems Functional

- [x] Backend API responding
- [x] Progress tracking working
- [x] Flag submission validating
- [x] Session persistence working
- [x] Enhanced terminal visualization
- [x] Stage progress tracking
- [x] Scenario solved states
- [x] Certification badge at 1000 points
- [x] Falcon detections generating

### ✅ User Experience

- [x] Intuitive flag submission flow
- [x] Clear visual feedback
- [x] Progress always visible
- [x] No console errors
- [x] Smooth animations
- [x] Responsive design

---

## Troubleshooting

### Problem: Progress not updating after flag submission

**Check:**
```bash
# On Linux host, check backend logs
docker logs vulnapp | grep "progress"
```

**Solution:** Verify API routes are registered. Should see:
```
POST /api/progress/submit-flag
GET  /api/progress?session_id=xxx
```

### Problem: Flag submission returns 404

**Check:**
```bash
# Test API directly
curl -X POST http://localhost/api/progress/submit-flag \
  -H "Content-Type: application/json" \
  -d '{"session_id":"test","scenario_id":"learn-01-remote-shell","flag":"FLAG{test}"}'
```

**Expected:** JSON response, not 404

### Problem: Solved scenarios don't show green

**Check:** Browser console (F12) for JavaScript errors

**Solution:** Hard refresh (Ctrl+Shift+R) to clear cache

### Problem: Enhanced terminal not showing stage headers

**Check:** Look at raw terminal output - headers should be present in text

**Solution:** Verify `terminalParser.ts` is loaded and parsing correctly

---

## Performance Benchmarks

**Expected Timings:**

| Task | Expected Duration |
|------|-------------------|
| Docker build | 3-5 minutes |
| Container startup | 5-10 seconds |
| Page load | < 2 seconds |
| Scenario execution | 5-10 minutes |
| Flag submission | < 500ms |
| Progress update | < 100ms |
| Complete certification | 45-60 minutes |

---

## Test Sign-Off

**Tester:** _______________
**Date:** _______________
**Environment:** _______________

**Results:**
- [ ] All Phase 1-9 tests passed
- [ ] No critical issues found
- [ ] Ready for office hours deployment

**Notes:**
_________________________________________________
_________________________________________________
_________________________________________________

---

**VulnApp v2.0 - Interactive CTF Learning System**
**Test Guide Version:** 1.0
**Last Updated:** 2026-03-18
