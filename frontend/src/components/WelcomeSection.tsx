export function WelcomeSection() {
  return (
    <div className="bg-cs-dark border border-cs-darker rounded-lg p-6 mb-6">
      <h2 className="text-cs-white text-xl font-semibold mb-3">
        Welcome to VulnApp v2.0
      </h2>
      <p className="text-cs-gray mb-4">
        An intentionally vulnerable container application for testing CrowdStrike Falcon sensor detection
        capabilities. This platform demonstrates 24 attack scenarios mapped to the MITRE ATT&CK framework.
      </p>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
        <div className="flex items-start gap-2">
          <span className="text-cs-red text-xl">⚠️</span>
          <div>
            <div className="text-cs-white font-semibold">Training Purpose Only</div>
            <div className="text-cs-gray text-xs">
              Use only in isolated lab environments
            </div>
          </div>
        </div>
        <div className="flex items-start gap-2">
          <span className="text-cs-info text-xl">🎯</span>
          <div>
            <div className="text-cs-white font-semibold">24 Attack Scenarios</div>
            <div className="text-cs-gray text-xs">
              12 classic + 12 modern container threats
            </div>
          </div>
        </div>
        <div className="flex items-start gap-2">
          <span className="text-cs-success text-xl">🛡️</span>
          <div>
            <div className="text-cs-white font-semibold">MITRE ATT&CK Mapped</div>
            <div className="text-cs-gray text-xs">
              Complete technique coverage
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
