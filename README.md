# VulnApp v2.0 🦅

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Docker Repository on Quay](https://quay.io/repository/crowdstrike/vulnapp/status)](https://quay.io/repository/crowdstrike/vulnapp)
[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8.svg)](go.mod)
[![React](https://img.shields.io/badge/React-18.3-61DAFB.svg)](frontend/package.json)

**An intentionally vulnerable container application with REAL EXPLOITATION for CrowdStrike Falcon sensor validation and security training.**

VulnApp v2.0 is a modern, interactive web platform featuring **7 teaching scenarios with authentic CTF exploitation** mapped to the MITRE ATT&CK framework. Students discover flags through actual reconnaissance and exploitation techniques, not simulation.

---

## ⚠️ WARNING

**This application is INTENTIONALLY VULNERABLE for security training and testing purposes.**

**DO NOT:**
- ❌ Deploy on production networks
- ❌ Expose to the public internet
- ❌ Run on systems with sensitive data
- ❌ Use without proper network isolation

**DO:**
- ✅ Deploy only in isolated lab environments
- ✅ Use dedicated VLANs/subnets
- ✅ Implement network monitoring
- ✅ Follow security best practices

---

## 🎯 What's New in v2.0

- 🔥 **REAL EXPLOITATION MODE** - Scenarios perform actual attacks, not simulations
- 🚩 **Authentic CTF Experience** - Discover flags through genuine reconnaissance
- ✨ **Modern React UI** - Interactive web interface with real-time execution
- 🎓 **7 Teaching Scenarios** - Progressive learning path with 1,000 total points
- 🏆 **SE Certification** - Complete all scenarios for Container Security SE badge
- 📊 **MITRE ATT&CK Integration** - Visual technique mappings and badges
- 🔴 **WebSocket Streaming** - Live attack output in terminal-style display
- 📈 **Progress Tracking** - Track points, scenarios completed, and certification status
- 🔧 **Auto Setup/Cleanup** - Vulnerabilities planted and removed automatically
- 🐳 **Docker Ready** - Optimized multi-stage build
- 📱 **Responsive Design** - Works on desktop, tablet, and mobile

---

## 🚀 Quick Start

**Option 1: From GitHub (with wget - no git required)**
```bash
# Download and extract
wget https://github.com/jachetti/vulnapp/archive/refs/heads/main.zip
unzip main.zip
cd vulnapp-main

# Build and run
docker build -t vulnapp .
docker run -p 80:80 vulnapp
```

**Option 2: With git**
```bash
git clone https://github.com/jachetti/vulnapp.git
cd vulnapp
docker build -t vulnapp .
docker run -p 80:80 vulnapp
```

**That's it!** Open http://localhost in your browser.

---

### Detailed Options

**Docker (Recommended)**
```bash
# Build and run
docker build -t vulnapp .
docker run -d --name vulnapp -p 80:80 vulnapp

# Access application
open http://localhost

# Stop/start
docker stop vulnapp
docker start vulnapp
```

**Kubernetes (⚠️ REQUIRES ISOLATED LAB)**
```bash
# WARNING: This config is INTENTIONALLY VULNERABLE
# Includes: privileged mode, host mounts, dangerous capabilities
# Deploy ONLY in isolated lab environments!

kubectl apply -f https://raw.githubusercontent.com/jachetti/vulnapp/main/vulnerable.example.yaml
kubectl get service vulnerable-example-com
```

**OpenShift**
```bash
oc apply -f https://raw.githubusercontent.com/jachetti/vulnapp/main/vulnerable.openshift.yaml
oc get route vulnapp
```

---

## 📦 Features

### Modern Web Interface
- **React 18.3 + TypeScript** - Modern, type-safe frontend
- **Tailwind CSS** - CrowdStrike branded dark theme
- **Real-time WebSocket** - Live attack execution output
- **Split-view Panel** - Attack details + terminal output side-by-side
- **Category Filtering** - Browse by MITRE ATT&CK tactic
- **Mobile Responsive** - Works on all devices

### 🎓 Teaching Scenarios with Real Exploitation

**7 Progressive Scenarios with AUTHENTIC CTF Exploitation:**

Perfect for CrowdStrike SEs learning container security. Each scenario **performs real exploitation** to discover flags through actual reconnaissance techniques. No simulation - students practice genuine attack methods in a controlled environment.

**Total: 1,000 Points**

| # | Scenario | Real Exploitation | Points | Key Concept |
|---|----------|-------------------|--------|-------------|
| 1 | Remote Access Shell | Search `/proc/<PID>/environ` for hidden flag | 100 | Containers are processes |
| 2 | Process Discovery | Find flag in hidden process command line | 150 | Namespace isolation |
| 3 | Data Collection & Exfiltration | Extract flag from fake AWS credentials | 150 | Data theft impact |
| 4 | Container Escape ⭐ | **Actually escape** to read flag on host | 200 | THE key differentiator |
| 5 | Persistence Establishment | Install real backdoor to reveal flag | 150 | Long-term threats |
| 6 | Defense Evasion & Masquerading | Masquerade process to access flag | 100 | Behavior-based detection |
| 7 | Full Attack Chain (Master Level) | Multi-stage exploitation for final flag | 150 | Complete breach simulation |

**How It Works:**
1. **Setup Script** - Plants flags and vulnerabilities before scenario
2. **Main Scenario** - Student performs REAL exploitation techniques
3. **Cleanup Script** - Removes all artifacts after completion

**Features:**
- 🔥 **Real reconnaissance** - Students search `/proc`, enumerate processes, read files
- 🚩 **Authentic flags** - Hidden in processes, credentials, host filesystem
- 🔒 **Auto-cleanup** - All vulnerabilities removed after each scenario
- 📊 **Progress tracking** - 1,000 points total across 7 scenarios
- 🎯 **Genuine Falcon detections** - Real attacks trigger real detections
- 🏆 **Certification badge** - Earned by completing all 7 scenarios

**⚠️ REQUIRES:** Privileged containers with host mounts (see `vulnerable.example.yaml`)

**Perfect for:**
- SE office hours training (~60 minutes)
- Customer demos with real exploitation
- Hands-on container security workshops
- Team onboarding with practical skills

### 🔬 Attack Scenarios by MITRE ATT&CK

**All 7 teaching scenarios mapped to MITRE ATT&CK techniques:**

1. **Remote Access Shell** (T1059.004, T1071.001) - Command execution and C2
2. **Process Discovery** (T1613, T1082) - Container and system enumeration
3. **Data Collection & Exfiltration** (T1005, T1552.007, T1048.003) - Credential theft
4. **Container Escape** ⭐ (T1611) - **KEY DIFFERENTIATOR** - Privilege escalation
5. **Persistence Establishment** (T1053.003, T1543.002) - Backdoor installation
6. **Defense Evasion & Masquerading** (T1036, T1055) - Process hiding
7. **Full Attack Chain** (T1190, T1059.004, T1613, T1552.007, T1611) - Multi-stage attack

**Expected Falcon Detections:**
- ✅ BashReverseShell (Scenario 1)
- ✅ ContainerDiscovery (Scenario 2)
- ✅ CredentialAccess (Scenario 3)
- ✅ **ContainerEscape** (Scenario 4) ⭐ **CRITICAL**
- ✅ PersistenceTechnique (Scenario 5)
- ✅ ProcessMasquerading (Scenario 6)
- ✅ Multiple detections (Scenario 7)

### API & Integration
- **8 REST endpoints** - Attack management and execution
- **WebSocket streaming** - Real-time output
- **Progress tracking API** - CTF flag validation and points
- **Health checks** - Container readiness monitoring
- **JSON responses** - Easy integration

---

## 📖 Documentation

- **[Real Exploitation Guide](REAL_EXPLOITATION_GUIDE.md)** - 🔥 **START HERE** - Complete exploitation guide with safety warnings
- **[Implementation Summary](IMPLEMENTATION_SUMMARY.md)** - What was built and how to use it
- **[7 Scenario POC Plan](7_SCENARIO_POC_PLAN.md)** - Implementation roadmap
- **[Learning Scenarios Guide](bin/learning/README.md)** - SE training scenarios and facilitator guide
- **[Docker Guide](DOCKER_GUIDE.md)** - Comprehensive Docker documentation
- **[Test Guide](TEST_GUIDE.md)** - Complete testing checklist
- **[Frontend README](frontend/README.md)** - React development guide

---

## 🌐 API Endpoints

### REST APIs
```
GET  /api/attacks                  - List all attacks with metadata
GET  /api/attacks/:id              - Get specific attack details
POST /api/attacks/:id/execute      - Execute attack scenario
GET  /api/executions               - List all executions
GET  /api/executions/:id           - Get execution status and output
GET  /api/health                   - Health check
GET  /api/system/info              - System information
POST /api/progress/submit-flag     - Submit CTF flag (Learning Mode)
GET  /api/progress?session_id=xxx  - Get user progress (Learning Mode)
```

### WebSocket
```
WS   /api/executions/:id/stream - Real-time output streaming
```

### Vulnerable Endpoints (Training Only)
```
GET  /api/vulnerable/rce           - Command injection
GET  /api/vulnerable/lfi           - File inclusion
POST /api/vulnerable/reverse-shell - Interactive reverse shell
GET  /api/vulnerable/sqli          - SQL injection
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│     User Browser (Port 80)          │
│  ┌───────────────────────────────┐  │
│  │  React Frontend                │  │
│  │  - Attack Grid                 │  │
│  │  - Execution Panel             │  │
│  │  - Interactive Scenarios       │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
              │
       HTTP/WebSocket
              │
┌─────────────────────────────────────┐
│     Go Backend (shell2http)         │
│  ┌─────────┐  ┌─────────────────┐  │
│  │   API   │  │    WebSocket    │  │
│  │ Routes  │  │    Streaming    │  │
│  └─────────┘  └─────────────────┘  │
│              │                      │
│     ┌────────▼────────┐            │
│     │ Attack Executor │            │
│     └────────┬────────┘            │
└──────────────┼─────────────────────┘
               │
        24 Attack Scripts
               │
     ┌─────────┴─────────┐
     │                   │
┌────▼─────┐      ┌─────▼─────┐
│ Existing │      │  Modern   │
│   (12)   │      │   (12)    │
└──────────┘      └───────────┘
```

---

## 🔧 Build from Source

### Prerequisites
- Docker 20.10+
- Node.js 18+ (for frontend development)
- Go 1.23+ (for backend development)

### Build Process

**Option 1: Download from GitHub (no git required)**
```bash
# Download latest release
wget https://github.com/jachetti/vulnapp/archive/refs/heads/main.zip
unzip main.zip
cd vulnapp-main

# Automated build and test
./build-and-test.sh

# Or manual build
cd frontend
npm install
npm run build
cd ..
docker build -t vulnapp:2.0 .

# Run
docker run -p 80:80 vulnapp:2.0
```

**Option 2: Clone with git**
```bash
# Clone repository
git clone https://github.com/jachetti/vulnapp.git
cd vulnapp

# Then follow same build steps above
./build-and-test.sh
```

---

## 🧪 Usage Examples

### Example 1: Real Exploitation Mode (SE Training)

**Perfect for hands-on security training:**

1. **Deploy with vulnerable config**: `kubectl apply -f vulnerable.example.yaml`
2. Open web interface: `http://localhost` or LoadBalancer IP
3. **Start with Scenario 1: Remote Access Shell**
4. Watch terminal output as the scenario:
   - Runs setup script (plants flag in process)
   - Performs REAL reconnaissance (`ps aux`, search `/proc`)
   - Discovers hidden flag in process environment
   - Displays: `FLAG{reverse_shell_works_same_in_containers}`
   - Runs cleanup script (removes artifacts)
5. **Submit the flag** to earn 100 points
6. **Progress through all 7 scenarios**
7. **Earn certification** at 1,000 points! 🏆

**Session time:** ~60 minutes for all 7 scenarios

**Example Terminal Output:**
```
[SETUP] Flag planted in process environment (PID: 1234)
[+] Searching for interesting processes...
[+] Found suspicious process: PID 1234
[+] Reading process environment...
FLAG_CREDENTIAL=FLAG{reverse_shell_works_same_in_containers}
🚩 FLAG CAPTURED!
[CLEANUP] Scenario cleanup complete
```

### Example 2: Basic Attack Execution

1. Open web interface: `http://localhost`
2. Browse attack grid organized by MITRE category
3. Click "Execute ▶" on any attack
4. View real-time output in split-view panel

### Example 3: Interactive Reverse Shell (LAN Testing)

**Perfect for Docker + LAN environments:**

```bash
# On attacker machine (e.g., Kali at 192.168.1.100)
nc -lvnp 4444
```

**In VulnApp Web UI:**
1. Click "🎯 Interactive Reverse Shell"
2. Enter attacker IP: `192.168.1.100`
3. Enter port: `4444`
4. Click "🚀 Launch Exploitation Chain"
5. Receive shell on attacker machine!

### Example 4: Docker Socket Exploitation

```bash
# Run with Docker socket mounted
docker run -p 80:80 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  vulnapp:2.0
```

**Execute attack:**
1. Navigate to "Docker Socket Exploitation"
2. Click "Execute"
3. Watch live terminal output as attack demonstrates host escape

### Example 5: Privileged Container Testing

```bash
# Run in privileged mode
docker run -p 80:80 --privileged vulnapp:2.0
```

Execute "Privileged Container Escape" to see cgroup exploitation.

---

## 🛡️ MITRE ATT&CK Coverage

All 24 attacks mapped to MITRE ATT&CK framework:

| Tactic | Techniques | Attacks |
|--------|-----------|---------|
| Execution (TA0002) | T1059.004 | 1 |
| Persistence (TA0003) | T1525, T1053.003, T1195.002 | 3 |
| Privilege Escalation (TA0004) | T1611, T1068 | 7 |
| Defense Evasion (TA0005) | T1027, T1036, T1055, T1222, T1562.001, T1612, T1014 | 6 |
| Credential Access (TA0006) | T1552.001, T1552.007 | 2 |
| Collection (TA0009) | T1005 | 1 |
| Command & Control (TA0011) | T1071.001 | 3 |
| Exfiltration (TA0010) | T1048.003 | 1 |
| Impact (TA0040) | T1496 | 2 |

**Total:** 9 tactics, 18+ techniques, 24 attack scenarios

---

## 🏢 Use Cases

### 1. SE Training & Office Hours
- 6 progressive learning scenarios with CTF flags
- Bridges endpoint security knowledge to containers
- Business impact examples ($147M breach simulation)
- SE talking points for customer conversations
- 1-hour training session (45 min scenarios + 15 min presentation)
- Certification badge upon completion

### 2. CrowdStrike Falcon Validation
- Deploy in test environment with Falcon sensor
- Execute attack scenarios
- Validate Falcon detections in console
- Tune detection policies

### 3. Security Training
- Hands-on container security training
- MITRE ATT&CK technique demonstrations
- Attack chain visualization
- Detection engineering practice

### 4. Research & Development
- Container escape research
- Kubernetes security testing
- Detection capability validation
- Red team scenario development

### 5. CI/CD Pipeline Testing
- Automated security testing
- Detection rule validation
- Sensor deployment verification

---

## 🔒 Security Best Practices

### Network Isolation
**REQUIRED:** Deploy in isolated environments
- Dedicated VLANs
- Firewalled subnets
- No external internet access
- Monitored networks

### Container Security
- Apply network policies (Kubernetes)
- Set resource limits
- Use non-root user where possible
- Monitor all activities

### Monitoring
Always monitor VulnApp:
- Network traffic
- Process execution
- File modifications
- API access logs

---

## 🧪 Testing

```bash
# Backend tests (file structure, scripts, execution)
./test_backend.sh

# API tests (requires running server)
./test_api.sh

# Full build and integration tests
./build-and-test.sh
```

**Test Results:** 41/41 passed (100%)

---

## 🤝 Contributing

Contributions welcome! Areas for contribution:
- Additional attack scenarios
- New MITRE ATT&CK mappings
- Frontend enhancements
- Documentation improvements
- Bug fixes

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📜 License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- **CrowdStrike** - For the detection-container base image
- **MITRE ATT&CK** - For the comprehensive attack framework
- **Security Community** - For research and vulnerability disclosures

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/jachetti/vulnapp/issues)
- **Documentation:** [Complete Documentation](DOCKER_GUIDE.md)

---

## 🗺️ Version History

### v2.0.0 (2026)
- 🔥 **REAL EXPLOITATION MODE** - Scenarios perform actual attacks with authentic flags
- 🚩 **7 Teaching Scenarios** - Progressive learning path with 1,000 points
- 🔧 **Auto Setup/Cleanup** - Vulnerabilities planted and removed automatically
- ✨ Complete UI rewrite with React 18.3 + TypeScript
- 🏆 Progress tracking with flag submission and certification
- 📊 MITRE ATT&CK integration with visual badges
- 🔴 Real-time WebSocket streaming for live output
- 🐳 Multi-stage Docker build (Go + Node + Runtime)
- 📱 Responsive mobile design
- 🔧 Port 80 deployment for production readiness
- 📖 Comprehensive exploitation guide and documentation

### v1.0.0
- Initial release with basic attack scenarios
- Simple HTML interface
- Port 8080 deployment

---

**Built with ❤️ by CrowdStrike for the security community**

**⚠️ Remember: This is an intentionally vulnerable application for training purposes only. Use responsibly in controlled environments.**
