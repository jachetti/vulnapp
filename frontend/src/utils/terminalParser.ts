// Enhanced terminal output parsing and rendering utilities

export interface ParsedLine {
  type: 'stage-header' | 'command-start' | 'command-end' | 'stage-divider' | 'output' | 'teaching-note' | 'flag';
  content: string;
  metadata?: {
    stageNumber?: number;
    stageTitle?: string;
    command?: string;
    duration?: string;
    flag?: string;
  };
}

export function parseTerminalLine(line: string): ParsedLine {
  // Detect stage dividers
  if (line.match(/━{20,}/) || line.match(/═{20,}/)) {
    return { type: 'stage-divider', content: line };
  }

  // Detect stage headers (e.g., "STAGE 2: Network Discovery")
  const stageMatch = line.match(/STAGE (\d+):\s*(.+)/);
  if (stageMatch) {
    return {
      type: 'stage-header',
      content: line,
      metadata: {
        stageNumber: parseInt(stageMatch[1]),
        stageTitle: stageMatch[2].trim()
      }
    };
  }

  // Detect command execution (e.g., "[*] Command: netstat -an")
  const commandMatch = line.match(/\[\*\]\s*Command:\s*(.+)/);
  if (commandMatch) {
    return {
      type: 'command-start',
      content: line,
      metadata: {
        command: commandMatch[1].trim()
      }
    };
  }

  // Detect teaching notes (e.g., "SE Note:", "Why this matters:")
  if (line.match(/SE Note:|Why this matters:|What attacker sees:/i)) {
    return { type: 'teaching-note', content: line };
  }

  // Detect flags (e.g., "FLAG{...}")
  const flagMatch = line.match(/(FLAG\{[^}]+\})/);
  if (flagMatch) {
    return {
      type: 'flag',
      content: line,
      metadata: {
        flag: flagMatch[1]
      }
    };
  }

  // Regular output
  return { type: 'output', content: line };
}

export function parseAllLines(output: string): ParsedLine[] {
  return output.split('\n').map(parseTerminalLine);
}

export function extractCurrentStage(parsedLines: ParsedLine[]): {
  stageNumber: number;
  stageTitle: string;
  command: string;
} {
  let currentStage = {
    stageNumber: 0,
    stageTitle: '',
    command: ''
  };

  // Find the most recent stage header and command
  for (let i = parsedLines.length - 1; i >= 0; i--) {
    const line = parsedLines[i];

    if (line.type === 'stage-header' && !currentStage.stageTitle) {
      currentStage.stageNumber = line.metadata?.stageNumber || 0;
      currentStage.stageTitle = line.metadata?.stageTitle || '';
    }

    if (line.type === 'command-start' && !currentStage.command) {
      currentStage.command = line.metadata?.command || '';
    }

    if (currentStage.stageTitle && currentStage.command) {
      break;
    }
  }

  return currentStage;
}

export function countTotalStages(output: string): number {
  const matches = output.match(/STAGE \d+:/g);
  if (!matches) return 0;

  const stageNumbers = matches.map(m => {
    const num = m.match(/\d+/);
    return num ? parseInt(num[0]) : 0;
  });

  return Math.max(...stageNumbers, 0);
}
