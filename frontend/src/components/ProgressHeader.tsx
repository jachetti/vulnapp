import React from 'react';
import { useProgress } from '../hooks/useProgress';

export const ProgressHeader: React.FC = () => {
  const { progress, loading } = useProgress();

  if (loading || !progress) {
    return null;
  }

  const totalPoints = progress.total_points;
  const solvedCount = progress.solved_scenarios.length;
  const maxPoints = 1000;
  const maxScenarios = 17;
  const progressPercentage = (totalPoints / maxPoints) * 100;
  const isCertified = totalPoints >= maxPoints;

  return (
    <div className="bg-gradient-to-r from-cs-darker via-gray-900 to-cs-darker border-b border-cs-dark shadow-lg sticky top-0 z-40">
      <div className="container mx-auto px-6 py-4">
        {/* Progress Info Row */}
        <div className="flex items-center justify-between mb-3">
          {/* Left: Points and Scenarios */}
          <div className="flex items-center gap-6">
            <div>
              <div className="text-cs-gray text-xs mb-1">SE Certification Progress</div>
              <div className="flex items-baseline gap-2">
                <span className="text-white text-2xl font-bold">{totalPoints}</span>
                <span className="text-cs-gray text-sm">/ {maxPoints} points</span>
              </div>
            </div>

            <div className="border-l border-gray-700 pl-6">
              <div className="text-cs-gray text-xs mb-1">Scenarios Completed</div>
              <div className="flex items-baseline gap-2">
                <span className="text-white text-2xl font-bold">{solvedCount}</span>
                <span className="text-cs-gray text-sm">/ {maxScenarios}</span>
              </div>
            </div>
          </div>

          {/* Right: Certification Badge */}
          {isCertified ? (
            <div className="bg-gradient-to-r from-green-500/20 to-cs-red/20 border border-green-500/50 rounded-lg px-6 py-3 flex items-center gap-3">
              <span className="text-4xl">🏆</span>
              <div>
                <div className="text-green-400 font-bold text-lg">CERTIFIED!</div>
                <div className="text-gray-400 text-xs">VulnApp Container Security SE</div>
              </div>
            </div>
          ) : (
            <div className="text-right">
              <div className="text-cs-gray text-xs mb-1">Points to Certification</div>
              <div className="text-cs-red text-xl font-bold">{maxPoints - totalPoints}</div>
            </div>
          )}
        </div>

        {/* Progress Bar */}
        <div className="relative">
          <div className="h-3 bg-gray-800 rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-cs-red via-orange-500 to-green-500 transition-all duration-500 ease-out relative"
              style={{ width: `${progressPercentage}%` }}
            >
              <div className="absolute inset-0 bg-white/20 animate-pulse" />
            </div>
          </div>

          {/* Milestone markers */}
          <div className="absolute inset-0 flex justify-between px-1">
            {[0, 250, 500, 750, 1000].map((milestone) => (
              <div
                key={milestone}
                className={`w-0.5 h-3 ${
                  totalPoints >= milestone ? 'bg-white/50' : 'bg-gray-700'
                }`}
              />
            ))}
          </div>
        </div>

        {/* Percentage */}
        <div className="text-center mt-2">
          <span className="text-cs-gray text-xs font-mono">
            {progressPercentage.toFixed(1)}% Complete
          </span>
        </div>
      </div>
    </div>
  );
};
