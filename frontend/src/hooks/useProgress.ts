import { useState, useEffect } from 'react';

export interface UserProgress {
  session_id: string;
  total_points: number;
  solved_scenarios: string[];
  started_at: string;
  last_activity: string;
}

export interface FlagSubmissionResponse {
  correct: boolean;
  points_earned: number;
  total_points: number;
  message: string;
  already_solved: boolean;
}

const API_BASE = '/api';

// Get or create session ID
export const getSessionID = (): string => {
  let sessionID = localStorage.getItem('vulnapp_session_id');
  if (!sessionID) {
    sessionID = `session_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    localStorage.setItem('vulnapp_session_id', sessionID);
  }
  return sessionID;
};

// Submit flag
export const submitFlag = async (
  scenarioID: string,
  flag: string
): Promise<FlagSubmissionResponse> => {
  const sessionID = getSessionID();

  const response = await fetch(`${API_BASE}/progress/submit-flag`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      session_id: sessionID,
      scenario_id: scenarioID,
      flag: flag.trim(),
    }),
  });

  if (!response.ok) {
    throw new Error('Failed to submit flag');
  }

  return response.json();
};

// Get user progress
export const getProgress = async (): Promise<UserProgress> => {
  const sessionID = getSessionID();

  const response = await fetch(`${API_BASE}/progress?session_id=${sessionID}`);

  if (!response.ok) {
    throw new Error('Failed to fetch progress');
  }

  return response.json();
};

// Custom hook for managing progress
export const useProgress = () => {
  const [progress, setProgress] = useState<UserProgress | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const loadProgress = async () => {
    try {
      setLoading(true);
      const data = await getProgress();
      setProgress(data);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load progress');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadProgress();
  }, []);

  const submitScenarioFlag = async (scenarioID: string, flag: string) => {
    try {
      const result = await submitFlag(scenarioID, flag);

      // Refresh progress if correct
      if (result.correct) {
        await loadProgress();
      }

      return result;
    } catch (err) {
      throw err;
    }
  };

  const isSolved = (scenarioID: string): boolean => {
    return progress?.solved_scenarios.includes(scenarioID) || false;
  };

  return {
    progress,
    loading,
    error,
    submitFlag: submitScenarioFlag,
    isSolved,
    refresh: loadProgress,
  };
};
