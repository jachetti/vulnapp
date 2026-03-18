import { useState } from 'react';
import type { AttackScenario } from '../types/attack.types';
import { AttackCard } from './AttackCard';

interface AttackGridProps {
  categories: Record<string, AttackScenario[]>;
  onExecute: (attack: AttackScenario) => void;
}

export function AttackGrid({ categories, onExecute }: AttackGridProps) {
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);

  const categoryOrder = [
    'Execution',
    'Persistence',
    'Privilege Escalation',
    'Defense Evasion',
    'Credential Access',
    'Collection',
    'Command and Control',
    'Exfiltration',
    'Impact',
  ];

  const sortedCategories = Object.keys(categories).sort((a, b) => {
    const indexA = categoryOrder.indexOf(a);
    const indexB = categoryOrder.indexOf(b);
    if (indexA === -1) return 1;
    if (indexB === -1) return -1;
    return indexA - indexB;
  });

  const filteredCategories = selectedCategory
    ? { [selectedCategory]: categories[selectedCategory] }
    : categories;

  return (
    <div>
      {/* Category Filter */}
      <div className="mb-6 flex flex-wrap gap-2">
        <button
          onClick={() => setSelectedCategory(null)}
          className={`px-4 py-2 rounded text-sm font-semibold transition-colors ${
            selectedCategory === null
              ? 'bg-cs-red text-cs-white'
              : 'bg-cs-dark text-cs-gray hover:bg-cs-dark/80'
          }`}
        >
          All Categories ({Object.values(categories).flat().length})
        </button>
        {sortedCategories.map((category) => (
          <button
            key={category}
            onClick={() => setSelectedCategory(category)}
            className={`px-4 py-2 rounded text-sm font-semibold transition-colors ${
              selectedCategory === category
                ? 'bg-cs-red text-cs-white'
                : 'bg-cs-dark text-cs-gray hover:bg-cs-dark/80'
            }`}
          >
            {category} ({categories[category].length})
          </button>
        ))}
      </div>

      {/* Attack Categories */}
      {Object.entries(filteredCategories).map(([category, attacks]) => (
        <div key={category} className="mb-8">
          <h2 className="text-cs-white text-lg font-semibold mb-4 flex items-center gap-2">
            <span className="text-cs-red">❯</span>
            {category}
            <span className="text-cs-gray text-sm font-normal">
              ({attacks.length} {attacks.length === 1 ? 'attack' : 'attacks'})
            </span>
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {attacks.map((attack) => (
              <AttackCard key={attack.id} attack={attack} onExecute={onExecute} />
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}
