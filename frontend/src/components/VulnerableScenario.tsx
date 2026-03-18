import { useState } from 'react';
import { vulnerableAPI } from '../api/attacks';

export function VulnerableScenario() {
  const [attackerIP, setAttackerIP] = useState('');
  const [port, setPort] = useState('4444');
  const [result, setResult] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleReverseShell = async () => {
    if (!attackerIP) {
      setResult('Error: Please enter your attacker IP address');
      return;
    }

    setLoading(true);
    try {
      const response = await vulnerableAPI.reverseShell({ attacker_ip: attackerIP, port });
      setResult(JSON.stringify(response, null, 2));
    } catch (error) {
      setResult(`Error: ${error}`);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-cs-dark border border-cs-darker rounded-lg p-6 mb-6">
      <h2 className="text-cs-white text-xl font-semibold mb-4 flex items-center gap-2">
        <span className="text-cs-red">🎯</span>
        Interactive Attack: Reverse Shell
      </h2>

      <div className="space-y-4">
        {/* Instructions */}
        <div className="bg-cs-darker border border-cs-dark rounded p-4">
          <h3 className="text-cs-white font-semibold text-sm mb-2">Step 1: Setup Listener</h3>
          <p className="text-cs-gray text-sm mb-2">
            On your attacker machine (e.g., Kali Linux at 192.168.1.100), run:
          </p>
          <code className="block bg-black text-green-400 p-2 rounded font-mono text-sm">
            nc -lvnp {port}
          </code>
        </div>

        {/* Configuration */}
        <div className="bg-cs-darker border border-cs-dark rounded p-4">
          <h3 className="text-cs-white font-semibold text-sm mb-3">
            Step 2: Configure Attack
          </h3>
          <div className="space-y-3">
            <div>
              <label className="block text-cs-gray text-sm mb-1">
                Attacker IP Address:
              </label>
              <input
                type="text"
                value={attackerIP}
                onChange={(e) => setAttackerIP(e.target.value)}
                placeholder="192.168.1.100"
                className="w-full bg-cs-darker border border-cs-dark rounded px-3 py-2 text-cs-white focus:border-cs-red focus:outline-none"
              />
            </div>
            <div>
              <label className="block text-cs-gray text-sm mb-1">Port:</label>
              <input
                type="text"
                value={port}
                onChange={(e) => setPort(e.target.value)}
                placeholder="4444"
                className="w-full bg-cs-darker border border-cs-dark rounded px-3 py-2 text-cs-white focus:border-cs-red focus:outline-none"
              />
            </div>
          </div>
        </div>

        {/* Execute */}
        <div className="bg-cs-darker border border-cs-dark rounded p-4">
          <h3 className="text-cs-white font-semibold text-sm mb-3">Step 3: Execute</h3>
          <button
            onClick={handleReverseShell}
            disabled={loading || !attackerIP}
            className="bg-cs-red hover:bg-cs-red/80 disabled:bg-cs-gray disabled:cursor-not-allowed text-cs-white px-6 py-2 rounded font-semibold transition-colors"
          >
            {loading ? '⟳ Executing...' : '🚀 Launch Exploitation Chain'}
          </button>
        </div>

        {/* Result */}
        {result && (
          <div className="bg-cs-darker border border-cs-dark rounded p-4">
            <h3 className="text-cs-white font-semibold text-sm mb-2">Result:</h3>
            <pre className="bg-black text-green-400 p-3 rounded font-mono text-xs overflow-x-auto">
              {result}
            </pre>
            <p className="text-cs-gray text-sm mt-3">
              ✓ Check your netcat listener for the incoming reverse shell connection!
            </p>
          </div>
        )}

        {/* Warning */}
        <div className="bg-red-500/10 border border-red-500/30 rounded p-4">
          <p className="text-red-400 text-sm flex items-start gap-2">
            <span>⚠️</span>
            <span>
              <strong>Warning:</strong> This endpoint is intentionally vulnerable for training
              purposes. Only use in isolated lab environments with proper network segmentation.
            </span>
          </p>
        </div>
      </div>
    </div>
  );
}
