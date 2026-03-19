export function WelcomeSection() {
  return (
    <div className="bg-cs-dark border border-cs-darker rounded-lg p-6 mb-6">
      <h2 className="text-cs-white text-xl font-semibold mb-3">
        Welcome to VulnApp v2.0 - Real Exploitation Edition
      </h2>
      <p className="text-cs-gray mb-4">
        An intentionally vulnerable container application with <span className="text-cs-red font-semibold">REAL EXPLOITATION</span>.
        Complete all 7 teaching scenarios through authentic reconnaissance and attack techniques to earn 1,000 points and achieve Container Security SE Certification.
      </p>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
        <div className="flex items-start gap-2">
          <span className="text-cs-red text-xl">🔥</span>
          <div>
            <div className="text-cs-white font-semibold">Real Exploitation</div>
            <div className="text-cs-gray text-xs">
              Discover flags through actual reconnaissance
            </div>
          </div>
        </div>
        <div className="flex items-start gap-2">
          <span className="text-cs-red text-xl">🚩</span>
          <div>
            <div className="text-cs-white font-semibold">7 Teaching Scenarios</div>
            <div className="text-cs-gray text-xs">
              Progressive lessons = 1,000 points
            </div>
          </div>
        </div>
        <div className="flex items-start gap-2">
          <span className="text-cs-success text-xl">🏆</span>
          <div>
            <div className="text-cs-white font-semibold">Earn Certification</div>
            <div className="text-cs-gray text-xs">
              Complete all scenarios for SE badge
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
