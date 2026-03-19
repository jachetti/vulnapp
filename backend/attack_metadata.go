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

// AllAttacks returns all 7 teaching scenarios for POC (1,000 points total)
var AllAttacks = []AttackScenario{
	// ==========================================================================
	// 7 TEACHING SCENARIOS - POC Edition
	// Progressive SE training path with CTF flags
	// Total: 1,000 points
	// ==========================================================================

	// Scenario 1
	{
		ID:          "learn-01-remote-shell",
		Name:        "Remote Access Shell",
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
		Points:   100,
	},

	// Scenario 2
	{
		ID:          "learn-02-process-discovery",
		Name:        "Process Discovery",
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
		Points:   150,
	},

	// Scenario 3
	{
		ID:          "learn-03-data-collection",
		Name:        "Data Theft & Exfiltration",
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
		Points:   150,
	},

	// Scenario 4
	{
		ID:          "learn-04-container-escape",
		Name:        "Container Escape ⭐",
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
		Points:   200,
	},

	// Scenario 5
	{
		ID:          "learn-05-persistence",
		Name:        "Persistence Establishment",
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
		Points:   150,
	},

	// Scenario 6
	{
		ID:          "learn-06-defense-evasion",
		Name:        "Defense Evasion & Masquerading",
		Category:    "Learning Scenarios",
		Description: "Attackers disguise malicious processes to evade detection. Learn why behavior-based detection beats signature-based for containers. Teaches: Process masquerading and why Falcon's ML approach works.",
		ScriptPath:  "/bin/learning/06_Defense_Evasion_Masquerading.sh",
		MitreTactics: []string{"TA0005"},
		MitreTechniques: []MitreTechnique{
			{ID: "T1036", Name: "Masquerading"},
			{ID: "T1055", Name: "Process Injection"},
		},
		Severity: "MEDIUM",
		IsModern: false,
		Flag:     "FLAG{svchost_exe_on_linux_fooled_nobody}",
		Points:   100,
	},

	// Scenario 7
	{
		ID:          "learn-07-full-attack-chain",
		Name:        "Full Attack Chain - MASTER LEVEL",
		Category:    "Learning Scenarios",
		Description: "Complete attack simulation from web vulnerability to cluster admin in 10 minutes. This master-level scenario combines all learned techniques into a realistic attack chain. Teaches: How attacks progress through multiple stages.",
		ScriptPath:  "/bin/learning/07_Full_Attack_Chain.sh",
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
		Points:   150,
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
