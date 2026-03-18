import type {
  AttacksResponse,
  AttackScenario,
  ExecuteResponse,
  Execution,
  SystemInfo,
  ReverseShellRequest,
  ReverseShellResponse,
} from '../types/attack.types';

const API_BASE = '/api';

// Helper function for API calls
async function apiCall<T>(endpoint: string, options?: RequestInit): Promise<T> {
  const response = await fetch(`${API_BASE}${endpoint}`, {
    headers: {
      'Content-Type': 'application/json',
      ...options?.headers,
    },
    ...options,
  });

  if (!response.ok) {
    throw new Error(`API Error: ${response.statusText}`);
  }

  return response.json();
}

// Attack APIs
export const attacksAPI = {
  // Get all attacks
  getAll: () => apiCall<AttacksResponse>('/attacks'),

  // Get specific attack by ID
  getById: (id: string) => apiCall<AttackScenario>(`/attacks/${id}`),

  // Execute attack
  execute: (id: string) =>
    apiCall<ExecuteResponse>(`/attacks/${id}/execute`, {
      method: 'POST',
    }),
};

// Execution APIs
export const executionsAPI = {
  // Get all executions
  getAll: () => apiCall<{ executions: Execution[]; count: number }>('/executions'),

  // Get specific execution
  getById: (id: string) => apiCall<Execution>(`/executions/${id}`),

  // Get WebSocket URL for streaming
  getStreamUrl: (id: string) => {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const host = window.location.host;
    return `${protocol}//${host}/api/executions/${id}/stream?execution_id=${id}`;
  },
};

// System APIs
export const systemAPI = {
  // Health check
  health: () => apiCall<{ status: string; timestamp: string }>('/health'),

  // System info
  info: () => apiCall<SystemInfo>('/system/info'),
};

// Vulnerable Endpoints (Training APIs)
export const vulnerableAPI = {
  // RCE endpoint
  rce: (cmd: string) => fetch(`${API_BASE}/vulnerable/rce?cmd=${encodeURIComponent(cmd)}`).then(r => r.text()),

  // LFI endpoint
  lfi: (file: string) => fetch(`${API_BASE}/vulnerable/lfi?file=${encodeURIComponent(file)}`).then(r => r.text()),

  // Reverse shell
  reverseShell: (request: ReverseShellRequest) =>
    apiCall<ReverseShellResponse>('/vulnerable/reverse-shell', {
      method: 'POST',
      body: JSON.stringify(request),
    }),

  // SQL injection
  sqli: (search: string) => apiCall<any>(`/vulnerable/sqli?search=${encodeURIComponent(search)}`),
};
