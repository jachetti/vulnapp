#!/bin/bash
# Cleanup Script for Scenario 5: Persistence

set -e

echo "[CLEANUP] Removing persistence artifacts..."

# Remove container backdoors
rm -rf /tmp/.cron_backup 2>/dev/null || true
rm -rf /tmp/.startup_scripts 2>/dev/null || true
rm -f /tmp/.persistence_flag 2>/dev/null || true
rm -f /tmp/backdoor.sh 2>/dev/null || true

# Remove host backdoors
if [ -d /host ]; then
    rm -rf /host/tmp/vulnapp_persistence 2>/dev/null || true
    # Remove any cron jobs we may have created
    crontab -l 2>/dev/null | grep -v "vulnapp" | crontab - 2>/dev/null || true
fi

echo "[CLEANUP] ✓ Persistence cleanup complete"
