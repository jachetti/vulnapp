#!/bin/bash
# Setup Script for Scenario 4: Container Escape
# Plants flag on host filesystem (requires hostPath mount)

set -e

echo "[SETUP] Preparing Container Escape scenario..."

# Check if we have host access
if [ -d /host ]; then
    # Plant flag on host filesystem
    mkdir -p /host/tmp/vulnapp_escape
    echo "FLAG{container_isolation_bypassed_welcome_to_host}" > /host/tmp/vulnapp_escape/.secret_flag
    chmod 644 /host/tmp/vulnapp_escape/.secret_flag

    echo "[SETUP] ✓ Flag planted on host at: /host/tmp/vulnapp_escape/.secret_flag"
    echo "[SETUP] ✓ Attacker must escape container to read flag"

    # Also plant flag in a location accessible via cgroup escape
    mkdir -p /host/tmp/vulnapp_cgroup
    echo "#!/bin/sh" > /host/tmp/vulnapp_cgroup/read_flag.sh
    echo "cat /tmp/vulnapp_escape/.secret_flag" >> /host/tmp/vulnapp_cgroup/read_flag.sh
    chmod +x /host/tmp/vulnapp_cgroup/read_flag.sh

    echo "[SETUP] ✓ Escape helper planted for cgroup method"
else
    echo "[SETUP] ⚠️  No /host mount detected - using fallback mode"
    echo "[SETUP] ⚠️  Real escape won't be possible, but detection will trigger"

    # Plant flag in alternate location
    mkdir -p /tmp/.host_flag
    echo "FLAG{container_isolation_bypassed_welcome_to_host}" > /tmp/.host_flag/flag.txt
    chmod 644 /tmp/.host_flag/flag.txt
fi

echo "[SETUP] Ready for exploitation!"
