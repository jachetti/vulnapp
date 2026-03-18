import React from 'react';

interface CurrentStageHeaderProps {
  stageNumber: number;
  totalStages: number;
  stageTitle: string;
  currentCommand: string;
  elapsedTime: number;
}

export const CurrentStageHeader: React.FC<CurrentStageHeaderProps> = ({
  stageNumber,
  totalStages,
  stageTitle,
  currentCommand,
  elapsedTime
}) => {
  const progressPercentage = totalStages > 0 ? (stageNumber / totalStages) * 100 : 0;

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="sticky top-0 z-10 bg-gradient-to-r from-cs-dark via-gray-900 to-cs-dark border-b border-cs-red/30 shadow-lg">
      {/* Stage Info Row */}
      <div className="px-6 py-3 flex items-center justify-between">
        {/* Left: Stage Indicator */}
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-2">
            <div className="bg-cs-red text-white px-3 py-1 rounded-md font-bold text-sm">
              STAGE {stageNumber}/{totalStages}
            </div>
            <div className="text-white font-medium text-lg">
              {stageTitle || 'Initializing...'}
            </div>
          </div>
        </div>

        {/* Right: Timer */}
        <div className="flex items-center gap-2 text-gray-400 text-sm">
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <span className="font-mono">{formatTime(elapsedTime)}</span>
        </div>
      </div>

      {/* Command Display Row */}
      {currentCommand && (
        <div className="px-6 py-2 bg-black/30 border-t border-gray-800">
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-2">
              <span className="text-green-400 text-sm font-semibold">▶ EXECUTING:</span>
              <code className="text-gray-300 font-mono text-sm bg-gray-800/50 px-3 py-1 rounded">
                {currentCommand}
              </code>
            </div>
            <div className="flex-1" />
            {/* Animated pulse indicator */}
            <div className="flex items-center gap-1">
              <div className="w-2 h-2 bg-green-400 rounded-full animate-pulse" />
              <span className="text-green-400 text-xs">Running</span>
            </div>
          </div>
        </div>
      )}

      {/* Progress Bar */}
      <div className="relative h-1 bg-gray-800">
        <div
          className="absolute inset-y-0 left-0 bg-gradient-to-r from-cs-red to-orange-500 transition-all duration-500 ease-out"
          style={{ width: `${progressPercentage}%` }}
        >
          <div className="absolute inset-0 bg-white/20 animate-pulse" />
        </div>
      </div>
    </div>
  );
};
