#!/bin/sh
# VulnApp v2.0 - Entrypoint Script
# Starts shell2http with all 24 attack scenarios mapped

set -e -o pipefail

cd /home/eval

# Mark as CrowdStrike test container
echo "=================================================="
echo "  VulnApp v2.0 - Container Security Testing"
echo "  CrowdStrike - Falcon Detection Validation"
echo "=================================================="
echo ""
echo "Starting VulnApp with 24 attack scenarios..."
echo "Port: 80"
echo "Frontend: http://localhost/"
echo "API: http://localhost/api/"
echo ""

# Execute shell2http with all attack routes
exec /shell2http -port 80 -show-errors -include-stderr -no-index \
    /ps "ps aux" \
    \
    `# ========== EXISTING ATTACKS (12) ==========` \
    \
    /defense-evasion-rootkit ./bin/existing/Defense_Evasion_via_Rootkit.sh \
    /defense-evasion-masquerading ./bin/existing/Defense_Evasion_via_Masquerading.sh \
    /exfiltration-alternative-protocol ./bin/existing/Exfiltration_via_Exfiltration_Over_Alternative_Protocol.sh \
    /command-control-remote-access ./bin/existing/Command_Control_via_Remote_Access.sh \
    /command-control-obfuscated ./bin/existing/Command_Control_via_Remote_Access-obfuscated.sh \
    /credential-access-dumping ./bin/existing/Credential_Access_via_Credential_Dumping.sh \
    /collection-automated ./bin/existing/Collection_via_Automated_Collection.sh \
    /execution-cli ./bin/existing/Execution_via_Command-Line_Interface.sh \
    /reverse-shell-trojan ./bin/existing/Reverse_Shell_Trojan.sh \
    /container-drift-file-creation ./bin/existing/ContainerDrift_Via_File_Creation_and_Execution.sh \
    /malware-linux-trojan-local ./bin/existing/Malware_Linux_Trojan_Local.sh \
    /malware-linux-trojan-remote ./bin/existing/Malware_Linux_Trojan_Remote.sh \
    \
    `# ========== MODERN THREATS (12) ==========` \
    \
    /docker-socket-exploitation ./bin/modern/Docker_Socket_Exploitation.sh \
    /privileged-container-escape ./bin/modern/Privileged_Container_Escape.sh \
    /cap-sys-admin-abuse ./bin/modern/CAP_SYS_ADMIN_Abuse.sh \
    /cap-sys-ptrace-injection ./bin/modern/CAP_SYS_PTRACE_Injection.sh \
    /cap-dac-read-search-bypass ./bin/modern/CAP_DAC_READ_SEARCH_Bypass.sh \
    /hostpath-volume-backdoor ./bin/modern/HostPath_Volume_Backdoor.sh \
    /service-account-token-theft ./bin/modern/Service_Account_Token_Theft.sh \
    /daemonset-persistence ./bin/modern/DaemonSet_Persistence.sh \
    /namespace-escape-nsenter ./bin/modern/Namespace_Escape_nsenter.sh \
    /seccomp-profile-bypass ./bin/modern/Seccomp_Profile_Bypass.sh \
    /image-supply-chain-poison ./bin/modern/Image_Supply_Chain_Poison.sh \
    /cve-2019-5736-runc-escape ./bin/modern/CVE_2019_5736_runc_Escape.sh
