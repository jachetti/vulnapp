package backend

import (
	"bufio"
	"bytes"
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"time"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true // Allow all origins for simplicity
	},
}

// WebSocketHandler handles WebSocket connections for real-time attack output streaming
type WebSocketHandler struct {
	tracker *ExecutionTracker
}

// NewWebSocketHandler creates a new WebSocket handler
func NewWebSocketHandler(tracker *ExecutionTracker) *WebSocketHandler {
	return &WebSocketHandler{
		tracker: tracker,
	}
}

// HandleExecutionStream handles WebSocket connections for streaming execution output
func (h *WebSocketHandler) HandleExecutionStream(w http.ResponseWriter, r *http.Request) {
	// Upgrade HTTP connection to WebSocket
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Printf("WebSocket upgrade error: %v", err)
		return
	}
	defer conn.Close()

	// Get execution ID from query parameter
	executionID := r.URL.Query().Get("execution_id")
	if executionID == "" {
		conn.WriteJSON(map[string]string{"error": "execution_id parameter required"})
		return
	}

	execution := h.tracker.GetExecution(executionID)
	if execution == nil {
		conn.WriteJSON(map[string]string{"error": "execution not found"})
		return
	}

	// Send initial status
	conn.WriteJSON(map[string]interface{}{
		"type":   "status",
		"status": execution.Status,
	})

	// Stream existing output if any
	execution.mu.RLock()
	existingOutput := execution.Output
	execution.mu.RUnlock()

	if existingOutput != "" {
		conn.WriteJSON(map[string]interface{}{
			"type":   "output",
			"line":   existingOutput,
		})
	}

	// Poll for updates until execution completes
	ticker := time.NewTicker(100 * time.Millisecond)
	defer ticker.Stop()

	lastLength := len(existingOutput)

	for {
		select {
		case <-ticker.C:
			execution.mu.RLock()
			currentOutput := execution.Output
			currentStatus := execution.Status
			execution.mu.RUnlock()

			// Send new output if any
			if len(currentOutput) > lastLength {
				newOutput := currentOutput[lastLength:]
				conn.WriteJSON(map[string]interface{}{
					"type": "output",
					"line": newOutput,
				})
				lastLength = len(currentOutput)
			}

			// Check if execution completed
			if currentStatus != ExecutionStatusRunning {
				conn.WriteJSON(map[string]interface{}{
					"type":      "status",
					"status":    currentStatus,
					"exit_code": execution.ExitCode,
					"duration":  execution.Duration,
				})
				return
			}
		}
	}
}

// ExecuteAttackWithStreaming executes an attack and streams output via WebSocket
func (h *WebSocketHandler) ExecuteAttackWithStreaming(w http.ResponseWriter, r *http.Request, attack *AttackScenario) {
	// Upgrade to WebSocket
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Printf("WebSocket upgrade error: %v", err)
		return
	}
	defer conn.Close()

	// Create execution
	execution := h.tracker.CreateExecution(attack.ID)

	// Send execution ID
	conn.WriteJSON(map[string]interface{}{
		"type":         "started",
		"execution_id": execution.ID,
		"attack_id":    attack.ID,
	})

	// Create command
	cmd := exec.Command("/bin/bash", attack.ScriptPath)

	// Get stdout and stderr pipes
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		conn.WriteJSON(map[string]string{"type": "error", "message": err.Error()})
		execution.MarkCompleted(1)
		return
	}

	stderr, err := cmd.StderrPipe()
	if err != nil {
		conn.WriteJSON(map[string]string{"type": "error", "message": err.Error()})
		execution.MarkCompleted(1)
		return
	}

	// Start command
	if err := cmd.Start(); err != nil {
		conn.WriteJSON(map[string]string{"type": "error", "message": err.Error()})
		execution.MarkCompleted(1)
		return
	}

	// Stream stdout
	go func() {
		scanner := bufio.NewScanner(stdout)
		for scanner.Scan() {
			line := scanner.Text()
			execution.AddOutputLine(line)
			conn.WriteJSON(map[string]interface{}{
				"type": "output",
				"line": line,
			})
		}
	}()

	// Stream stderr
	go func() {
		scanner := bufio.NewScanner(stderr)
		for scanner.Scan() {
			line := scanner.Text()
			execution.AddOutputLine(line)
			conn.WriteJSON(map[string]interface{}{
				"type": "output",
				"line": line,
			})
		}
	}()

	// Wait for command to complete
	err = cmd.Wait()

	exitCode := 0
	if err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			exitCode = exitErr.ExitCode()
		} else {
			exitCode = 1
		}
	}

	execution.MarkCompleted(exitCode)

	// Send completion message
	conn.WriteJSON(map[string]interface{}{
		"type":      "completed",
		"status":    execution.Status,
		"exit_code": exitCode,
		"duration":  execution.Duration,
	})
}

// ExecuteVulnerableEndpoint executes a vulnerable endpoint (for Phase 5 interactive scenarios)
func ExecuteVulnerableCommand(command string) (string, error) {
	cmd := exec.Command("/bin/sh", "-c", command)

	var outBuf, errBuf bytes.Buffer
	cmd.Stdout = &outBuf
	cmd.Stderr = &errBuf

	err := cmd.Run()
	output := outBuf.String() + errBuf.String()

	if err != nil {
		return output, fmt.Errorf("command failed: %v", err)
	}

	return output, nil
}
