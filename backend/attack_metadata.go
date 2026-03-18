package backend

// AttackScenario represents a single attack scenario with MITRE ATT&CK mappings
type AttackScenario struct {
	ID              string            `json:"id"`
	Name            string            `json:"name"`
	Category        string            `json:"category"` // MITRE Tactic
	Description     string            `json:"description"`
	ScriptPath      string            `json:"script_path"`
	MitreTactics    []string          `json:"mitre_tactics"`
	MitreTechniques []MitreTechnique  `json:"mitre_techniques"`
	Severity        string            `json:"severity"` // CRITICAL, HIGH, MEDIUM, LOW
	IsModern        bool              `json:"is_modern"`
	CVE             []string          `json:"cve,omitempty"`
	Prerequisites   []string          `json:"prerequisites,omitempty"`
}

// MitreTechnique represents a MITRE ATT&CK technique
type MitreTechnique struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description,omitempty"`
}

// AllAttacks returns all attack scenarios
var AllAttacks = []AttackScenario{
	// ========== EXISTING ATTACKS ==========
	{
		ID:          "defense-evasion-rootkit",
		Name:        "Defense Evasion via Rootkit",
		Category:    "Defense Evasion",
		Description: "Demonstrates rootkit installation to hide malicious processes and files from detection.",
		ScriptPath:  "/bin/existing/Defense_Evasion_via_Rootkit.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1014", Name: "Rootkit", Description: "Hide malicious code through kernel-level modifications"},
		},
		Severity: "HIGH",
		IsModern: false,
	},
	{
		ID:          "defense-evasion-masquerading",
		Name:        "Defense Evasion via Masquerading",
		Category:    "Defense Evasion",
		Description: "Demonstrates process masquerading by disguising malicious processes as legitimate system processes.",
		ScriptPath:  "/bin/existing/Defense_Evasion_via_Masquerading.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1036", Name: "Masquerading", Description: "Manipulate features to make malware appear legitimate"},
		},
		Severity: "MEDIUM",
		IsModern: false,
	},
	{
		ID:          "exfiltration-alternative-protocol",
		Name:        "Exfiltration via Alternative Protocol",
		Category:    "Exfiltration",
		Description: "Demonstrates data exfiltration using DNS tunneling to bypass network controls.",
		ScriptPath:  "/bin/existing/Exfiltration_via_Exfiltration_Over_Alternative_Protocol.sh",
		MitreTactics: []string{"TA0010"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1048.003", Name: "Exfiltration Over Alternative Protocol", Description: "Use non-C2 protocols for data exfiltration"},
		},
		Severity: "HIGH",
		IsModern: false,
	},
	{
		ID:          "command-control-remote-access",
		Name:        "Command & Control via Remote Access",
		Category:    "Command and Control",
		Description: "Establishes a command and control channel for remote access to the container.",
		ScriptPath:  "/bin/existing/Command_Control_via_Remote_Access.sh",
		MitreTactics: []string{"TA0011"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1071.001", Name: "Application Layer Protocol: Web Protocols", Description: "Use web protocols for C2"},
		},
		Severity: "CRITICAL",
		IsModern: false,
	},
	{
		ID:          "command-control-obfuscated",
		Name:        "Command & Control via Obfuscated Channel",
		Category:    "Command and Control",
		Description: "Establishes an obfuscated C2 channel using encoding to evade detection.",
		ScriptPath:  "/bin/existing/Command_Control_via_Remote_Access-obfuscated.sh",
		MitreTactics: []string{"TA0011"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1027", Name: "Obfuscated Files or Information", Description: "Make files or information difficult to detect"},
			{ID: "T1071.001", Name: "Application Layer Protocol: Web Protocols"},
		},
		Severity: "CRITICAL",
		IsModern: false,
	},
	{
		ID:          "credential-access-dumping",
		Name:        "Credential Access via Credential Dumping",
		Category:    "Credential Access",
		Description: "Attempts to dump credentials from memory and files within the container.",
		ScriptPath:  "/bin/existing/Credential_Access_via_Credential_Dumping.sh",
		MitreTactics: []string{"TA0006"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1552.001", Name: "Unsecured Credentials: Credentials In Files", Description: "Search for credentials in files"},
		},
		Severity: "HIGH",
		IsModern: false,
	},
	{
		ID:          "collection-automated",
		Name:        "Collection via Automated Collection",
		Category:    "Collection",
		Description: "Automatically collects sensitive data from the container filesystem.",
		ScriptPath:  "/bin/existing/Collection_via_Automated_Collection.sh",
		MitreTactics: []string{"TA0009"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1005", Name: "Data from Local System", Description: "Collect data from local system"},
		},
		Severity: "MEDIUM",
		IsModern: false,
	},
	{
		ID:          "execution-cli",
		Name:        "Execution via Command-Line Interface",
		Category:    "Execution",
		Description: "Executes malicious commands via the command-line interface within the container.",
		ScriptPath:  "/bin/existing/Execution_via_Command-Line_Interface.sh",
		MitreTactics: []string{"TA0002"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1059.004", Name: "Command and Scripting Interpreter: Unix Shell", Description: "Execute commands via Unix shell"},
		},
		Severity: "MEDIUM",
		IsModern: false,
	},
	{
		ID:          "reverse-shell-trojan",
		Name:        "Reverse Shell Trojan",
		Category:    "Command and Control",
		Description: "Establishes a reverse shell trojan for persistent remote access.",
		ScriptPath:  "/bin/existing/Reverse_Shell_Trojan.sh",
		MitreTactics: []string{"TA0011"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1071.001", Name: "Application Layer Protocol: Web Protocols"},
		},
		Severity: "CRITICAL",
		IsModern: false,
	},
	{
		ID:          "container-drift-file-creation",
		Name:        "Container Drift via File Creation",
		Category:    "Defense Evasion",
		Description: "Demonstrates container drift by creating and executing files not present in the original image.",
		ScriptPath:  "/bin/existing/ContainerDrift_Via_File_Creation_and_Execution.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1612", Name: "Build Image on Host", Description: "Modify container image on host"},
		},
		Severity: "HIGH",
		IsModern: false,
	},
	{
		ID:          "malware-linux-trojan-local",
		Name:        "Linux Trojan - Local Execution",
		Category:    "Impact",
		Description: "Executes a Linux trojan from a local file to demonstrate malware detection.",
		ScriptPath:  "/bin/existing/Malware_Linux_Trojan_Local.sh",
		MitreTactics: []string{"TA0040"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1496", Name: "Resource Hijacking", Description: "Use system resources for malicious purposes"},
		},
		Severity: "CRITICAL",
		IsModern: false,
	},
	{
		ID:          "malware-linux-trojan-remote",
		Name:        "Linux Trojan - Remote Download",
		Category:    "Impact",
		Description: "Downloads and executes a Linux trojan from a remote source to demonstrate supply chain attack.",
		ScriptPath:  "/bin/existing/Malware_Linux_Trojan_Remote.sh",
		MitreTactics: []string{"TA0040", "TA0001"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1496", Name: "Resource Hijacking"},
			{ID: "T1195", Name: "Supply Chain Compromise", Description: "Manipulate software supply chain"},
		},
		Severity: "CRITICAL",
		IsModern: false,
	},

	// ========== MODERN THREATS (2024-2026) ==========
	{
		ID:          "docker-socket-exploitation",
		Name:        "Docker Socket Exploitation",
		Category:    "Privilege Escalation",
		Description: "Exploits mounted /var/run/docker.sock to gain host root access by spawning privileged containers.",
		ScriptPath:  "/bin/modern/Docker_Socket_Exploitation.sh",
		MitreTactics: []string{"TA0004"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1611", Name: "Escape to Host", Description: "Break out of a container to gain host access"},
		},
		Severity:      "CRITICAL",
		IsModern:      true,
		Prerequisites: []string{"Docker socket must be mounted at /var/run/docker.sock"},
	},
	{
		ID:          "privileged-container-escape",
		Name:        "Privileged Container Escape",
		Category:    "Privilege Escalation",
		Description: "Demonstrates container escape from privileged mode using cgroup notify_on_release mechanism.",
		ScriptPath:  "/bin/modern/Privileged_Container_Escape.sh",
		MitreTactics: []string{"TA0004"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1611", Name: "Escape to Host"},
		},
		Severity:      "CRITICAL",
		IsModern:      true,
		Prerequisites: []string{"Container must be running in privileged mode"},
	},
	{
		ID:          "cap-sys-admin-abuse",
		Name:        "CAP_SYS_ADMIN Capability Abuse",
		Category:    "Privilege Escalation",
		Description: "Exploits CAP_SYS_ADMIN capability to perform mount operations and escape container.",
		ScriptPath:  "/bin/modern/CAP_SYS_ADMIN_Abuse.sh",
		MitreTactics: []string{"TA0004"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1611", Name: "Escape to Host"},
		},
		Severity:      "HIGH",
		IsModern:      true,
		Prerequisites: []string{"Container must have CAP_SYS_ADMIN capability"},
	},
	{
		ID:          "cap-sys-ptrace-injection",
		Name:        "CAP_SYS_PTRACE Process Injection",
		Category:    "Privilege Escalation",
		Description: "Uses CAP_SYS_PTRACE capability to inject malicious code into host processes.",
		ScriptPath:  "/bin/modern/CAP_SYS_PTRACE_Injection.sh",
		MitreTactics: []string{"TA0004", "TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1055", Name: "Process Injection", Description: "Inject code into processes"},
		},
		Severity:      "HIGH",
		IsModern:      true,
		Prerequisites: []string{"Container must have CAP_SYS_PTRACE capability"},
	},
	{
		ID:          "cap-dac-read-search-bypass",
		Name:        "CAP_DAC_READ_SEARCH File Access Bypass",
		Category:    "Defense Evasion",
		Description: "Uses CAP_DAC_READ_SEARCH to bypass file permissions and access sensitive host files.",
		ScriptPath:  "/bin/modern/CAP_DAC_READ_SEARCH_Bypass.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1222", Name: "File and Directory Permissions Modification"},
		},
		Severity:      "MEDIUM",
		IsModern:      true,
		Prerequisites: []string{"Container must have CAP_DAC_READ_SEARCH capability"},
	},
	{
		ID:          "hostpath-volume-backdoor",
		Name:        "HostPath Volume Backdoor",
		Category:    "Persistence",
		Description: "Exploits HostPath volume mounts to install persistent backdoors on the host filesystem.",
		ScriptPath:  "/bin/modern/HostPath_Volume_Backdoor.sh",
		MitreTactics: []string{"TA0003"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1053.003", Name: "Scheduled Task/Job: Cron", Description: "Schedule tasks via cron"},
		},
		Severity:      "CRITICAL",
		IsModern:      true,
		Prerequisites: []string{"HostPath volume must be mounted"},
	},
	{
		ID:          "service-account-token-theft",
		Name:        "Kubernetes Service Account Token Theft",
		Category:    "Credential Access",
		Description: "Steals Kubernetes service account tokens to authenticate to the Kubernetes API server.",
		ScriptPath:  "/bin/modern/Service_Account_Token_Theft.sh",
		MitreTactics: []string{"TA0006"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1552.007", Name: "Unsecured Credentials: Container API", Description: "Access container API credentials"},
		},
		Severity: "CRITICAL",
		IsModern: true,
	},
	{
		ID:          "daemonset-persistence",
		Name:        "Malicious DaemonSet Deployment",
		Category:    "Persistence",
		Description: "Deploys a malicious DaemonSet to ensure persistence across all cluster nodes.",
		ScriptPath:  "/bin/modern/DaemonSet_Persistence.sh",
		MitreTactics: []string{"TA0003"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1525", Name: "Implant Internal Image", Description: "Deploy malicious container images"},
		},
		Severity:      "CRITICAL",
		IsModern:      true,
		Prerequisites: []string{"Kubernetes API access with DaemonSet creation permissions"},
	},
	{
		ID:          "namespace-escape-nsenter",
		Name:        "Namespace Escape via nsenter",
		Category:    "Privilege Escalation",
		Description: "Uses nsenter to break out of container namespaces and access host namespaces.",
		ScriptPath:  "/bin/modern/Namespace_Escape_nsenter.sh",
		MitreTactics: []string{"TA0004"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1611", Name: "Escape to Host"},
		},
		Severity:      "HIGH",
		IsModern:      true,
		Prerequisites: []string{"nsenter must be available, host PID namespace access"},
	},
	{
		ID:          "seccomp-profile-bypass",
		Name:        "Seccomp Profile Bypass",
		Category:    "Defense Evasion",
		Description: "Attempts to bypass or disable seccomp security profiles to execute restricted syscalls.",
		ScriptPath:  "/bin/modern/Seccomp_Profile_Bypass.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1562.001", Name: "Impair Defenses: Disable or Modify Tools", Description: "Disable security tools"},
		},
		Severity: "MEDIUM",
		IsModern: true,
	},
	{
		ID:          "image-supply-chain-poison",
		Name:        "Container Image Supply Chain Poisoning",
		Category:    "Persistence",
		Description: "Demonstrates poisoning container images in the registry to maintain persistence.",
		ScriptPath:  "/bin/modern/Image_Supply_Chain_Poison.sh",
		MitreTactics: []string{"TA0003", "TA0001"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1525", Name: "Implant Internal Image"},
			{ID: "T1195.002", Name: "Supply Chain Compromise: Compromise Software Supply Chain"},
		},
		Severity:      "CRITICAL",
		IsModern:      true,
		Prerequisites: []string{"Container registry access"},
	},
	{
		ID:          "cve-2019-5736-runc",
		Name:        "CVE-2019-5736 runc Container Escape",
		Category:    "Privilege Escalation",
		Description: "Demonstrates the CVE-2019-5736 vulnerability that allows overwriting the host runc binary.",
		ScriptPath:  "/bin/modern/CVE_2019_5736_runc_Escape.sh",
		MitreTactics: []string{"TA0004"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1611", Name: "Escape to Host"},
			{ID: "T1068", Name: "Exploitation for Privilege Escalation"},
		},
		Severity: "CRITICAL",
		IsModern: true,
		CVE:      []string{"CVE-2019-5736"},
	},

	// ========== ATTACK CHAINS (Detection-Optimized Multi-Stage Attacks) ==========
	{
		ID:          "chain-full-breach",
		Name:        "🔥 Full Breach Simulation",
		Category:    "Attack Chains",
		Description: "Complete multi-stage attack chain: Initial Access → Discovery → Credential Access → C2 Communication. Designed to generate 10-15 Falcon detections with strong process relationships. Includes guaranteed test triggers and proven detection patterns.",
		ScriptPath:  "/bin/chains/Full_Breach_Simulation.sh",
		MitreTactics: []string{"TA0001", "TA0007", "TA0006", "TA0011"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1190", Name: "Exploit Public-Facing Application"},
			{ID: "T1082", Name: "System Information Discovery"},
			{ID: "T1552", Name: "Unsecured Credentials"},
			{ID: "T1071.001", Name: "Application Layer Protocol: Web Protocols"},
		},
		Severity:      "CRITICAL",
		IsModern:      true,
		Prerequisites: []string{"Execute after establishing reverse shell for maximum detections"},
	},
	{
		ID:          "chain-enumeration-exfil",
		Name:        "📊 Enumeration & Exfiltration Chain",
		Category:    "Attack Chains",
		Description: "Multi-stage enumeration and data exfiltration: Tool Download → Execution → Data Collection → C2 Beacon. Downloads enumeration tools (LinPEAS, LSE, mimipenguin), executes them, collects sensitive data, and attempts exfiltration. Generates 8-12 detections.",
		ScriptPath:  "/bin/chains/Enumeration_And_Exfiltration.sh",
		MitreTactics: []string{"TA0007", "TA0009", "TA0010", "TA0011"},
		MitreTechnique: []MitreTechnique{
			{ID: "T1005", Name: "Data from Local System"},
			{ID: "T1083", Name: "File and Directory Discovery"},
			{ID: "T1552.001", Name: "Unsecured Credentials: Credentials In Files"},
			{ID: "T1048", Name: "Exfiltration Over Alternative Protocol"},
		},
		Severity:      "HIGH",
		IsModern:      true,
		Prerequisites: []string{"None - can run standalone"},
	},
	{
		ID:          "chain-container-breakout",
		Name:        "🚪 Container Breakout Chain",
		Category:    "Attack Chains",
		Description: "Container escape attempts and post-escape reconnaissance: Capability Analysis → Escape Attempts (chroot, nsenter, Docker socket) → Host Recon → K8s API Access. Tests multiple escape vectors and generates 5-8 detections.",
		ScriptPath:  "/bin/chains/Container_Breakout.sh",
		MitreTactics: []string{"TA0004"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1611", Name: "Escape to Host"},
			{ID: "T1610", Name: "Deploy Container"},
			{ID: "T1552.007", Name: "Unsecured Credentials: Container API"},
		},
		Severity:      "CRITICAL",
		IsModern:      true,
		Prerequisites: []string{"Works best with --privileged, mounted Docker socket, or dangerous capabilities"},
	},
	{
		ID:          "chain-persistence",
		Name:        "⚓ Persistence Establishment Chain",
		Category:    "Attack Chains",
		Description: "Multiple persistence mechanisms: Binary Masquerading → Hidden Backdoors → Cron Jobs → Web Shells → SSH Keys. Implements 8 different persistence techniques and generates 6-10 detections. Based on proven attack patterns.",
		ScriptPath:  "/bin/chains/Persistence_Establishment.sh",
		MitreTactics: []string{"TA0003", "TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1053.003", Name: "Scheduled Task/Job: Cron"},
			{ID: "T1136", Name: "Create Account"},
			{ID: "T1505.003", Name: "Server Software Component: Web Shell"},
			{ID: "T1574.006", Name: "Hijack Execution Flow: LD_PRELOAD"},
		},
		Severity:      "HIGH",
		IsModern:      true,
		Prerequisites: []string{"Execute after initial access for realistic scenario"},
	},
}

// GetAttackByID returns an attack by its ID
func GetAttackByID(id string) *AttackScenario {
	for i := range AllAttacks {
		if AllAttacks[i].ID == id {
			return &AllAttacks[i]
		}
	}
	return nil
}

// GetAttacksByCategory returns attacks grouped by category
func GetAttacksByCategory() map[string][]AttackScenario {
	categories := make(map[string][]AttackScenario)
	for _, attack := range AllAttacks {
		categories[attack.Category] = append(categories[attack.Category], attack)
	}
	return categories
}
