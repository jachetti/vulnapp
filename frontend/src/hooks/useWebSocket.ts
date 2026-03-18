import { useEffect, useRef, useState } from 'react';
import type { WebSocketMessage, ExecutionStatus } from '../types/attack.types';

interface UseWebSocketReturn {
  isConnected: boolean;
  output: string[];
  status: ExecutionStatus | null;
  exitCode: number | null;
  duration: string | null;
  error: string | null;
}

export function useWebSocket(url: string | null): UseWebSocketReturn {
  const [isConnected, setIsConnected] = useState(false);
  const [output, setOutput] = useState<string[]>([]);
  const [status, setStatus] = useState<ExecutionStatus | null>(null);
  const [exitCode, setExitCode] = useState<number | null>(null);
  const [duration, setDuration] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const wsRef = useRef<WebSocket | null>(null);

  useEffect(() => {
    if (!url) return;

    const ws = new WebSocket(url);
    wsRef.current = ws;

    ws.onopen = () => {
      setIsConnected(true);
      setError(null);
    };

    ws.onmessage = (event) => {
      try {
        const message: WebSocketMessage = JSON.parse(event.data);

        switch (message.type) {
          case 'started':
            setStatus('running');
            break;

          case 'output':
            if (message.line) {
              setOutput((prev) => [...prev, message.line!]);
            }
            break;

          case 'status':
            if (message.status) {
              setStatus(message.status);
            }
            if (message.exit_code !== undefined) {
              setExitCode(message.exit_code);
            }
            if (message.duration) {
              setDuration(message.duration);
            }
            break;

          case 'completed':
            setStatus(message.status || 'completed');
            if (message.exit_code !== undefined) {
              setExitCode(message.exit_code);
            }
            if (message.duration) {
              setDuration(message.duration);
            }
            break;

          case 'error':
            setError(message.message || 'Unknown error');
            break;
        }
      } catch (err) {
        console.error('Failed to parse WebSocket message:', err);
      }
    };

    ws.onerror = (event) => {
      console.error('WebSocket error:', event);
      setError('WebSocket connection error');
    };

    ws.onclose = () => {
      setIsConnected(false);
    };

    return () => {
      if (ws.readyState === WebSocket.OPEN) {
        ws.close();
      }
    };
  }, [url]);

  return {
    isConnected,
    output,
    status,
    exitCode,
    duration,
    error,
  };
}
