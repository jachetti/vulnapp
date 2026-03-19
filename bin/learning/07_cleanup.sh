#!/bin/bash
# Cleanup Script for Scenario 7: Defense Evasion

set -e

echo "[CLEANUP] Removing defense evasion artifacts..."

rm -rf /tmp/.system_files 2>/dev/null || true
rm -f /tmp/.legitimate_process 2>/dev/null || true
rm -f /tmp/svchost.exe 2>/dev/null || true
rm -f /tmp/chrome.exe 2>/dev/null || true

echo "[CLEANUP] ✓ Defense evasion cleanup complete"
