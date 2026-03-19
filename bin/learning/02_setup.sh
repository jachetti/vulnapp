#!/bin/bash
# Setup Script for Scenario 2: Process Discovery
# Plants flag in a hidden process

set -e

echo "[SETUP] Preparing Process Discovery scenario..."

# Create fake process with flag in command line
nohup bash -c 'sleep 3600 # SECRET_TOKEN=FLAG{discovered_container_boundaries_and_limits}' > /dev/null 2>&1 &
SECRET_PID=$!
echo $SECRET_PID > /tmp/.discovery_pid

echo "[SETUP] ✓ Flag hidden in process command line (PID: $SECRET_PID)"
echo "[SETUP] ✓ Attacker must discover via ps/proc enumeration"
echo "[SETUP] Ready for exploitation!"
