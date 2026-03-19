import { useEffect, useRef, useState, useMemo } from 'react';
import type { AttackScenario, Execution } from '../types/attack.types';
import { useWebSocket } from '../hooks/useWebSocket';
import { executionsAPI } from '../api/attacks';
import { MitreBadge } from './MitreBadge';
import { CurrentStageHeader } from './CurrentStageHeader';
import { FlagSubmissionBox } from './FlagSubmissionBox';
import { parseTerminalLine, extractCurrentStage, countTotalStages, type ParsedLine } from '../utils/terminalParser';

interface ExecutionPanelProps {
  attack: AttackScenario;
  execution: Execution | null;
  onClose: () => void;
}

export function ExecutionPanel({ attack, execution, onClose }: ExecutionPanelProps) {
  const outputRef = useRef<HTMLDivElement>(null);
  const [startTime] = useState(Date.now());
  const [elapsedSeconds, setElapsedSeconds] = useState(0);
  const [isUserScrolling, setIsUserScrolling] = useState(false);

  // Setup WebSocket connection for live streaming
  const wsUrl = execution
    ? executionsAPI.getStreamUrl(execution.id)
    : null;

  const { output, status, exitCode, duration, isConnected } = useWebSocket(wsUrl);

  // Timer for elapsed time
  useEffect(() => {
    if (status === 'running') {
      const interval = setInterval(() => {
        setElapsedSeconds(Math.floor((Date.now() - startTime) / 1000));
      }, 1000);
      return () => clearInterval(interval);
    }
  }, [status, startTime]);

  // Parse output lines
  const parsedLines: ParsedLine[] = useMemo(() => {
    return output.map(parseTerminalLine);
  }, [output]);

  // Extract current stage info
  const currentStage = useMemo(() => {
    return extractCurrentStage(parsedLines);
  }, [parsedLines]);

  // Count total stages
  const totalStages = useMemo(() => {
    return countTotalStages(output.join('\n'));
  }, [output]);

  // Auto-scroll to bottom (unless user is scrolling)
  useEffect(() => {
    if (outputRef.current && !isUserScrolling) {
      outputRef.current.scrollTop = outputRef.current.scrollHeight;
    }
  }, [output, isUserScrolling]);

  // Force scroll to bottom when execution completes (to show flag)
  useEffect(() => {
    if (status === 'completed' && outputRef.current) {
      // Force scroll after a brief delay to ensure all output is rendered
      setTimeout(() => {
        if (outputRef.current) {
          setIsUserScrolling(false); // Reset user scrolling flag
          outputRef.current.scrollTop = outputRef.current.scrollHeight;
        }
      }, 200);
    }
  }, [status]);

  // Detect user scrolling
  const handleScroll = () => {
    if (outputRef.current) {
      const { scrollTop, scrollHeight, clientHeight } = outputRef.current;
      const isAtBottom = scrollHeight - scrollTop - clientHeight < 50;
      setIsUserScrolling(!isAtBottom);
    }
  };

  const statusColors = {
    running: 'bg-yellow-500/20 text-yellow-400',
    completed: 'bg-green-500/20 text-green-400',
    failed: 'bg-red-500/20 text-red-400',
  };

  const statusIcons = {
    running: '⟳',
    completed: '✓',
    failed: '✗',
  };

  // Render enhanced terminal line
  const renderTerminalLine = (line: ParsedLine, idx: number) => {
    switch (line.type) {
      case 'stage-header':
        return (
          <div key={idx} className="my-4">
            <div className="bg-gradient-to-r from-cs-red/20 to-transparent border-l-4 border-cs-red p-3 rounded">
              <div className="flex items-center gap-3">
                <span className="bg-cs-red text-white px-2 py-1 rounded text-xs font-bold">
                  STAGE {line.metadata?.stageNumber}
                </span>
                <span className="text-white font-semibold text-base">
                  {line.metadata?.stageTitle}
                </span>
              </div>
            </div>
          </div>
        );

      case 'command-start':
        return (
          <div key={idx} className="my-3 bg-blue-500/10 border border-blue-500/30 rounded-lg p-3">
            <div className="flex items-center gap-2 mb-1">
              <span className="text-blue-400 text-xs font-semibold">▶ EXECUTING</span>
            </div>
            <code className="text-green-300 text-sm block pl-4">
              $ {line.metadata?.command}
            </code>
          </div>
        );

      case 'stage-divider':
        return (
          <div key={idx} className="my-2 border-t border-gray-700 opacity-30" />
        );

      case 'teaching-note':
        return (
          <div key={idx} className="text-yellow-300 bg-yellow-500/10 px-3 py-1 rounded my-1 text-sm border-l-2 border-yellow-500">
            {line.content}
          </div>
        );

      case 'flag':
        return (
          <div key={idx} className="my-3">
            <div className="bg-gradient-to-r from-green-500/20 to-transparent border-l-4 border-green-500 p-4 rounded animate-pulse">
              <div className="flex items-center gap-3">
                <span className="text-3xl">🚩</span>
                <div>
                  <div className="text-green-400 font-semibold text-lg mb-1">FLAG CAPTURED!</div>
                  <code className="text-green-300 text-base font-mono">
                    {line.metadata?.flag}
                  </code>
                  <div className="text-gray-400 text-xs mt-2">
                    Copy this flag and submit it to earn points!
                  </div>
                </div>
              </div>
            </div>
          </div>
        );

      default:
        return (
          <div key={idx} className="text-green-400 whitespace-pre-wrap text-sm">
            {line.content}
          </div>
        );
    }
  };

  return (
    <div className="fixed inset-0 bg-black/80 flex items-center justify-center z-50 p-4">
      <div className="bg-cs-darker border border-cs-dark rounded-lg w-full max-w-7xl h-[90vh] flex flex-col">
        {/* Header */}
        <div className="border-b border-cs-dark p-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <h2 className="text-cs-white text-xl font-semibold">{attack.name}</h2>
            {status && (
              <span
                className={`px-3 py-1 rounded text-sm font-semibold ${
                  statusColors[status]
                }`}
              >
                {statusIcons[status]} {status.toUpperCase()}
              </span>
            )}
            {isConnected && status === 'running' && (
              <span className="text-cs-success text-xs flex items-center gap-1">
                <span className="w-2 h-2 bg-cs-success rounded-full animate-pulse"></span>
                Live
              </span>
            )}
          </div>
          <button
            onClick={onClose}
            className="text-cs-gray hover:text-cs-white text-2xl leading-none"
          >
            ×
          </button>
        </div>

        {/* Split View */}
        <div className="flex-1 flex overflow-hidden">
          {/* Left Panel: Attack Details */}
          <div className="w-1/3 border-r border-cs-dark p-6 overflow-y-auto">
            <div className="space-y-6">
              {/* Description */}
              <div>
                <h3 className="text-cs-white font-semibold mb-2 text-sm">Description</h3>
                <p className="text-cs-gray text-xs leading-relaxed">
                  {attack.description}
                </p>
              </div>

              {/* Severity */}
              <div>
                <h3 className="text-cs-white font-semibold mb-2 text-sm">Severity</h3>
                <span
                  className={`px-3 py-1 rounded text-xs font-semibold ${
                    attack.severity === 'CRITICAL'
                      ? 'bg-red-500/20 text-red-400'
                      : attack.severity === 'HIGH'
                      ? 'bg-orange-500/20 text-orange-400'
                      : attack.severity === 'MEDIUM'
                      ? 'bg-yellow-500/20 text-yellow-400'
                      : 'bg-blue-500/20 text-blue-400'
                  }`}
                >
                  {attack.severity}
                </span>
              </div>

              {/* MITRE ATT&CK */}
              <div>
                <h3 className="text-cs-white font-semibold mb-2 text-sm">
                  MITRE ATT&CK Techniques
                </h3>
                <div className="space-y-2">
                  {attack.mitre_techniques.map((technique) => (
                    <div key={technique.id} className="flex flex-col gap-1">
                      <MitreBadge technique={technique} size="md" />
                      <p className="text-cs-gray text-xs ml-1">{technique.name}</p>
                    </div>
                  ))}
                </div>
              </div>

              {/* CVEs */}
              {attack.cve && attack.cve.length > 0 && (
                <div>
                  <h3 className="text-cs-white font-semibold mb-2 text-sm">CVEs</h3>
                  <div className="flex flex-wrap gap-2">
                    {attack.cve.map((cve) => (
                      <span
                        key={cve}
                        className="px-3 py-1 rounded text-sm bg-purple-500/20 text-purple-400 border border-purple-500/30"
                      >
                        {cve}
                      </span>
                    ))}
                  </div>
                </div>
              )}

              {/* Prerequisites */}
              {attack.prerequisites && attack.prerequisites.length > 0 && (
                <div>
                  <h3 className="text-cs-white font-semibold mb-2 text-sm">Prerequisites</h3>
                  <ul className="text-cs-gray text-xs space-y-1">
                    {attack.prerequisites.map((prereq, idx) => (
                      <li key={idx} className="flex items-start gap-2">
                        <span className="text-cs-red mt-0.5">•</span>
                        <span>{prereq}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              )}

              {/* Execution Info */}
              {execution && (
                <div>
                  <h3 className="text-cs-white font-semibold mb-2 text-sm">Execution Info</h3>
                  <div className="text-xs space-y-1">
                    <div className="flex justify-between">
                      <span className="text-cs-gray">Execution ID:</span>
                      <span className="text-cs-white font-mono">{execution.id}</span>
                    </div>
                    {duration && (
                      <div className="flex justify-between">
                        <span className="text-cs-gray">Duration:</span>
                        <span className="text-cs-white font-mono">{duration}</span>
                      </div>
                    )}
                    {exitCode !== null && status !== 'running' && (
                      <div className="flex justify-between">
                        <span className="text-cs-gray">Exit Code:</span>
                        <span
                          className={`font-mono ${
                            exitCode === 0 ? 'text-cs-success' : 'text-cs-error'
                          }`}
                        >
                          {exitCode}
                        </span>
                      </div>
                    )}
                  </div>
                </div>
              )}

              {/* Flag Submission Box (only for completed learning scenarios) */}
              {attack.flag && status === 'completed' && (
                <FlagSubmissionBox scenario={attack} />
              )}
            </div>
          </div>

          {/* Right Panel: Terminal Output with Stage Header */}
          <div className="flex-1 flex flex-col bg-cs-darker">
            {/* Current Stage Header (sticky) */}
            {status === 'running' && totalStages > 0 && (
              <CurrentStageHeader
                stageNumber={currentStage.stageNumber}
                totalStages={totalStages}
                stageTitle={currentStage.stageTitle}
                currentCommand={currentStage.command}
                elapsedTime={elapsedSeconds}
              />
            )}

            {/* Terminal Output */}
            <div
              ref={outputRef}
              onScroll={handleScroll}
              className="flex-1 overflow-y-auto p-4 font-mono text-sm relative"
              style={{ backgroundColor: '#0a0a0a' }}
            >
              {output.length === 0 && status === 'running' ? (
                <div className="text-cs-gray flex items-center gap-2">
                  <span className="animate-spin">⟳</span>
                  Waiting for output...
                </div>
              ) : (
                parsedLines.map((line, idx) => renderTerminalLine(line, idx))
              )}

              {/* Scroll to bottom hint */}
              {isUserScrolling && status === 'running' && (
                <button
                  onClick={() => {
                    setIsUserScrolling(false);
                    if (outputRef.current) {
                      outputRef.current.scrollTop = outputRef.current.scrollHeight;
                    }
                  }}
                  className="fixed bottom-8 right-8 bg-cs-red text-white px-4 py-2 rounded-lg shadow-lg flex items-center gap-2 hover:bg-cs-red/80 transition-colors"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 14l-7 7m0 0l-7-7m7 7V3" />
                  </svg>
                  Scroll to Bottom
                </button>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
