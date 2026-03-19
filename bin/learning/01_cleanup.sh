#!/bin/bash
# Cleanup Script for Scenario 1: Remote Access Shell

set -e

echo "[CLEANUP] Removing scenario artifacts..."

# Kill fake admin process
if [ -f /tmp/.vulnapp_flags/admin_pid ]; then
    ADMIN_PID=$(cat /tmp/.vulnapp_flags/admin_pid)
    kill -9 $ADMIN_PID 2>/dev/null || true
    rm /tmp/.vulnapp_flags/admin_pid
fi

# Remove flag files
rm -rf /tmp/.vulnapp_flags 2>/dev/null || true

echo "[CLEANUP] ✓ Scenario cleanup complete"
