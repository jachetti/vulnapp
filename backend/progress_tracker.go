package backend

import (
	"encoding/json"
	"net/http"
	"strings"
	"sync"
	"time"
)

// UserProgress tracks a user's progress through learning scenarios
type UserProgress struct {
	SessionID       string    `json:"session_id"`
	TotalPoints     int       `json:"total_points"`
	SolvedScenarios []string  `json:"solved_scenarios"`
	StartedAt       time.Time `json:"started_at"`
	LastActivity    time.Time `json:"last_activity"`
}

// FlagSubmission represents a flag submission request
type FlagSubmission struct {
	SessionID  string `json:"session_id"`
	ScenarioID string `json:"scenario_id"`
	Flag       string `json:"flag"`
}

// FlagSubmissionResponse represents the response to a flag submission
type FlagSubmissionResponse struct {
	Correct       bool   `json:"correct"`
	PointsEarned  int    `json:"points_earned"`
	TotalPoints   int    `json:"total_points"`
	Message       string `json:"message"`
	AlreadySolved bool   `json:"already_solved"`
}

var (
	progressStore = make(map[string]*UserProgress)
	progressMutex sync.RWMutex
)

// GetOrCreateProgress retrieves or creates a user's progress
func GetOrCreateProgress(sessionID string) *UserProgress {
	progressMutex.Lock()
	defer progressMutex.Unlock()

	progress, exists := progressStore[sessionID]
	if !exists {
		progress = &UserProgress{
			SessionID:       sessionID,
			TotalPoints:     0,
			SolvedScenarios: []string{},
			StartedAt:       time.Now(),
			LastActivity:    time.Now(),
		}
		progressStore[sessionID] = progress
	}

	progress.LastActivity = time.Now()
	return progress
}

// HandleFlagSubmission validates a flag submission and updates progress
func HandleFlagSubmission(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var submission FlagSubmission
	if err := json.NewDecoder(r.Body).Decode(&submission); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Validate inputs
	if submission.SessionID == "" || submission.ScenarioID == "" || submission.Flag == "" {
		http.Error(w, "Missing required fields", http.StatusBadRequest)
		return
	}

	// Get the scenario
	scenario := GetAttackByID(submission.ScenarioID)
	if scenario == nil {
		http.Error(w, "Scenario not found", http.StatusNotFound)
		return
	}

	// Check if scenario has a flag (learning scenarios only)
	if scenario.Flag == "" {
		http.Error(w, "This scenario does not have a flag", http.StatusBadRequest)
		return
	}

	// Get or create progress
	progress := GetOrCreateProgress(submission.SessionID)

	// Check if already solved
	if contains(progress.SolvedScenarios, submission.ScenarioID) {
		response := FlagSubmissionResponse{
			Correct:       false,
			PointsEarned:  0,
			TotalPoints:   progress.TotalPoints,
			Message:       "You've already solved this scenario!",
			AlreadySolved: true,
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	// Validate flag (case-insensitive, trimmed)
	submittedFlag := strings.TrimSpace(submission.Flag)
	correctFlag := strings.TrimSpace(scenario.Flag)
	correct := strings.EqualFold(submittedFlag, correctFlag)

	response := FlagSubmissionResponse{
		Correct:       correct,
		PointsEarned:  0,
		TotalPoints:   progress.TotalPoints,
		AlreadySolved: false,
	}

	if correct {
		// Award points and mark as solved
		progressMutex.Lock()
		progress.TotalPoints += scenario.Points
		progress.SolvedScenarios = append(progress.SolvedScenarios, submission.ScenarioID)
		progress.LastActivity = time.Now()
		progressMutex.Unlock()

		response.PointsEarned = scenario.Points
		response.TotalPoints = progress.TotalPoints
		response.Message = "Correct! Flag captured!"
	} else {
		response.Message = "Incorrect flag. Read the output carefully!"
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// HandleGetProgress retrieves a user's progress
func HandleGetProgress(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	sessionID := r.URL.Query().Get("session_id")
	if sessionID == "" {
		http.Error(w, "Missing session_id parameter", http.StatusBadRequest)
		return
	}

	progress := GetOrCreateProgress(sessionID)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(progress)
}

// HandleGetLeaderboard returns top completion times for current session
func HandleGetLeaderboard(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	progressMutex.RLock()
	defer progressMutex.RUnlock()

	type LeaderboardEntry struct {
		SessionID     string    `json:"session_id"`
		TotalPoints   int       `json:"total_points"`
		CompletedAt   time.Time `json:"completed_at"`
		TimeToComplete int      `json:"time_to_complete"` // seconds
		ScenariosCount int      `json:"scenarios_count"`
	}

	var leaderboard []LeaderboardEntry
	for _, progress := range progressStore {
		if progress.TotalPoints >= 1000 { // Only include completed certifications
			timeToComplete := int(progress.LastActivity.Sub(progress.StartedAt).Seconds())
			entry := LeaderboardEntry{
				SessionID:      maskSessionID(progress.SessionID),
				TotalPoints:    progress.TotalPoints,
				CompletedAt:    progress.LastActivity,
				TimeToComplete: timeToComplete,
				ScenariosCount: len(progress.SolvedScenarios),
			}
			leaderboard = append(leaderboard, entry)
		}
	}

	// Sort by time to complete (fastest first)
	for i := 0; i < len(leaderboard); i++ {
		for j := i + 1; j < len(leaderboard); j++ {
			if leaderboard[j].TimeToComplete < leaderboard[i].TimeToComplete {
				leaderboard[i], leaderboard[j] = leaderboard[j], leaderboard[i]
			}
		}
	}

	// Limit to top 10
	if len(leaderboard) > 10 {
		leaderboard = leaderboard[:10]
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(leaderboard)
}

// contains checks if a slice contains a string
func contains(slice []string, item string) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}

// maskSessionID masks most of the session ID for privacy
func maskSessionID(sessionID string) string {
	if len(sessionID) <= 12 {
		return sessionID
	}
	return sessionID[:8] + "..." + sessionID[len(sessionID)-4:]
}
