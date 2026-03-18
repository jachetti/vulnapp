package backend

import (
	"bytes"
	"fmt"
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

// ExecuteAttack executes an attack script and tracks its output
func (t *ExecutionTracker) ExecuteAttack(attack *AttackScenario) (*Execution, error) {
	execution := t.CreateExecution(attack.ID)

	// Create command
	cmd := exec.Command("/bin/bash", attack.ScriptPath)

	// Capture output
	var outBuf, errBuf bytes.Buffer
	cmd.Stdout = &outBuf
	cmd.Stderr = &errBuf

	execution.cmd = cmd

	// Execute in goroutine
	go func() {
		err := cmd.Run()

		// Combine stdout and stderr
		output := outBuf.String() + errBuf.String()
		execution.mu.Lock()
		execution.Output = output
		execution.mu.Unlock()

		exitCode := 0
		if err != nil {
			if exitErr, ok := err.(*exec.ExitError); ok {
				exitCode = exitErr.ExitCode()
			} else {
				exitCode = 1
			}
		}

		execution.MarkCompleted(exitCode)
	}()

	return execution, nil
}
