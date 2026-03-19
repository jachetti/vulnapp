# VulnApp v2.0 - Container Security Testing Lab Guide

## 🎯 Welcome!

Thank you for attending today's office hours on container security! This lab guide will walk you through hands-on testing of **VulnApp v2.0 - Real Exploitation Edition**.

**What You'll Learn:**
- How container attacks differ from traditional endpoint attacks
- Real exploitation techniques (not just simulations!)
- Container escape methods
- How CrowdStrike Falcon detects container threats

**Time Required:** 60-90 minutes
**Prerequisites:** Access to SE lab environment (Amazon Linux)

---

## 📋 Lab Overview

### The 7 Teaching Scenarios

| # | Scenario | Points | What You'll Do |
|---|----------|--------|----------------|
| 1 | Remote Access Shell | 100 | Search process memory for hidden credentials |
| 2 | Process Discovery | 150 | Enumerate container boundaries |
| 3 | Data Theft & Exfiltration | 150 | Extract secrets from fake AWS credentials |
| 4 | **Container Escape** ⭐ | 200 | **Actually escape** from container to host |
| 5 | Persistence | 150 | Install backdoors for long-term access |
| 6 | Defense Evasion | 100 | Bypass detection with process masquerading |
| 7 | Full Attack Chain | 150 | Multi-stage attack simulation |

**Total: 1,000 points = Container Security SE Certification! 🏆**

---

## 🚀 Part 1: Lab Setup (10 minutes)

### Step 1: Connect to Your Lab

You should have received lab access credentials. SSH into your assigned Amazon Linux instance:

```bash
ssh -i your-key.pem ec2-user@<YOUR-LAB-IP>
```

### Step 2: Stop Apache (httpd)

VulnApp needs port 80, but httpd (Apache) is using it. Let's stop it:

```bash
# Stop the Apache web server
sudo service httpd stop

# Verify port 80 is now free
sudo lsof -i :80
```

**Expected result:** The `lsof` command should return nothing (port is free).

**If you see httpd still running:**
```bash
# Force kill it
sudo killall httpd
```

### Step 3: Download VulnApp

Since git isn't installed, we'll download directly from GitHub:

```bash
# Go to home directory
cd ~

# Download latest code
wget https://github.com/jachetti/vulnapp/archive/refs/heads/main.zip

# Extract it
unzip main.zip

# Enter the directory
cd vulnapp-main
```

**Checkpoint:** You should see these files:
```bash
ls
# Should show: README.md, Dockerfile, bin/, frontend/, backend/, etc.
```

### Step 4: Build the Docker Image

This will take 5-10 minutes as it builds both frontend (React) and backend (Go):

```bash
# Build with no cache to ensure fresh build
sudo docker build --no-cache -t vulnapp:2.0.0 .
```

**What you'll see:**
- Stage 1: Building React frontend
- Stage 2: Building Go backend
- Stage 3: Assembling final image

**Expected output at end:**
```
Successfully built [image-id]
Successfully tagged vulnapp:2.0.0
```

**If build fails:** Check the error message. Common issues:
- Out of disk space: `df -h` (need ~2GB free)
- Docker not running: `sudo service docker start`

### Step 5: Run the Container

Now we'll run VulnApp with **intentionally dangerous configurations** (for training only!):

```bash
sudo docker run -d --name vulnapp \
  --privileged \
  --cap-add=SYS_ADMIN \
  --cap-add=SYS_PTRACE \
  --cap-add=DAC_READ_SEARCH \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /:/host \
  -p 80:80 \
  vulnapp:2.0.0
```

**What these flags mean:**
- `--privileged`: Allows container escape (needed for Scenario 4)
- `--cap-add`: Dangerous capabilities for exploitation
- `-v /var/run/docker.sock`: Docker socket access
- `-v /:/host`: Host filesystem mount
- `-p 80:80`: Expose on port 80

⚠️ **WARNING:** Never use these settings in production!

### Step 6: Verify It's Running

```bash
# Check container status
sudo docker ps | grep vulnapp

# Check logs
sudo docker logs vulnapp
```

**Expected log output:**
```
==================================================
  VulnApp v2.0 - Container Security Testing
  CrowdStrike - Falcon Detection Validation
==================================================

Starting VulnApp with 24 attack scenarios...
Port: 80
Frontend: http://localhost/
```

### Step 7: Access the Web Interface

Get your lab's public IP:

```bash
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

Open in your browser:
```
http://<YOUR-PUBLIC-IP>
```

**You should see:**
- Dark themed interface with CrowdStrike branding
- Title: "VulnApp v2.0 - Real Exploitation Edition"
- 7 scenario cards
- Progress tracker showing 0 / 1000 points

**If you don't see this:** Check troubleshooting section at the end.

---

## 🎯 Part 2: Scenario Walkthroughs (45-60 minutes)

### Scenario 1: Remote Access Shell (100 points)

**What You'll Learn:** Containers are just processes - shells work the same way.

**Instructions:**
1. Click the **"Remote Access Shell"** card
2. Click **"Execute ▶"** button
3. Watch the terminal output in real-time

**What to look for:**

```
[SETUP] Flag planted in process environment (PID: 1234)
[SETUP] Ready for exploitation!

[+] Searching for interesting processes...
[*] Running: ps aux

[+] Found suspicious process: PID 1234
[+] Reading process environment...
FLAG_CREDENTIAL=FLAG{reverse_shell_works_same_in_containers}

🚩 FLAG CAPTURED!
════════════════════════════════════════════════════════════════
  FLAG{reverse_shell_works_same_in_containers}

  Copy this flag and submit it to earn 100 points!
════════════════════════════════════════════════════════════════

[CLEANUP] ✓ Scenario cleanup complete
```

**Key Teaching Points:**
- The setup script **planted a fake admin process** with the flag in its environment
- The scenario performs **real enumeration** with `ps aux` and `/proc/<PID>/environ`
- This demonstrates how attackers find credentials left in environment variables
- Falcon detects the enumeration behavior

**Submit your flag:**
1. Copy the flag: `FLAG{reverse_shell_works_same_in_containers}`
2. Paste in the flag submission box
3. Click "Submit"
4. Progress bar updates to 100 / 1000 points ✓

---

### Scenario 2: Process Discovery (150 points)

**What You'll Learn:** Attackers enumerate to understand container boundaries.

**Instructions:**
1. Click **"Process Discovery"**
2. Click **"Execute ▶"**
3. Watch for reconnaissance commands

**What to look for:**
- Commands like `ps`, `top`, `cat /proc/1/cgroup`
- Discovery of container isolation
- Flag hidden in a process command line

**Key Teaching Point:**
> "In traditional endpoints, `ps` shows all processes. In containers, you only see processes in your namespace. This is the 'limited visibility' attackers face."

**Submit your flag** to reach **250 / 1000 points**

---

### Scenario 3: Data Theft & Exfiltration (150 points)

**What You'll Learn:** Impact of credential theft in containerized apps.

**Instructions:**
1. Click **"Data Theft & Exfiltration"**
2. Watch the scenario search for secrets

**What happens:**
- Setup plants fake AWS credentials
- Setup plants fake database configs
- Setup plants Kubernetes tokens
- Scenario searches common credential locations
- Flag discovered in credentials file

**Real-world parallel:**
> "Many developers accidentally commit AWS keys to environment variables or config files. Attackers systematically search for these."

**Submit your flag** to reach **400 / 1000 points**

---

### Scenario 4: Container Escape ⭐ (200 points)

**⭐ THIS IS THE KEY DIFFERENTIATOR ⭐**

**What You'll Learn:** How containers are NOT VMs - attackers can break out!

**Instructions:**
1. Click **"Container Escape"**
2. Click **"Execute ▶"**
3. **Watch carefully** - this is the most important scenario

**What happens:**
- Checks if container is privileged (it is!)
- Checks if Docker socket is mounted (it is!)
- Attempts **actual container escape** using cgroup exploit
- Reads flag from **host filesystem** (not container)

**Expected output:**
```
[+] Container running in privileged mode!
[+] Attempting container escape via cgroup...

⚠️  ESCAPE SUCCESSFUL - Now on host system!

Reading flag from host: /tmp/vulnapp_escape/.secret_flag
FLAG{container_isolation_bypassed_welcome_to_host}

🚩 FLAG CAPTURED!
```

**Key Teaching Points:**

**Customer Question:** *"What's the difference between a container and a VM?"*

**Your Answer:**
> "Great question! VMs have their own kernel - you can't escape to the hypervisor. Containers **share the kernel** with the host. If misconfigured (like privileged mode), attackers can exploit kernel features to escape. That's why you need container-aware security like Falcon - traditional AV can't detect these attacks."

**Customer Question:** *"How common is this?"*

**Your Answer:**
> "30% of containers in production run with dangerous misconfigurations. We've seen container escapes in breaches at Equifax (147M records), Tesla (cryptomining), and Docker Hub. This is THE key risk that makes container security different from endpoint security."

**Submit your flag** to reach **600 / 1000 points**

---

### Scenario 5: Persistence Establishment (150 points)

**What You'll Learn:** How attackers maintain long-term access.

**Instructions:**
1. Click **"Persistence Establishment"**
2. Watch backdoor installation

**What happens:**
- Creates backdoor script
- Attempts to install cron job
- Writes to host filesystem (via /host mount)
- Flag revealed after successful installation

**Real-world impact:**
> "Attackers install persistence so they can return even after you reboot. The backdoor survives container restarts."

**Submit your flag** to reach **750 / 1000 points**

---

### Scenario 6: Defense Evasion & Masquerading (100 points)

**What You'll Learn:** Why behavior-based detection beats signatures.

**Instructions:**
1. Click **"Defense Evasion & Masquerading"**
2. Watch process masquerading attempt

**What happens:**
- Creates fake "legitimate" process name
- Attempts to bypass detection
- Falcon detects it anyway (behavior-based)

**Key Teaching Point:**
> "Attackers often name malicious processes 'svchost.exe' or 'chrome.exe' to hide. Traditional signature-based AV is fooled. Falcon uses behavioral AI - it doesn't care what you call it, it sees what you're doing."

**Submit your flag** to reach **850 / 1000 points**

---

### Scenario 7: Full Attack Chain - MASTER LEVEL (150 points)

**What You'll Learn:** How attacks progress through multiple stages.

**Instructions:**
1. Click **"Full Attack Chain - MASTER LEVEL"**
2. Watch complete breach simulation

**What happens:**
- **Stage 1:** Web vulnerability exploitation
- **Stage 2:** Container compromise
- **Stage 3:** Credential theft (Kubernetes tokens)
- **Stage 4:** Container escape
- **Stage 5:** Host compromise
- **Stage 6:** Cluster-wide access

**Expected output:**
```
STAGE 1: Initial Access via Web Vulnerability
STAGE 2: Container Enumeration
STAGE 3: Credential Theft
STAGE 4: Container Escape
STAGE 5: Privilege Escalation
STAGE 6: Lateral Movement

FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}
```

**Real-world parallel:**
> "This simulates a real APT campaign. Attacker starts with a simple web bug, then pivots through containers to gain cluster admin. Average time: 10 minutes. Average breach cost: $4.5M."

**Submit your flag** to reach **1000 / 1000 points! 🏆**

---

## 🏆 Part 3: Certification (5 minutes)

Once you've completed all 7 scenarios:

1. **Check your progress:** Top of screen should show **1000 / 1000 points**
2. **Certification badge appears:** 🏆 "CERTIFIED - VulnApp Container Security SE"
3. **Screenshot for your records!**

**Congratulations!** You're now certified on container security fundamentals.

---

## 📊 Part 4: Falcon Detection Review (Optional)

If your lab has Falcon sensor installed:

### Check Falcon Console

1. Log into Falcon console
2. Navigate to **Activity > Detections**
3. Filter by your hostname
4. Expected detections:

| Scenario | Detection Name | Severity |
|----------|---------------|----------|
| 1 | BashReverseShell | Medium |
| 2 | ContainerDiscovery | Low |
| 3 | CredentialAccess | High |
| 4 | **ContainerEscape** | **CRITICAL** |
| 5 | PersistenceTechnique | High |
| 6 | ProcessMasquerading | Medium |
| 7 | Multiple (10+) | Critical |

**Key Detection:** Scenario 4 should show `ContainerEscape` - this validates that Falcon detected the real exploitation.

---

## 🧹 Part 5: Cleanup (5 minutes)

### Stop and Remove VulnApp

```bash
# Stop the container
sudo docker stop vulnapp

# Remove the container
sudo docker rm vulnapp

# Remove the image (optional - saves disk space)
sudo docker rmi vulnapp:2.0.0

# Clean up downloaded files (optional)
cd ~
rm -rf vulnapp-main main.zip
```

### Restart httpd (if needed for other labs)

```bash
sudo service httpd start
```

---

## ❓ Troubleshooting

### Issue: Web UI won't load

**Check 1:** Is container running?
```bash
sudo docker ps | grep vulnapp
```

**Check 2:** Check logs for errors
```bash
sudo docker logs vulnapp | tail -20
```

**Check 3:** Is port 80 accessible?
```bash
curl http://localhost
# Should return HTML
```

**Fix:** Restart container
```bash
sudo docker restart vulnapp
```

### Issue: Flag not showing in terminal

**Symptom:** Terminal output stops before flag appears

**Fix 1:** Scroll down in terminal window
- There's a "Scroll to Bottom" button if you scrolled up

**Fix 2:** Re-run the scenario
- Close execution panel
- Click "Execute ▶" again

**Fix 3:** Check if setup script ran
```bash
sudo docker logs vulnapp | grep SETUP
```

### Issue: Container Escape fails

**Check:** Is container actually privileged?
```bash
sudo docker inspect vulnapp | grep Privileged
# Should show: "Privileged": true,
```

**Check:** Is host mounted?
```bash
sudo docker exec vulnapp ls /host
# Should show host filesystem
```

**If not:** Recreate container with correct flags (see Step 5)

### Issue: Build fails

**Error:** "No space left on device"
```bash
# Check disk space
df -h

# Clean up old Docker images
sudo docker system prune -a
```

**Error:** "Cannot connect to Docker daemon"
```bash
# Start Docker
sudo service docker start
```

### Issue: Can't access from browser

**Check 1:** Get correct public IP
```bash
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

**Check 2:** Security group allows port 80
- Contact lab admin if needed

**Workaround:** Use port forwarding
```bash
# On your laptop (new terminal)
ssh -i your-key.pem -L 8080:localhost:80 ec2-user@<LAB-IP>

# Then browse to: http://localhost:8080
```

---

## 📚 Additional Resources

**Documentation:**
- Full Exploitation Guide: [REAL_EXPLOITATION_GUIDE.md](https://github.com/jachetti/vulnapp/blob/main/REAL_EXPLOITATION_GUIDE.md)
- Implementation Details: [IMPLEMENTATION_SUMMARY.md](https://github.com/jachetti/vulnapp/blob/main/IMPLEMENTATION_SUMMARY.md)
- GitHub Repository: [https://github.com/jachetti/vulnapp](https://github.com/jachetti/vulnapp)

**Container Security Resources:**
- MITRE ATT&CK for Containers: [attack.mitre.org/matrices/enterprise/containers/](https://attack.mitre.org/matrices/enterprise/containers/)
- CrowdStrike Container Security: [crowdstrike.com/products/cloud-security/falcon-cloud-workload-protection/](https://www.crowdstrike.com/products/cloud-security/falcon-cloud-workload-protection/)

---

## 🎓 Key Takeaways

**For Customer Conversations:**

1. **"Containers are not VMs"**
   - Share kernel with host
   - Escapes are possible with misconfigs
   - Need container-aware security

2. **"Same attacks, different surface area"**
   - Reverse shells work the same
   - But containers add Docker socket, capabilities, etc.
   - More attack vectors than traditional endpoints

3. **"Behavioral detection is critical"**
   - Can't rely on signatures
   - Attackers change names, obfuscate code
   - Falcon's AI detects behavior patterns

4. **"Real breaches happen this way"**
   - Equifax: Container escape → 147M records
   - Tesla: Exposed Kubernetes → cryptomining
   - Average breach cost: $4.5M

**Demo Value Props:**
- ✅ Falcon detects container-specific attacks
- ✅ Works without app instrumentation
- ✅ Sees inside containers in real-time
- ✅ Detects escapes before data loss

---

## 📞 Questions or Issues?

**During Lab:**
- Ask the presenter
- Check troubleshooting section above

**After Lab:**
- Internal Slack: #container-security
- Lab admin: [contact info]

---

## ✅ Lab Completion Checklist

By the end of this lab, you should have:

- [ ] Successfully deployed VulnApp
- [ ] Completed all 7 scenarios
- [ ] Earned 1,000 points
- [ ] Received certification badge
- [ ] Seen flags appear through real exploitation
- [ ] Witnessed container escape (Scenario 4)
- [ ] Reviewed Falcon detections (if sensor present)
- [ ] Cleaned up lab environment

**Time to complete:** 60-90 minutes

---

## 🌟 Next Steps

**Want to go deeper?**

1. **Re-run scenarios** and read the exploitation code:
   ```bash
   sudo docker exec vulnapp cat /bin/learning/04_Container_Escape.sh
   ```

2. **Try manual exploitation:**
   ```bash
   sudo docker exec -it vulnapp bash
   # Now manually perform the attacks!
   ```

3. **Explore the code:**
   - Backend: `backend/attack_metadata.go`
   - Frontend: `frontend/src/components/`
   - Scripts: `bin/learning/*.sh`

4. **Use in customer demos:**
   - Deploy in your own lab
   - Walk customers through scenarios
   - Show live Falcon detections

---

**Thank you for participating! 🦅**

**Questions about using this in customer demos?** Contact [presenter name]

---

*VulnApp v2.0 - Real Exploitation Edition*
*CrowdStrike Container Security Training Platform*
*⚠️ For training purposes only - Deploy in isolated labs only*
