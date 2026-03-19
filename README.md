# VulnApp v2.0 🦅

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Docker Repository on Quay](https://quay.io/repository/crowdstrike/vulnapp/status)](https://quay.io/repository/crowdstrike/vulnapp)
[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8.svg)](go.mod)
[![React](https://img.shields.io/badge/React-18.3-61DAFB.svg)](frontend/package.json)

**An intentionally vulnerable container application for testing CrowdStrike Falcon sensor detection capabilities.**

VulnApp v2.0 is a modern, interactive web platform that demonstrates **24 container security attack scenarios** mapped to the MITRE ATT&CK framework. Perfect for security training, Falcon sensor validation, and container security research.

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

- ✨ **Modern React UI** - Interactive web interface with real-time execution
- 🎓 **6 Learning Scenarios** - Progressive CTF-style training for SE education (1,000 points)
- 🚀 **24 Attack Scenarios** - 12 classic + 12 modern container threats (2024-2026)
- 📊 **MITRE ATT&CK Integration** - Visual technique mappings and badges
- 🔴 **WebSocket Streaming** - Live attack output in terminal-style display
- 🎯 **Interactive Scenarios** - Reverse shell forms for LAN testing
- 🏆 **Progress Tracking** - CTF flag submission with points and certification
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

**Kubernetes**
```bash
kubectl apply -f https://raw.githubusercontent.com/jachetti/vulnapp/main/vulnerable.example.yaml
kubectl get service vulnapp
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

### 🎓 Learning Scenarios (SE Training Mode)

**6 Progressive Scenarios for Office Hours Training:**

Perfect for CrowdStrike endpoint SEs learning container security. Each scenario bridges familiar endpoint security concepts to container-specific attacks with CTF-style flags and business impact examples.

**Total: 1,000 Points**

| Scenario | Points | Duration | Flag |
|----------|--------|----------|------|
| 1. Remote Access Shell | 50 | 5 min | Containers are processes |
| 2. Process Discovery | 50 | 5 min | Namespace isolation |
| 3. Data Collection & Exfiltration | 100 | 7 min | $147M breach simulation |
| 4. Container Escape ⭐ | 150 | 7 min | THE key differentiator |
| 5. Persistence Establishment | 200 | 8 min | Long-term threats & dwell time |
| 6. Full Attack Chain | 450 | 10 min | Complete breach timeline |

**Features:**
- 🚩 CTF flag submission with point tracking
- 📊 Progress tracking (X/1000 points, X/6 scenarios)
- 💼 Business impact metrics ($4.5M average breach cost)
- 🗣️ SE talking points for customer conversations
- 🎯 Falcon detection explanations in plain English
- 🏆 Certification badge at 1,000 points

**Perfect for:**
- SE office hours training (60 minutes total)
- Customer demos and workshops
- POC validation scenarios
- Team onboarding

See [bin/learning/README.md](bin/learning/README.md) for complete facilitator guide.

### 24 Attack Scenarios

**Existing Attacks (12):**
- Defense Evasion via Rootkit (T1014)
- Defense Evasion via Masquerading (T1036)
- Exfiltration via Alternative Protocol (T1048.003)
- Command & Control via Remote Access (T1071.001)
- Command & Control (Obfuscated) (T1027, T1071.001)
- Credential Access via Dumping (T1552.001)
- Collection via Automated Collection (T1005)
- Execution via Command-Line Interface (T1059.004)
- Reverse Shell Trojan (T1071.001)
- Container Drift via File Creation (T1612)
- Linux Trojan - Local Execution (T1496)
- Linux Trojan - Remote Download (T1496, T1195)

**Modern Container Threats (12) - NEW:**
- **Docker Socket Exploitation** (T1611) - Escape via mounted socket
- **Privileged Container Escape** (T1611) - Cgroup notify_on_release exploit
- **CAP_SYS_ADMIN Abuse** (T1611) - Mount operations for escape
- **CAP_SYS_PTRACE Injection** (T1055) - Process injection attacks
- **CAP_DAC_READ_SEARCH Bypass** (T1222) - File permission bypass
- **HostPath Volume Backdoor** (T1053.003) - Persistent host backdoors
- **Service Account Token Theft** (T1552.007) - Kubernetes token extraction
- **DaemonSet Persistence** (T1525) - Cluster-wide persistence
- **Namespace Escape via nsenter** (T1611) - Break out of namespaces
- **Seccomp Profile Bypass** (T1562.001) - Security control bypass
- **Image Supply Chain Poisoning** (T1525, T1195.002) - Registry compromise
- **CVE-2019-5736 runc Escape** (T1611, T1068) - Critical CVE demonstration

### API & Integration
- **8 REST endpoints** - Attack management and execution
- **WebSocket streaming** - Real-time output
- **4 vulnerable endpoints** - Interactive training (RCE, LFI, Reverse Shell, SQLi)
- **Health checks** - Container readiness monitoring
- **JSON responses** - Easy integration

---

## 📖 Documentation

- **[Learning Scenarios Guide](bin/learning/README.md)** - SE training scenarios and facilitator guide
- **[Test Guide](TEST_GUIDE.md)** - Complete testing checklist for v2.0 features
- **[Scenario Recommendations](SCENARIO_RECOMMENDATIONS.md)** - Analysis of scenario structure
- **[Docker Guide](DOCKER_GUIDE.md)** - Comprehensive Docker documentation
- **[Frontend README](frontend/README.md)** - React development guide
- **[Implementation Complete](IMPLEMENTATION_COMPLETE.md)** - Full feature list
- **[Test Report](TEST_REPORT.md)** - Testing results (41/41 passed)

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

### Example 1: Learning Mode (SE Training)

**Perfect for office hours and team training:**

1. Open web interface: `http://localhost`
2. Click "Learning Scenarios (6)" tab
3. Start with Scenario 1: Remote Access Shell
4. Watch enhanced terminal output with stage headers
5. Find the CTF flag in the output (e.g., `FLAG{reverse_shell_works_same_in_containers}`)
6. Submit the flag to earn 50 points
7. Progress to next scenario
8. Collect all 6 flags to earn 1,000 points and certification! 🏆

**Session time:** ~45 minutes for all 6 scenarios

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

### v2.0.0 (2024)
- ✨ Complete UI rewrite with React 18.3 + TypeScript
- 🎓 6 progressive learning scenarios for SE training (CTF-style with 1,000 points)
- 🏆 Progress tracking with flag submission and certification
- 🚀 12 new modern container threat scenarios
- 📊 MITRE ATT&CK integration
- 🔴 Real-time WebSocket streaming
- 🎯 Interactive LAN testing features
- 🐳 Multi-stage Docker build
- 📱 Responsive mobile design
- 🔧 Port 80 deployment
- 📖 Comprehensive documentation

### v1.0.0
- Initial release with basic attack scenarios
- Simple HTML interface
- Port 8080 deployment

---

**Built with ❤️ by CrowdStrike for the security community**

**⚠️ Remember: This is an intentionally vulnerable application for training purposes only. Use responsibly in controlled environments.**
