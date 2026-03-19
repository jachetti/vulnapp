#!/bin/bash
# Setup Script for Scenario 5: Persistence
# Prepares writable locations for backdoor installation

set -e

echo "[SETUP] Preparing Persistence scenario..."

# Create writable cron directory (simulating misconfigured container)
mkdir -p /tmp/.cron_backup
mkdir -p /tmp/.startup_scripts

# If we have host access, create writable location there too
if [ -d /host ]; then
    mkdir -p /host/tmp/vulnapp_persistence
    chmod 777 /host/tmp/vulnapp_persistence
    echo "[SETUP] ✓ Writable host location created for persistence"
fi

# Plant flag that will be revealed after successful backdoor installation
echo "FLAG{backdoors_established_attacker_can_return_anytime}" > /tmp/.persistence_flag
chmod 600 /tmp/.persistence_flag

echo "[SETUP] ✓ Persistence targets prepared"
echo "[SETUP] ✓ Flag will be revealed after successful backdoor installation"
echo "[SETUP] Ready for exploitation!"
