#!/bin/bash
# Cleanup Script for Scenario 6: Full Attack Chain

set -e

echo "[CLEANUP] Removing attack chain artifacts..."

rm -rf /var/www/html/vulnerable.php 2>/dev/null || true
rm -rf /tmp/.stage2 2>/dev/null || true
rm -rf /tmp/.final_flag 2>/dev/null || true

if [ -d /host ]; then
    rm -rf /host/tmp/vulnapp_chain 2>/dev/null || true
fi

echo "[CLEANUP] ✓ Attack chain cleanup complete"
