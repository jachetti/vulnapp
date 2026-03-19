export function Header() {
  return (
    <header className="bg-cs-darker border-b border-cs-dark">
      <div className="container mx-auto px-4 py-4">
        <div className="flex items-center gap-4">
          <img
            src="/images/logo_crowdstrike.png"
            alt="CrowdStrike"
            className="h-8"
          />
          <span className="text-cs-white text-2xl">|</span>
          <h1 className="text-cs-white text-2xl font-semibold">VulnApp</h1>
          <span className="ml-2 text-cs-gray text-sm font-mono">v2.0</span>
          <div className="ml-auto flex items-center gap-4">
            <span className="text-cs-gray text-sm">
              CTF Security Training Platform
            </span>
          </div>
        </div>
      </div>
    </header>
  );
}
