import React, { useState } from 'react';
import type { AttackScenario } from '../types/attack.types';
import { useProgress } from '../hooks/useProgress';

interface FlagSubmissionBoxProps {
  scenario: AttackScenario;
  onSuccess?: () => void;
}

export const FlagSubmissionBox: React.FC<FlagSubmissionBoxProps> = ({
  scenario,
  onSuccess,
}) => {
  const { isSolved, submitFlag } = useProgress();
  const [flagInput, setFlagInput] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState<{
    type: 'success' | 'error' | 'already-solved';
    message: string;
    points?: number;
  } | null>(null);

  const solved = isSolved(scenario.id);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!flagInput.trim()) {
      setResult({
        type: 'error',
        message: 'Please enter a flag',
      });
      return;
    }

    try {
      setSubmitting(true);
      setResult(null);

      const response = await submitFlag(scenario.id, flagInput);

      if (response.already_solved) {
        setResult({
          type: 'already-solved',
          message: "You've already solved this scenario!",
        });
      } else if (response.correct) {
        setResult({
          type: 'success',
          message: response.message,
          points: response.points_earned,
        });
        setFlagInput('');

        // Trigger confetti or celebration animation
        if (onSuccess) {
          onSuccess();
        }
      } else {
        setResult({
          type: 'error',
          message: response.message,
        });
      }
    } catch (err) {
      setResult({
        type: 'error',
        message: 'Failed to submit flag. Please try again.',
      });
    } finally {
      setSubmitting(false);
    }
  };

  // If scenario doesn't have a flag, don't show submission box
  if (!scenario.flag) {
    return null;
  }

  return (
    <div className="border-t border-cs-dark pt-4 mt-4">
      {solved ? (
        // Already solved state
        <div className="bg-green-500/10 border border-green-500/30 rounded-lg p-4">
          <div className="flex items-center gap-3">
            <span className="text-3xl">✅</span>
            <div>
              <div className="text-green-400 font-semibold text-lg">Solved!</div>
              <div className="text-gray-400 text-sm">
                You earned {scenario.points} points for this scenario
              </div>
            </div>
          </div>
        </div>
      ) : (
        // Flag submission form
        <div className="space-y-3">
          <div>
            <div className="flex items-center gap-2 mb-2">
              <span className="text-2xl">🚩</span>
              <h4 className="text-white font-semibold">Found the flag?</h4>
            </div>
            <p className="text-cs-gray text-sm">
              Submit the flag from the output above to earn {scenario.points} points
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-3">
            <div className="flex gap-2">
              <input
                type="text"
                value={flagInput}
                onChange={(e) => setFlagInput(e.target.value)}
                placeholder="FLAG{...}"
                className="flex-1 bg-gray-800 border border-gray-700 rounded-lg px-4 py-2 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-cs-red focus:border-transparent font-mono text-sm"
                disabled={submitting}
              />
              <button
                type="submit"
                disabled={submitting || !flagInput.trim()}
                className="bg-cs-red hover:bg-cs-red/80 disabled:bg-gray-700 disabled:cursor-not-allowed text-white px-6 py-2 rounded-lg font-semibold transition-colors flex items-center gap-2"
              >
                {submitting ? (
                  <>
                    <span className="animate-spin">⟳</span>
                    Checking...
                  </>
                ) : (
                  <>
                    <span>Submit Flag</span>
                    <span>→</span>
                  </>
                )}
              </button>
            </div>

            {/* Result messages */}
            {result && (
              <div
                className={`rounded-lg p-3 ${
                  result.type === 'success'
                    ? 'bg-green-500/10 border border-green-500/30'
                    : result.type === 'already-solved'
                    ? 'bg-yellow-500/10 border border-yellow-500/30'
                    : 'bg-red-500/10 border border-red-500/30'
                }`}
              >
                <div className="flex items-start gap-3">
                  <span className="text-2xl">
                    {result.type === 'success'
                      ? '🎉'
                      : result.type === 'already-solved'
                      ? '⚠️'
                      : '❌'}
                  </span>
                  <div className="flex-1">
                    <div
                      className={`font-semibold mb-1 ${
                        result.type === 'success'
                          ? 'text-green-400'
                          : result.type === 'already-solved'
                          ? 'text-yellow-400'
                          : 'text-red-400'
                      }`}
                    >
                      {result.type === 'success' && 'Correct!'}
                      {result.type === 'already-solved' && 'Already Solved'}
                      {result.type === 'error' && 'Incorrect'}
                    </div>
                    <div className="text-gray-300 text-sm">{result.message}</div>
                    {result.points && (
                      <div className="mt-2 flex items-center gap-2">
                        <div className="bg-green-500/20 text-green-400 px-3 py-1 rounded-full text-xs font-bold">
                          +{result.points} POINTS
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            )}
          </form>

          {/* Hint */}
          <div className="text-xs text-gray-500 italic">
            💡 Tip: Look for lines containing "FLAG{'{'...{'}'}" in the terminal output above
          </div>
        </div>
      )}
    </div>
  );
};
