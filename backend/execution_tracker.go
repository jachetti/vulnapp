package backend

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"log"
	"os/exec"
	"sync"
	"time"
)

// ExecutionStatus represents the status of an attack execution
type ExecutionStatus string

const (
	ExecutionStatusRunning   ExecutionStatus = "running"
	ExecutionStatusCompleted ExecutionStatus = "completed"
	ExecutionStatusFailed    ExecutionStatus = "failed"
)

// Execution represents a single attack execution
type Execution struct {
	ID          string          `json:"id"`
	AttackID    string          `json:"attack_id"`
	Status      ExecutionStatus `json:"status"`
	Output      string          `json:"output"`
	ExitCode    int             `json:"exit_code"`
	StartTime   time.Time       `json:"start_time"`
	EndTime     *time.Time      `json:"end_time,omitempty"`
	Duration    string          `json:"duration,omitempty"`
	cmd         *exec.Cmd
	outputLines []string
	mu          sync.RWMutex
}

// ExecutionTracker tracks running and completed executions
type ExecutionTracker struct {
	executions map[string]*Execution
	mu         sync.RWMutex
}

// NewExecutionTracker creates a new execution tracker
func NewExecutionTracker() *ExecutionTracker {
	return &ExecutionTracker{
		executions: make(map[string]*Execution),
	}
}

// CreateExecution creates a new execution
func (t *ExecutionTracker) CreateExecution(attackID string) *Execution {
	t.mu.Lock()
	defer t.mu.Unlock()

	executionID := fmt.Sprintf("exec-%d", time.Now().UnixNano())
	execution := &Execution{
		ID:          executionID,
		AttackID:    attackID,
		Status:      ExecutionStatusRunning,
		StartTime:   time.Now(),
		outputLines: make([]string, 0),
	}

	t.executions[executionID] = execution
	return execution
}

// GetExecution returns an execution by ID
func (t *ExecutionTracker) GetExecution(executionID string) *Execution {
	t.mu.RLock()
	defer t.mu.RUnlock()

	return t.executions[executionID]
}

// GetAllExecutions returns all executions
func (t *ExecutionTracker) GetAllExecutions() []*Execution {
	t.mu.RLock()
	defer t.mu.RUnlock()

	executions := make([]*Execution, 0, len(t.executions))
	for _, exec := range t.executions {
		executions = append(executions, exec)
	}
	return executions
}

// AddOutputLine adds a line of output to the execution
func (e *Execution) AddOutputLine(line string) {
	e.mu.Lock()
	defer e.mu.Unlock()

	e.outputLines = append(e.outputLines, line)
	e.Output = e.Output + line + "\n"
}

// MarkCompleted marks the execution as completed
func (e *Execution) MarkCompleted(exitCode int) {
	e.mu.Lock()
	defer e.mu.Unlock()

	now := time.Now()
	e.EndTime = &now
	e.ExitCode = exitCode
	e.Duration = fmt.Sprintf("%.2fs", now.Sub(e.StartTime).Seconds())

	if exitCode == 0 {
		e.Status = ExecutionStatusCompleted
	} else {
		e.Status = ExecutionStatusFailed
	}
}

// GetOutputLines returns all output lines
func (e *Execution) GetOutputLines() []string {
	e.mu.RLock()
	defer e.mu.RUnlock()

	return e.outputLines
}

// streamOutput reads from a pipe and adds each line to the execution
func streamOutput(pipe io.ReadCloser, execution *Execution, prefix string) {
	scanner := bufio.NewScanner(pipe)
	for scanner.Scan() {
		line := scanner.Text()
		execution.AddOutputLine(line)
		log.Printf("[%s] %s: %s", execution.ID, prefix, line)
	}
	if err := scanner.Err(); err != nil {
		log.Printf("[%s] Scanner error (%s): %v", execution.ID, prefix, err)
	}
}

// fileExists checks if a file exists
func fileExists(path string) bool {
	_, err := exec.Command("test", "-f", path).Output()
	return err == nil
}

// ExecuteAttack executes an attack script and tracks its output in real-time
func (t *ExecutionTracker) ExecuteAttack(attack *AttackScenario) (*Execution, error) {
	execution := t.CreateExecution(attack.ID)

	log.Printf("[%s] Starting execution of attack: %s (script: %s)", execution.ID, attack.ID, attack.ScriptPath)

	// Step 1: Run setup script (plant vulnerabilities & flags)
	setupScript := attack.ScriptPath[:len(attack.ScriptPath)-3] + "_setup.sh"
	if fileExists(setupScript) {
		log.Printf("[%s] Running setup script: %s", execution.ID, setupScript)
		setupCmd := exec.Command("/bin/bash", setupScript)
		setupOutput, err := setupCmd.CombinedOutput()

		// Add setup output to execution
		scanner := bufio.NewScanner(bytes.NewReader(setupOutput))
		for scanner.Scan() {
			execution.AddOutputLine(scanner.Text())
		}

		if err != nil {
			log.Printf("[%s] Setup script failed: %v", execution.ID, err)
		} else {
			log.Printf("[%s] Setup completed successfully", execution.ID)
		}
	}

	// Step 2: Schedule cleanup to run after execution completes
	cleanupScript := attack.ScriptPath[:len(attack.ScriptPath)-3] + "_cleanup.sh"

	// Step 3: Create command for main scenario
	cmd := exec.Command("/bin/bash", attack.ScriptPath)

	// Get stdout and stderr pipes for real-time streaming
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Printf("[%s] Failed to get stdout pipe: %v", execution.ID, err)
		return nil, fmt.Errorf("failed to get stdout pipe: %v", err)
	}

	stderr, err := cmd.StderrPipe()
	if err != nil {
		log.Printf("[%s] Failed to get stderr pipe: %v", execution.ID, err)
		return nil, fmt.Errorf("failed to get stderr pipe: %v", err)
	}

	execution.cmd = cmd

	// Start the command
	if err := cmd.Start(); err != nil {
		log.Printf("[%s] Failed to start command: %v", execution.ID, err)
		return nil, fmt.Errorf("failed to start command: %v", err)
	}

	log.Printf("[%s] Command started successfully, PID: %d", execution.ID, cmd.Process.Pid)

	// Stream output in separate goroutines
	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		defer wg.Done()
		streamOutput(stdout, execution, "stdout")
	}()

	go func() {
		defer wg.Done()
		streamOutput(stderr, execution, "stderr")
	}()

	// Wait for command to complete in a goroutine
	go func() {
		// Wait for output streaming to finish
		wg.Wait()

		// Wait for command to finish
		err := cmd.Wait()

		exitCode := 0
		if err != nil {
			if exitErr, ok := err.(*exec.ExitError); ok {
				exitCode = exitErr.ExitCode()
				log.Printf("[%s] Command exited with code: %d", execution.ID, exitCode)
			} else {
				exitCode = 1
				log.Printf("[%s] Command failed: %v", execution.ID, err)
			}
		} else {
			log.Printf("[%s] Command completed successfully", execution.ID)
		}

		execution.MarkCompleted(exitCode)
		log.Printf("[%s] Execution marked as completed. Total output lines: %d", execution.ID, len(execution.GetOutputLines()))

		// Run cleanup script after execution finishes
		if fileExists(cleanupScript) {
			log.Printf("[%s] Running cleanup script: %s", execution.ID, cleanupScript)
			cleanupCmd := exec.Command("/bin/bash", cleanupScript)
			cleanupOutput, err := cleanupCmd.CombinedOutput()

			// Add cleanup output to logs (but not user-visible output)
			if err != nil {
				log.Printf("[%s] Cleanup script failed: %v - %s", execution.ID, err, string(cleanupOutput))
			} else {
				log.Printf("[%s] Cleanup completed successfully", execution.ID)
			}
		}
	}()

	return execution, nil
}
