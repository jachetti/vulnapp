export function WelcomeSection() {
  return (
    <div className="bg-cs-dark border border-cs-darker rounded-lg p-6 mb-6">
      <h2 className="text-cs-white text-xl font-semibold mb-3">
        Welcome to VulnApp v2.0 - Teaching Edition POC
      </h2>
      <p className="text-cs-gray mb-4">
        An intentionally vulnerable container application for hands-on security training.
        Complete all 7 teaching scenarios to earn 1,000 points and achieve Container Security SE Certification.
      </p>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
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
          <span className="text-cs-info text-xl">🎯</span>
          <div>
            <div className="text-cs-white font-semibold">Every Flag Counts</div>
            <div className="text-cs-gray text-xs">
              Capture flags from scenario outputs
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
