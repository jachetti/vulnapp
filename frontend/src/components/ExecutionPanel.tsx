import { useEffect, useRef } from 'react';
import type { AttackScenario, Execution } from '../types/attack.types';
import { useWebSocket } from '../hooks/useWebSocket';
import { executionsAPI } from '../api/attacks';
import { MitreBadge } from './MitreBadge';

interface ExecutionPanelProps {
  attack: AttackScenario;
  execution: Execution | null;
  onClose: () => void;
}

export function ExecutionPanel({ attack, execution, onClose }: ExecutionPanelProps) {
  const outputRef = useRef<HTMLDivElement>(null);

  // Setup WebSocket connection for live streaming
  const wsUrl = execution
    ? executionsAPI.getStreamUrl(execution.id)
    : null;

  const { output, status, exitCode, duration, isConnected } = useWebSocket(wsUrl);

  // Auto-scroll to bottom as output comes in
  useEffect(() => {
    if (outputRef.current) {
      outputRef.current.scrollTop = outputRef.current.scrollHeight;
    }
  }, [output]);

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
                <p className="text-cs-gray text-sm">{attack.description}</p>
              </div>

              {/* Severity */}
              <div>
                <h3 className="text-cs-white font-semibold mb-2 text-sm">Severity</h3>
                <span
                  className={`inline-block px-3 py-1 rounded text-sm font-semibold ${
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
            </div>
          </div>

          {/* Right Panel: Terminal Output */}
          <div className="flex-1 flex flex-col bg-cs-darker">
            <div className="border-b border-cs-dark px-4 py-2 flex items-center justify-between">
              <span className="text-cs-white text-sm font-mono">Output</span>
              <span className="text-cs-gray text-xs">
                {output.length} {output.length === 1 ? 'line' : 'lines'}
              </span>
            </div>
            <div
              ref={outputRef}
              className="flex-1 overflow-y-auto p-4 font-mono text-sm"
              style={{ backgroundColor: '#0a0a0a' }}
            >
              {output.length === 0 && status === 'running' ? (
                <div className="text-cs-gray flex items-center gap-2">
                  <span className="animate-spin">⟳</span>
                  Waiting for output...
                </div>
              ) : (
                output.map((line, idx) => (
                  <div key={idx} className="text-green-400 whitespace-pre-wrap">
                    {line}
                  </div>
                ))
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
