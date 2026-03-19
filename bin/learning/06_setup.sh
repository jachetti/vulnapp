#!/bin/bash
# Setup Script for Scenario 7: Defense Evasion
# Plants flag accessible only through masqueraded process

set -e

echo "[SETUP] Preparing Defense Evasion scenario..."

# Create "privileged" directory that requires special access
mkdir -p /tmp/.system_files
echo "FLAG{svchost_exe_on_linux_fooled_nobody}" > /tmp/.system_files/system.dat
chmod 644 /tmp/.system_files/system.dat

# Create fake "legitimate" process that can access the flag
echo '#!/bin/bash' > /tmp/.legitimate_process
echo 'cat /tmp/.system_files/system.dat' >> /tmp/.legitimate_process
chmod +x /tmp/.legitimate_process

echo "[SETUP] ✓ Flag planted in system files"
echo "[SETUP] ✓ Attacker must use masquerading to access"
echo "[SETUP] Ready for exploitation!"
