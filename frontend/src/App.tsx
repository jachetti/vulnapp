import { useEffect, useState } from 'react';
import type { AttackScenario, AttacksResponse, Execution } from './types/attack.types';
import { attacksAPI } from './api/attacks';
import { Header } from './components/Header';
import { ProgressHeader } from './components/ProgressHeader';
import { WelcomeSection } from './components/WelcomeSection';
import { AttackGrid } from './components/AttackGrid';
import { ExecutionPanel } from './components/ExecutionPanel';
import { VulnerableScenario } from './components/VulnerableScenario';

function App() {
  const [attacks, setAttacks] = useState<AttacksResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedAttack, setSelectedAttack] = useState<AttackScenario | null>(null);
  const [currentExecution, setCurrentExecution] = useState<Execution | null>(null);
  const [showVulnerable, setShowVulnerable] = useState(false);

  // Load attacks on mount
  useEffect(() => {
    loadAttacks();
  }, []);

  const loadAttacks = async () => {
    try {
      setLoading(true);
      const data = await attacksAPI.getAll();
      setAttacks(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load attacks');
    } finally {
      setLoading(false);
    }
  };

  const handleExecuteAttack = async (attack: AttackScenario) => {
    try {
      // Execute the attack
      const response = await attacksAPI.execute(attack.id);

      // Create execution object
      const execution: Execution = {
        id: response.execution_id,
        attack_id: response.attack_id,
        status: response.status,
        output: '',
        exit_code: 0,
        start_time: response.start_time,
      };

      setSelectedAttack(attack);
      setCurrentExecution(execution);
    } catch (err) {
      alert(`Failed to execute attack: ${err instanceof Error ? err.message : 'Unknown error'}`);
    }
  };

  const handleCloseExecution = () => {
    setSelectedAttack(null);
    setCurrentExecution(null);
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-cs-darker flex items-center justify-center">
        <div className="text-cs-white text-xl flex items-center gap-3">
          <span className="animate-spin text-2xl">⟳</span>
          Loading VulnApp...
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-cs-darker flex items-center justify-center">
        <div className="bg-cs-dark border border-red-500/30 rounded-lg p-6 max-w-md">
          <h2 className="text-red-400 text-xl font-semibold mb-2">Error</h2>
          <p className="text-cs-gray mb-4">{error}</p>
          <button
            onClick={loadAttacks}
            className="bg-cs-red hover:bg-cs-red/80 text-cs-white px-4 py-2 rounded font-semibold"
          >
            Retry
          </button>
        </div>
      </div>
    );
  }

  if (!attacks) {
    return null;
  }

  return (
    <div className="min-h-screen bg-cs-darker">
      <Header />
      <ProgressHeader />

      <main className="container mx-auto px-4 py-8">
        <WelcomeSection />

        {/* Toggle for Vulnerable Scenario */}
        <div className="mb-6 flex items-center gap-4">
          <button
            onClick={() => setShowVulnerable(!showVulnerable)}
            className={`px-4 py-2 rounded font-semibold transition-colors ${
              showVulnerable
                ? 'bg-cs-red text-cs-white'
                : 'bg-cs-dark text-cs-gray hover:bg-cs-dark/80'
            }`}
          >
            {showVulnerable ? '← Back to Attacks' : '🎯 Interactive Reverse Shell'}
          </button>
        </div>

        {showVulnerable ? (
          <VulnerableScenario />
        ) : (
          <>
            <div className="mb-6">
              <h2 className="text-cs-white text-2xl font-semibold mb-2">
                Attack Scenarios
              </h2>
              <p className="text-cs-gray text-sm">
                Select an attack to execute and view real-time output. All attacks are mapped to
                MITRE ATT&CK techniques.
              </p>
            </div>

            <AttackGrid categories={attacks.categories} onExecute={handleExecuteAttack} />
          </>
        )}
      </main>

      {/* Execution Panel Modal */}
      {selectedAttack && currentExecution && (
        <ExecutionPanel
          attack={selectedAttack}
          execution={currentExecution}
          onClose={handleCloseExecution}
        />
      )}

      {/* Footer */}
      <footer className="border-t border-cs-dark py-6 mt-12">
        <div className="container mx-auto px-4 text-center text-cs-gray text-sm">
          <p>
            VulnApp v2.0 - CrowdStrike Container Security Testing Platform
          </p>
          <p className="mt-1 text-xs">
            ⚠️ For training and testing purposes only. Use in isolated environments.
          </p>
        </div>
      </footer>
    </div>
  );
}

export default App;
