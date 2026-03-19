#!/bin/bash
# Cleanup Script for Scenario 3: Data Theft

set -e

echo "[CLEANUP] Removing fake credentials and data..."

rm -rf /tmp/.app_secrets 2>/dev/null || true
rm -rf /tmp/exfil_data 2>/dev/null || true

echo "[CLEANUP] ✓ Data theft cleanup complete"
