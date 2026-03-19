#!/bin/bash
# Setup Script for Scenario 1: Remote Access Shell
# Plants flag in environment variable of a fake process

set -e

echo "[SETUP] Preparing Remote Access Shell scenario..."

# Create flag file in hidden location
mkdir -p /tmp/.vulnapp_flags
echo "FLAG{reverse_shell_works_same_in_containers}" > /tmp/.vulnapp_flags/scenario_01.flag
chmod 600 /tmp/.vulnapp_flags/scenario_01.flag

# Create fake "admin" process with flag in environment
nohup bash -c 'FLAG_CREDENTIAL="FLAG{reverse_shell_works_same_in_containers}" sleep 3600' > /dev/null 2>&1 &
ADMIN_PID=$!
echo $ADMIN_PID > /tmp/.vulnapp_flags/admin_pid

echo "[SETUP] ✓ Flag planted in process environment (PID: $ADMIN_PID)"
echo "[SETUP] ✓ Attacker must discover flag via process enumeration"
echo "[SETUP] Ready for exploitation!"
