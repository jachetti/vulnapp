#!/bin/bash
# Cleanup Script for Scenario 4: Container Escape

set -e

echo "[CLEANUP] Removing container escape artifacts..."

# Remove host-planted flags
if [ -d /host ]; then
    rm -rf /host/tmp/vulnapp_escape 2>/dev/null || true
    rm -rf /host/tmp/vulnapp_cgroup 2>/dev/null || true
    echo "[CLEANUP] ✓ Removed host flags"
fi

# Remove fallback flags
rm -rf /tmp/.host_flag 2>/dev/null || true

echo "[CLEANUP] ✓ Container escape cleanup complete"
