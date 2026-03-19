# Pre-Deployment Checklist ✅

## Completed Pre-Flight Checks (Automated)

### ✅ File Structure
- [x] All 7 main scenario scripts exist
- [x] All 7 setup scripts exist
- [x] All 7 cleanup scripts exist
- [x] All scripts are executable
- [x] File names match scenario numbers (01-07)

### ✅ Backend Configuration
- [x] All script paths in attack_metadata.go are correct
- [x] All scenario IDs are unique
- [x] All flags are unique (no duplicates)
- [x] Total points = 1,000
- [x] All 7 scenarios correctly ordered (1-7)
- [x] Go code compiles successfully

### ✅ Scenario Mapping
```
Scenario 1 → 01_Remote_Access_Shell.sh ✓
Scenario 2 → 02_Process_Discovery.sh ✓
Scenario 3 → 03_Data_Collection_Exfiltration.sh ✓
Scenario 4 → 04_Container_Escape.sh ✓
Scenario 5 → 05_Persistence_Establishment.sh ✓
Scenario 6 → 06_Defense_Evasion_Masquerading.sh ✓
Scenario 7 → 07_Full_Attack_Chain.sh ✓
```

### ✅ Points Distribution
```
Scenario 1: 100 points
Scenario 2: 150 points
Scenario 3: 150 points
Scenario 4: 200 points ⭐ (highest)
Scenario 5: 150 points
Scenario 6: 100 points
Scenario 7: 150 points
──────────────────────
Total:    1,000 points ✓
```

### ✅ Documentation
- [x] README.md updated with 7 scenarios
- [x] Real exploitation mode documented
- [x] WelcomeSection.tsx shows "Real Exploitation Edition"
- [x] All tables show correct order (1-7)
- [x] REAL_EXPLOITATION_GUIDE.md created
- [x] IMPLEMENTATION_SUMMARY.md created

### ✅ Docker & Kubernetes
- [x] Dockerfile exists and is multi-stage
- [x] Port 80 configured everywhere
- [x] vulnerable.example.yaml has dangerous configs with warnings
- [x] Image reference: quay.io/crowdstrike/vulnapp:2.0.0

---

## Manual Deployment Steps

### Step 1: Pull Latest Code
```bash
cd /path/to/vulnapp
git pull origin main
```

**Expected output:**
```
Already up to date.
```
OR
```
Updating xxx..yyy
Fast-forward
 [files changed]
```

### Step 2: Build Docker Image
```bash
sudo docker build --no-cache -t vulnapp:2.0.0 .
```

**Build stages to watch for:**
1. ✓ Frontend builder (npm install, npm run build)
2. ✓ Backend builder (go build)
3. ✓ Final image assembly
4. ✓ No errors in any stage

**Common issues:**
- If npm fails: Check Node.js version (need 18+)
- If go fails: Check backend/attack_metadata.go syntax
- If COPY fails: Check file paths exist

### Step 3: Test Locally (Optional but Recommended)
```bash
# Run container locally first
sudo docker run -d --name vulnapp-test \
  --privileged \
  --cap-add=SYS_ADMIN \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /:/host \
  -p 80:80 \
  vulnapp:2.0.0

# Check logs
sudo docker logs vulnapp-test

# Test in browser
open http://localhost

# Clean up
sudo docker stop vulnapp-test
sudo docker rm vulnapp-test
```

**What to verify locally:**
- ✓ Web interface loads
- ✓ All 7 scenarios appear
- ✓ Click one scenario to verify WebSocket works
- ✓ Terminal output streams in real-time

### Step 4: Deploy to Kubernetes (ISOLATED LAB ONLY)
```bash
# CRITICAL: Verify you're in ISOLATED LAB
kubectl config current-context
# Should show LAB cluster, NOT production!

# Deploy
kubectl apply -f vulnerable.example.yaml

# Monitor deployment
kubectl get pods -w
# Wait for "Running" status

# Check logs
kubectl logs -l run=vulnerable.example.com

# Get external IP
kubectl get svc vulnerable-example-com
```

**Expected pod status:**
```
NAME                                    READY   STATUS    RESTARTS   AGE
vulnerable.example.com-xxxxxxxxx-xxxxx  1/1     Running   0          30s
```

### Step 5: Access Web Interface
```bash
# Get LoadBalancer IP
kubectl get svc vulnerable-example-com -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# OR if using NodePort/port-forward
kubectl port-forward svc/vulnerable-example-com 8080:80
```

**Open in browser:**
```
http://<LOADBALANCER_IP>
OR
http://localhost:8080
```

### Step 6: Verify Real Exploitation Works

**Test Scenario 1:**
1. Click "Remote Access Shell"
2. Watch terminal output
3. Look for these lines:
   ```
   [SETUP] Flag planted in process environment
   [+] Searching for interesting processes...
   [+] Found suspicious process: PID xxxx
   FLAG_CREDENTIAL=FLAG{reverse_shell_works_same_in_containers}
   [CLEANUP] Scenario cleanup complete
   ```
4. ✓ Flag should be visible

**If flag NOT visible:**
- Check setup script ran: `kubectl logs <pod> | grep SETUP`
- Check process was created: `kubectl exec <pod> -- ps aux | grep FLAG`
- Check cleanup didn't run too early

### Step 7: Test All 7 Scenarios

Recommended order:
1. Scenario 1 (Remote Access) - Verify setup/cleanup works
2. Scenario 4 (Container Escape) - Verify host mount works
3. Scenario 7 (Full Chain) - Verify multi-stage works
4. Remaining scenarios (2, 3, 5, 6)

**For each scenario, verify:**
- ✓ Terminal shows [SETUP] output
- ✓ Exploitation commands execute
- ✓ FLAG{...} appears in output
- ✓ [CLEANUP] runs after completion
- ✓ Can submit flag in UI

---

## Troubleshooting Guide

### Issue: Container Won't Start
```bash
# Check pod events
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>

# Common causes:
# - Image pull failed (check image name)
# - Port conflict (check port 80 available)
# - Resource limits (check cluster resources)
```

### Issue: Flag Not Showing in Terminal
```bash
# Check if setup ran
kubectl logs <pod-name> | grep SETUP

# Manually run setup
kubectl exec -it <pod-name> -- /bin/learning/01_setup.sh

# Check if flag file exists
kubectl exec -it <pod-name> -- ls -la /tmp/.vulnapp_flags/

# Force scroll to bottom in browser (user action)
```

### Issue: Container Escape Fails
```bash
# Verify privileged mode
kubectl get pod <pod-name> -o jsonpath='{.spec.containers[0].securityContext}'
# Should show: {"privileged":true}

# Verify host mount
kubectl exec -it <pod-name> -- ls /host/
# Should show host filesystem

# If not privileged:
kubectl delete -f vulnerable.example.yaml
# Edit vulnerable.example.yaml to add privileged: true
kubectl apply -f vulnerable.example.yaml
```

### Issue: Setup Script Fails
```bash
# Check script permissions
kubectl exec -it <pod-name> -- ls -la /bin/learning/*_setup.sh

# Check script syntax
kubectl exec -it <pod-name> -- bash -n /bin/learning/01_setup.sh

# Manually run with errors shown
kubectl exec -it <pod-name> -- bash -x /bin/learning/01_setup.sh
```

### Issue: Cleanup Doesn't Run
```bash
# Check backend logs
kubectl logs <pod-name> | grep CLEANUP

# Manually run cleanup
kubectl exec -it <pod-name> -- /bin/learning/01_cleanup.sh

# Check for leftover artifacts
kubectl exec -it <pod-name> -- ps aux | grep sleep
kubectl exec -it <pod-name> -- ls /tmp/.vulnapp_flags/
```

---

## Safety Checklist (CRITICAL)

Before deploying, verify:

### Network Isolation
- [ ] Deployed in isolated lab environment
- [ ] NOT connected to production networks
- [ ] Firewall rules block external access
- [ ] Only accessible from authorized IPs

### Cluster Verification
- [ ] Current kubectl context is LAB (not prod)
- [ ] Namespace is isolated test environment
- [ ] No production workloads in same cluster
- [ ] Resource limits configured

### Monitoring
- [ ] Falcon sensor deployed (optional but recommended)
- [ ] Logging configured
- [ ] Alerts configured for unusual activity
- [ ] Team notified of test deployment

### Documentation Reviewed
- [ ] Read REAL_EXPLOITATION_GUIDE.md
- [ ] Understand dangerous configurations
- [ ] Know how to manually cleanup
- [ ] Have incident response plan

---

## Expected Detections (With Falcon Sensor)

If Falcon is deployed, expect these detections:

| Scenario | Expected Detection | Severity |
|----------|-------------------|----------|
| 1 - Remote Shell | BashReverseShell | Medium |
| 2 - Discovery | ContainerDiscovery | Low |
| 3 - Data Theft | CredentialAccess | High |
| 4 - Escape | **ContainerEscape** | **CRITICAL** |
| 5 - Persistence | PersistenceTechnique | High |
| 6 - Evasion | ProcessMasquerading | Medium |
| 7 - Full Chain | Multiple (10+) | Critical |

**Key Detection**: Scenario 4 should trigger `ContainerEscape` - this validates the setup.

---

## Post-Deployment Validation

### ✅ Functionality Tests
- [ ] All 7 scenarios appear in UI
- [ ] Scenarios in correct order (1-7)
- [ ] WebSocket streaming works
- [ ] Terminal output appears in real-time
- [ ] Flags visible at end of each scenario
- [ ] Flag submission works
- [ ] Progress bar updates
- [ ] Points total correctly (1,000)

### ✅ Security Tests
- [ ] Container is actually privileged
- [ ] Host mount is accessible
- [ ] Docker socket is mounted
- [ ] Capabilities are present
- [ ] Dangerous configs are working

### ✅ Exploitation Tests
- [ ] Scenario 1: Can read /proc/<PID>/environ
- [ ] Scenario 4: Can escape to host
- [ ] Scenario 5: Can write to host filesystem
- [ ] Setup scripts plant flags successfully
- [ ] Cleanup scripts remove artifacts

---

## Quick Reference Commands

```bash
# Get pod name
export POD=$(kubectl get pods -l run=vulnerable.example.com -o jsonpath='{.items[0].metadata.name}')

# Tail logs
kubectl logs -f $POD

# Exec into container
kubectl exec -it $POD -- bash

# Check if setup scripts work
kubectl exec -it $POD -- /bin/learning/01_setup.sh

# Check if cleanup works
kubectl exec -it $POD -- /bin/learning/01_cleanup.sh

# List all planted flags
kubectl exec -it $POD -- find /tmp /host -name "*.flag" -o -name "*flag*" 2>/dev/null

# Kill all fake processes
kubectl exec -it $POD -- pkill -f "sleep 3600"

# Check WebSocket connection
kubectl logs $POD | grep WebSocket

# Force restart pod
kubectl delete pod $POD
```

---

## Final Pre-Deployment Checklist

Before you click deploy, verify:

- [x] ✅ Latest code pulled from GitHub
- [x] ✅ Docker image built successfully
- [x] ✅ All 7 scenarios verified in code
- [x] ✅ Points total = 1,000
- [x] ✅ Script files numbered correctly (01-07)
- [x] ✅ Dangerous configs in Kubernetes manifest
- [x] ✅ Documentation reviewed
- [ ] ⚠️  Kubectl context = LAB (verify manually!)
- [ ] ⚠️  Team notified of test
- [ ] ⚠️  Incident response ready

---

## Known Issues & Workarounds

### Issue: Old GitHub Cache
**Problem**: Downloaded ZIP has old code
**Solution**: Download fresh from main branch:
```bash
wget https://github.com/jachetti/vulnapp/archive/refs/heads/main.zip
unzip main.zip
cd vulnapp-main
```

### Issue: Docker Build Cache
**Problem**: Build uses cached layers with old code
**Solution**: Use `--no-cache` flag:
```bash
sudo docker build --no-cache -t vulnapp:2.0.0 .
```

### Issue: Falcon Blocks Setup Scripts
**Problem**: Falcon prevents planting fake credentials
**Solution**: This is expected! Document the detection and continue.

---

## Success Criteria

Your deployment is successful when:

✅ All 7 scenarios load in UI
✅ Scenarios ordered 1-7
✅ Click scenario shows terminal output
✅ Can see flag in terminal output
✅ Flag submission updates progress bar
✅ Completing all 7 = 1,000 points
✅ Certification badge appears
✅ Setup/cleanup scripts execute automatically
✅ Falcon detections appear (if sensor deployed)

---

**YOU ARE READY TO DEPLOY! 🚀**

Questions? See REAL_EXPLOITATION_GUIDE.md for detailed exploitation instructions.
