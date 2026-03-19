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
	Flag            string            `json:"flag,omitempty"`   // CTF flag for learning scenarios
	Points          int               `json:"points,omitempty"` // Points awarded when flag is captured
}

// MitreTechnique represents a MITRE ATT&CK technique
type MitreTechnique struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description,omitempty"`
}

// AllAttacks returns all 17 attack scenarios for CTF-style gamified learning
var AllAttacks = []AttackScenario{
	// ==========================================================================
	// PART 1: LEARNING SCENARIOS (7 scenarios, 500 points)
	// Progressive SE training path with CTF flags
	// ==========================================================================

	// Level 1: Fundamentals (100 points)
	{
		ID:          "learn-01-remote-shell",
		Name:        "Learning Scenario 1: Remote Access Shell",
		Category:    "Learning Scenarios",
		Description: "Containers are just processes - shells work the same way. Learn how reverse shells work in containers and why they trigger Falcon detections. Teaches: Same attack techniques, same detections.",
		ScriptPath:  "/bin/learning/01_Remote_Access_Shell.sh",
		MitreTactics: []string{"TA0002", "TA0011"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1059.004", Name: "Command and Scripting Interpreter: Unix Shell"},
			{ID: "T1071.001", Name: "Application Layer Protocol: Web Protocols"},
		},
		Severity: "HIGH",
		IsModern: false,
		Flag:     "FLAG{reverse_shell_works_same_in_containers}",
		Points:   50,
	},
	{
		ID:          "learn-02-process-discovery",
		Name:        "Learning Scenario 2: Process Discovery",
		Category:    "Learning Scenarios",
		Description: "Reconnaissance looks the same, but container boundaries matter. Learn how attackers enumerate their environment and discover container isolation limits. Teaches: Same commands, limited visibility.",
		ScriptPath:  "/bin/learning/02_Process_Discovery.sh",
		MitreTactics: []string{"TA0007"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1613", Name: "Container and Resource Discovery"},
			{ID: "T1082", Name: "System Information Discovery"},
		},
		Severity: "MEDIUM",
		IsModern: false,
		Flag:     "FLAG{discovered_container_boundaries_and_limits}",
		Points:   50,
	},

	// Level 2: Container Attacks (175 points)
	{
		ID:          "learn-03-data-collection",
		Name:        "Learning Scenario 3: Data Collection & Exfiltration",
		Category:    "Learning Scenarios",
		Description: "Understand the impact of data theft in containerized environments. Learn how attackers collect credentials, API keys, and sensitive data from containers. Teaches: Data theft techniques and exfiltration methods.",
		ScriptPath:  "/bin/learning/03_Data_Collection_Exfiltration.sh",
		MitreTactics: []string{"TA0009", "TA0010"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1005", Name: "Data from Local System"},
			{ID: "T1552.007", Name: "Unsecured Credentials: Container API"},
			{ID: "T1048.003", Name: "Exfiltration Over Alternative Protocol"},
		},
		Severity: "HIGH",
		IsModern: false,
		Flag:     "FLAG{credentials_stolen_data_staged_for_exfiltration}",
		Points:   75,
	},
	{
		ID:          "learn-04-container-escape",
		Name:        "Learning Scenario 4: Container Escape ⭐",
		Category:    "Learning Scenarios",
		Description: "THE KEY DIFFERENTIATOR: Containers are NOT VMs. Learn how attackers break out of container isolation to gain host access. This is what makes container security different from endpoint security. Teaches: Container escape techniques and why isolation matters.",
		ScriptPath:  "/bin/learning/04_Container_Escape.sh",
		MitreTactics: []string{"TA0004"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1611", Name: "Escape to Host"},
		},
		Severity: "CRITICAL",
		IsModern: true,
		Flag:     "FLAG{container_isolation_bypassed_welcome_to_host}",
		Points:   100,
	},

	// Level 3: Advanced Threats (225 points)
	{
		ID:          "learn-05-persistence",
		Name:        "Learning Scenario 5: Persistence Establishment",
		Category:    "Learning Scenarios",
		Description: "Learn how attackers maintain long-term access to compromised containers and hosts. Understand backdoor installation, scheduled tasks, and persistence mechanisms. Teaches: Persistence techniques across container restarts.",
		ScriptPath:  "/bin/learning/05_Persistence_Establishment.sh",
		MitreTactics: []string{"TA0003"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1053.003", Name: "Scheduled Task/Job: Cron"},
			{ID: "T1543.002", Name: "Create or Modify System Process: Systemd Service"},
		},
		Severity: "HIGH",
		IsModern: false,
		Flag:     "FLAG{backdoors_established_attacker_can_return_anytime}",
		Points:   75,
	},
	{
		ID:          "learn-07-defense-evasion",
		Name:        "Learning Scenario 7: Defense Evasion & Masquerading",
		Category:    "Learning Scenarios",
		Description: "Attackers disguise malicious processes to evade detection. Learn why behavior-based detection beats signature-based for containers. Teaches: Process masquerading and why Falcon's ML approach works.",
		ScriptPath:  "/bin/learning/07_Defense_Evasion_Masquerading.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1036", Name: "Masquerading"},
			{ID: "T1055", Name: "Process Injection"},
		},
		Severity: "MEDIUM",
		IsModern: false,
		Flag:     "FLAG{svchost_exe_on_linux_fooled_nobody}",
		Points:   50,
	},
	{
		ID:          "learn-06-full-attack-chain",
		Name:        "Learning Scenario 6: Full Attack Chain - MASTER LEVEL",
		Category:    "Learning Scenarios",
		Description: "Complete attack simulation from web vulnerability to cluster admin in 10 minutes. This master-level scenario combines all learned techniques into a realistic attack chain. Teaches: How attacks progress through multiple stages.",
		ScriptPath:  "/bin/learning/06_Full_Attack_Chain.sh",
		MitreTactics: []string{"TA0001", "TA0002", "TA0003", "TA0004", "TA0005", "TA0006", "TA0007", "TA0009", "TA0010", "TA0011"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1190", Name: "Exploit Public-Facing Application"},
			{ID: "T1059.004", Name: "Unix Shell"},
			{ID: "T1613", Name: "Container Discovery"},
			{ID: "T1552.007", Name: "Container API Credentials"},
			{ID: "T1611", Name: "Escape to Host"},
		},
		Severity: "CRITICAL",
		IsModern: true,
		Flag:     "FLAG{from_web_vuln_to_cluster_admin_in_10_minutes}",
		Points:   100,
	},

	// ==========================================================================
	// PART 2: DETECTION SCENARIOS (10 scenarios, 500 points)
	// Advanced scenarios showcasing Falcon detection capabilities
	// ==========================================================================

	// Category: Privilege Escalation (150 points)
	{
		ID:          "privileged-container-escape",
		Name:        "Privileged Container Escape",
		Category:    "Detection Scenarios",
		Description: "Demonstrates container escape from privileged mode using cgroup notify_on_release mechanism. Privileged containers have CAP_SYS_ADMIN and access to host devices, enabling kernel-level escapes.",
		ScriptPath:  "/bin/modern/Privileged_Container_Escape.sh",
		MitreTactics: []string{"TA0004"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1611", Name: "Escape to Host"},
			{ID: "T1068", Name: "Exploitation for Privilege Escalation"},
		},
		Severity:      "CRITICAL",
		IsModern:      true,
		Prerequisites: []string{"Container running with --privileged flag"},
		Flag:          "FLAG{privileged_mode_equals_root_on_host}",
		Points:        75,
	},
	{
		ID:          "docker-socket-exploitation",
		Name:        "Docker Socket Exploitation",
		Category:    "Detection Scenarios",
		Description: "Exploits mounted /var/run/docker.sock to gain full host root access. The Docker socket is the most dangerous misconfig - it's like giving the keys to the entire infrastructure.",
		ScriptPath:  "/bin/modern/Docker_Socket_Exploitation.sh",
		MitreTactics: []string{"TA0004"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1611", Name: "Escape to Host"},
		},
		Severity:      "CRITICAL",
		IsModern:      true,
		Prerequisites: []string{"Docker socket mounted at /var/run/docker.sock"},
		Flag:          "FLAG{docker_socket_is_the_keys_to_the_kingdom}",
		Points:        75,
	},

	// Category: Defense Evasion (100 points)
	{
		ID:          "defense-evasion-masquerading",
		Name:        "Binary Masquerading",
		Category:    "Detection Scenarios",
		Description: "Demonstrates process masquerading by disguising malicious processes as legitimate system processes. Tests Falcon's behavioral detection capabilities.",
		ScriptPath:  "/bin/existing/Defense_Evasion_via_Masquerading.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1036", Name: "Masquerading"},
		},
		Severity: "MEDIUM",
		IsModern: false,
		Flag:     "FLAG{fake_extensions_cant_hide_from_falcon}",
		Points:   50,
	},
	{
		ID:          "defense-evasion-rootkit",
		Name:        "Rootkit Installation",
		Category:    "Detection Scenarios",
		Description: "Demonstrates rootkit installation to hide malicious processes and files. Tests Falcon's ability to detect kernel-level tampering attempts.",
		ScriptPath:  "/bin/existing/Defense_Evasion_via_Rootkit.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1014", Name: "Rootkit"},
		},
		Severity: "HIGH",
		IsModern: false,
		Flag:     "FLAG{rootkit_detected_before_kernel_compromise}",
		Points:   50,
	},

	// Category: Command & Control (100 points)
	{
		ID:          "command-control-remote-access",
		Name:        "C2 Remote Access",
		Category:    "Detection Scenarios",
		Description: "Establishes a command and control channel for remote access. Tests Falcon's threat intelligence integration and C2 beacon detection.",
		ScriptPath:  "/bin/existing/Command_Control_via_Remote_Access.sh",
		MitreTactics: []string{"TA0011"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1071.001", Name: "Application Layer Protocol: Web Protocols"},
		},
		Severity: "CRITICAL",
		IsModern: false,
		Flag:     "FLAG{c2_beacon_caught_by_threat_intelligence}",
		Points:   50,
	},
	{
		ID:          "reverse-shell-trojan",
		Name:        "Reverse Shell Trojan",
		Category:    "Detection Scenarios",
		Description: "Establishes a reverse shell trojan for persistent remote access. Tests Falcon's ability to detect various reverse shell methods (bash, netcat, python, perl).",
		ScriptPath:  "/bin/existing/Reverse_Shell_Trojan.sh",
		MitreTactics: []string{"TA0011"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1059.004", Name: "Unix Shell"},
		},
		Severity: "CRITICAL",
		IsModern: false,
		Flag:     "FLAG{netcat_listener_detected_instantly}",
		Points:   50,
	},

	// Category: Impact & Detection (100 points)
	{
		ID:          "container-drift-file-creation",
		Name:        "Container Drift Detection",
		Category:    "Detection Scenarios",
		Description: "Demonstrates container drift by creating and executing files not in the original image. Tests Falcon's runtime integrity monitoring and drift detection.",
		ScriptPath:  "/bin/existing/ContainerDrift_Via_File_Creation_and_Execution.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1612", Name: "Build Image on Host"},
		},
		Severity: "HIGH",
		IsModern: false,
		Flag:     "FLAG{runtime_changes_trigger_drift_alert}",
		Points:   50,
	},
	{
		ID:          "credential-access-dumping",
		Name:        "Credential Dumping",
		Category:    "Detection Scenarios",
		Description: "Attempts to dump credentials from memory and files within the container. Tests Falcon's credential theft detection capabilities.",
		ScriptPath:  "/bin/existing/Credential_Access_via_Credential_Dumping.sh",
		MitreTactics: []string{"TA0006"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1552.001", Name: "Unsecured Credentials: Credentials In Files"},
			{ID: "T1552.007", Name: "Unsecured Credentials: Container API"},
		},
		Severity: "HIGH",
		IsModern: false,
		Flag:     "FLAG{memory_credentials_extracted_and_detected}",
		Points:   50,
	},

	// Category: Multi-Stage Attacks (100 points)
	{
		ID:          "chain-full-breach",
		Name:        "Full Breach Simulation",
		Category:    "Detection Scenarios",
		Description: "Complete attack chain simulating real-world container breach with 10-15 detection points. Tests Falcon's ability to track and detect complex multi-stage attacks.",
		ScriptPath:  "/bin/chains/Full_Breach_Simulation.sh",
		MitreTactics: []string{"TA0001", "TA0002", "TA0003", "TA0004", "TA0005", "TA0006", "TA0007", "TA0009", "TA0010", "TA0011"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1190", Name: "Exploit Public-Facing Application"},
			{ID: "T1059.004", Name: "Unix Shell"},
			{ID: "T1613", Name: "Container Discovery"},
			{ID: "T1552", Name: "Unsecured Credentials"},
			{ID: "T1071.001", Name: "Web Protocols"},
		},
		Severity: "CRITICAL",
		IsModern: true,
		Flag:     "FLAG{complete_breach_chain_stopped_by_falcon}",
		Points:   50,
	},
	{
		ID:          "chain-enumeration-exfil",
		Name:        "Enumeration & Exfiltration Chain",
		Category:    "Detection Scenarios",
		Description: "Downloads enumeration tools, executes them, collects data, and attempts exfiltration. Tests Falcon's tool download detection, data collection detection, and exfiltration blocking.",
		ScriptPath:  "/bin/chains/Enumeration_And_Exfiltration.sh",
		MitreTactics: []string{"TA0007", "TA0009", "TA0010"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1082", Name: "System Information Discovery"},
			{ID: "T1005", Name: "Data from Local System"},
			{ID: "T1048", Name: "Exfiltration Over Alternative Protocol"},
		},
		Severity: "HIGH",
		IsModern: true,
		Flag:     "FLAG{data_exfiltration_blocked_before_loss}",
		Points:   50,
	},
}

// GetAttackByID returns an attack scenario by its ID
func GetAttackByID(id string) *AttackScenario {
	for i := range AllAttacks {
		if AllAttacks[i].ID == id {
			return &AllAttacks[i]
		}
	}
	return nil
}

// GetAttacksByCategory returns all attacks in a specific category
func GetAttacksByCategory(category string) []AttackScenario {
	var attacks []AttackScenario
	for _, attack := range AllAttacks {
		if attack.Category == category {
			attacks = append(attacks, attack)
		}
	}
	return attacks
}

// GetAllCategories returns all unique categories
func GetAllCategories() []string {
	categories := make(map[string]bool)
	for _, attack := range AllAttacks {
		categories[attack.Category] = true
	}

	result := make([]string, 0, len(categories))
	for category := range categories {
		result = append(result, category)
	}
	return result
}

// GetTotalPoints returns the sum of all points available
func GetTotalPoints() int {
	total := 0
	for _, attack := range AllAttacks {
		total += attack.Points
	}
	return total
}

// GetScenarioCount returns the total number of scenarios
func GetScenarioCount() int {
	return len(AllAttacks)
}
