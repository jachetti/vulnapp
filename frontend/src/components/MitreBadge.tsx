import type { MitreTechnique } from '../types/attack.types';

interface MitreBadgeProps {
  technique: MitreTechnique;
  size?: 'sm' | 'md';
}

export function MitreBadge({ technique, size = 'sm' }: MitreBadgeProps) {
  const sizeClasses = {
    sm: 'text-xs px-2 py-0.5',
    md: 'text-sm px-3 py-1',
  };

  return (
    <span
      className={`inline-flex items-center rounded bg-cs-info/20 text-cs-info font-mono ${sizeClasses[size]} border border-cs-info/30`}
      title={technique.description || technique.name}
    >
      {technique.id}
    </span>
  );
}
