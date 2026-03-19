#!/bin/bash
# Cleanup Script for Scenario 2: Process Discovery

set -e

echo "[CLEANUP] Removing discovery artifacts..."

if [ -f /tmp/.discovery_pid ]; then
    kill -9 $(cat /tmp/.discovery_pid) 2>/dev/null || true
    rm /tmp/.discovery_pid
fi

echo "[CLEANUP] ✓ Process discovery cleanup complete"
