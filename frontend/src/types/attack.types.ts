// Attack Types
export interface MitreTechnique {
  id: string;
  name: string;
  description?: string;
}

export interface AttackScenario {
  id: string;
  name: string;
  category: string;
  description: string;
  script_path: string;
  mitre_tactics: string[];
  mitre_techniques: MitreTechnique[];
  severity: 'CRITICAL' | 'HIGH' | 'MEDIUM' | 'LOW';
  is_modern: boolean;
  cve?: string[];
  prerequisites?: string[];
}

export interface AttacksResponse {
  attacks: AttackScenario[];
  categories: Record<string, AttackScenario[]>;
  count: number;
}

// Execution Types
export type ExecutionStatus = 'running' | 'completed' | 'failed';

export interface Execution {
  id: string;
  attack_id: string;
  status: ExecutionStatus;
  output: string;
  exit_code: number;
  start_time: string;
  end_time?: string;
  duration?: string;
}

export interface ExecuteResponse {
  execution_id: string;
  attack_id: string;
  status: ExecutionStatus;
  start_time: string;
}

// WebSocket Message Types
export interface WebSocketMessage {
  type: 'started' | 'output' | 'status' | 'completed' | 'error';
  execution_id?: string;
  attack_id?: string;
  line?: string;
  status?: ExecutionStatus;
  exit_code?: number;
  duration?: string;
  message?: string;
}

// System Info Types
export interface SystemInfo {
  hostname: string;
  os: string;
  arch: string;
  go_version: string;
  timestamp: string;
}

// Vulnerable Endpoint Types
export interface ReverseShellRequest {
  attacker_ip: string;
  port: string;
}

export interface ReverseShellResponse {
  status: string;
  target: string;
  payload: string;
  message: string;
}
