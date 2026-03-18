import type { AttackScenario } from '../types/attack.types';
import { MitreBadge } from './MitreBadge';
import { useProgress } from '../hooks/useProgress';

interface AttackCardProps {
  attack: AttackScenario;
  onExecute: (attack: AttackScenario) => void;
}

export function AttackCard({ attack, onExecute }: AttackCardProps) {
  const { isSolved } = useProgress();
  const solved = isSolved(attack.id);

  const severityColors = {
    CRITICAL: 'bg-red-500/20 text-red-400 border-red-500/30',
    HIGH: 'bg-orange-500/20 text-orange-400 border-orange-500/30',
    MEDIUM: 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30',
    LOW: 'bg-blue-500/20 text-blue-400 border-blue-500/30',
  };

  return (
    <div className={`bg-cs-dark border rounded-lg p-4 transition-colors relative ${
      solved
        ? 'border-green-500/50 bg-green-500/5'
        : 'border-cs-darker hover:border-cs-red/50'
    }`}>
      {/* Solved Badge */}
      {solved && attack.points && (
        <div className="absolute top-2 right-2">
          <div className="bg-green-500/20 border border-green-500/50 rounded-full px-3 py-1 flex items-center gap-1">
            <span className="text-green-400 text-xs font-bold">✓ {attack.points} pts</span>
          </div>
        </div>
      )}

      {/* Unsolved Points Badge (for learning scenarios) */}
      {!solved && attack.points && (
        <div className="absolute top-2 right-2">
          <div className="bg-gray-700/50 border border-gray-600 rounded-full px-3 py-1 flex items-center gap-1">
            <span className="text-gray-400 text-xs font-bold">🔒 {attack.points} pts</span>
          </div>
        </div>
      )}

      <div className="flex items-start justify-between mb-3">
        <div className="flex-1 pr-20">
          <div className="flex items-center gap-2 mb-1">
            <h3 className="text-cs-white font-semibold text-sm">{attack.name}</h3>
            {attack.is_modern && !solved && (
              <span className="bg-cs-red text-cs-white text-xs px-2 py-0.5 rounded font-semibold">
                NEW
              </span>
            )}
          </div>
          <p className="text-cs-gray text-xs line-clamp-2 mb-2">
            {attack.description}
          </p>
        </div>
      </div>

      <div className="flex flex-wrap gap-1 mb-3">
        {attack.mitre_techniques.slice(0, 2).map((technique) => (
          <MitreBadge key={technique.id} technique={technique} size="sm" />
        ))}
        {attack.mitre_techniques.length > 2 && (
          <span className="text-cs-gray text-xs">
            +{attack.mitre_techniques.length - 2} more
          </span>
        )}
      </div>

      <div className="flex items-center justify-between">
        <span
          className={`text-xs px-2 py-1 rounded border ${severityColors[attack.severity]}`}
        >
          {attack.severity}
        </span>

        <button
          onClick={() => onExecute(attack)}
          className={`text-xs px-3 py-1.5 rounded font-semibold transition-colors ${
            solved
              ? 'bg-green-600 hover:bg-green-700 text-white'
              : 'bg-cs-red hover:bg-cs-red/80 text-cs-white'
          }`}
        >
          {solved ? 'View ✓' : 'Execute ▶'}
        </button>
      </div>

      {attack.cve && attack.cve.length > 0 && (
        <div className="mt-2 pt-2 border-t border-cs-darker">
          <div className="flex flex-wrap gap-1">
            {attack.cve.map((cve) => (
              <span
                key={cve}
                className="text-xs px-2 py-0.5 rounded bg-purple-500/20 text-purple-400 border border-purple-500/30"
              >
                {cve}
              </span>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
