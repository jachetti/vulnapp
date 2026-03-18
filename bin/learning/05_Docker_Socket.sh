#!/bin/bash
# Learning Scenario 5: Docker Socket Exploitation
# CTF FLAG: FLAG{docker_socket_gives_root_access_to_everything}
# Points: 150

set +e
echo "════════════════════════════════════════════════════════════════"
echo "  🎯 LEARNING SCENARIO 5: Docker Socket Exploitation"
echo "  From Container → Root on Host in 30 Seconds"
echo "  CTF Points: 150 | Difficulty: ★★★☆☆"
echo "════════════════════════════════════════════════════════════════"
echo ""

echo "📚 CONCEPT: The Docker Socket Shortcut to Host"
echo ""
echo "ENDPOINT PARALLEL:"
echo "  Like finding domain admin credentials sitting on a workstation"
echo ""
echo "CONTAINER VERSION:"
echo "  • Docker socket = API to control Docker engine"
echo "  • If mounted in container → attacker can control Docker"
echo "  • Can spawn NEW privileged container with host filesystem"
echo "  • Instant root access to host"
echo ""
echo "Real example: Tesla cryptomining attack used this method"
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 1: Checking for Docker Socket"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
if [ -S /var/run/docker.sock ]; then
    echo "🎯 JACKPOT: Docker socket is mounted!"
    ls -la /var/run/docker.sock
    echo ""
    echo "    SE Explanation to customer:"
    echo "    'This is like leaving your datacenter keys in the lobby.'"
else
    echo "✓ Socket not found (simulating for educational purposes)"
    echo ""
    echo "In a real attack, attacker would run:"
    echo "  docker run -v /:/host -it alpine chroot /host"
    echo ""
    echo "This command:"
    echo "  1. Starts new container"
    echo "  2. Mounts host root (/) to /host in container"
    echo "  3. Uses chroot to make /host the new root"
    echo "  4. Boom - attacker is on host with root"
fi
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 CTF CHALLENGE: Capture the Flag"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Congratulations! You've learned about Docker socket exploitation."
echo ""
echo "🚩 FLAG{docker_socket_gives_root_access_to_everything}"
echo "   Points: 150"
echo ""
echo "Hidden data revealed:"
cat << 'SECRETDATA'

╔════════════════════════════════════════════════════════════╗
║                   SIMULATED STOLEN DATA                     ║
╠════════════════════════════════════════════════════════════╣
║ /etc/shadow (password hashes)                              ║
║ root:$6$rounds=656000$...                                  ║
║                                                            ║
║ /root/.ssh/id_rsa (SSH private keys)                      ║
║ -----BEGIN RSA PRIVATE KEY-----                           ║
║ MIIEpAIBAAKCAQEA...                                       ║
║                                                            ║
║ /var/log/audit.log (all system activity)                  ║
║ Docker credentials, API keys, everything...               ║
╚════════════════════════════════════════════════════════════╝

SECRETDATA
echo ""
sleep 2

bash crowdstrike_test_high 2>/dev/null || true

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SUMMARY"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "CUSTOMER TALKING POINTS:"
echo ""
echo "'Why do developers mount the Docker socket?'"
echo "→ Convenience. Docker-in-Docker workflows, CI/CD pipelines"
echo ""
echo "'How common is this?'"
echo "→ 10-15% of containers in production have socket mounted"
echo ""
echo "'What's the risk?'"
echo "→ Complete compromise. One container = entire infrastructure"
echo ""
echo "🚩 Flag: FLAG{docker_socket_gives_root_access_to_everything}"
echo "🎯 Next: Kubernetes API Exploitation"
echo ""
echo "════════════════════════════════════════════════════════════════"
