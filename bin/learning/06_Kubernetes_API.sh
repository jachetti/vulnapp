#!/bin/bash
# Learning Scenario 6: Kubernetes Service Account Token Theft
# CTF FLAG: FLAG{kubernetes_token_equals_cluster_admin_oops}
# Points: 200

set +e
echo "════════════════════════════════════════════════════════════════"
echo "  🎯 LEARNING SCENARIO 6: Kubernetes API Exploitation"
echo "  Cloud-Native Lateral Movement"
echo "  CTF Points: 200 | Difficulty: ★★★★☆"
echo "════════════════════════════════════════════════════════════════"
echo ""

echo "📚 CONCEPT: Kubernetes Service Account Tokens"
echo ""
echo "ENDPOINT PARALLEL:"
echo "  Like every process on Windows having a copy of domain credentials"
echo ""
echo "K8S REALITY:"
echo "  • Every pod gets service account token automatically"
echo "  • Token = credentials to Kubernetes API"
echo "  • Often over-permissioned (more access than needed)"
echo "  • Attacker steals token → controls entire cluster"
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 1: Token Discovery"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
if [ -f /var/run/secrets/kubernetes.io/serviceaccount/token ]; then
    echo "🎯 Kubernetes token found!"
    echo ""
    echo "Token location: /var/run/secrets/kubernetes.io/serviceaccount/token"
    echo "Namespace: $(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>/dev/null || echo 'default')"
    echo ""
    echo "Token preview (first 50 chars):"
    cat /var/run/secrets/kubernetes.io/serviceaccount/token | cut -c1-50
    echo "..."
    echo ""
    echo "    SE Explanation:"
    echo "    'Every Kubernetes pod gets these automatically. It's like"
    echo "     giving every application on your network domain credentials."
    echo "     The token allows API calls to Kubernetes.'"
else
    echo "[Simulated] In real Kubernetes pod, token would be here"
    echo ""
    echo "With this token, attacker can:"
    echo "  • kubectl get pods --all-namespaces"
    echo "  • kubectl get secrets"
    echo "  • kubectl create deployment malware ..."
    echo "  • kubectl exec -it other-pod -- /bin/bash"
fi
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STAGE 2: Simulated API Abuse"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Attacker uses stolen token to:"
echo ""
echo "1. List all pods in cluster:"
echo "   → Discovers database pods, admin pods, payment processing"
echo ""
echo "2. Read secrets from other namespaces:"
echo "   → Database passwords, API keys, certificates"
echo ""
echo "3. Deploy malicious pod:"
echo "   → Cryptominer, backdoor, data exfil pod"
echo ""
echo "4. Lateral movement:"
echo "   → Exec into other pods, steal more credentials"
echo ""
sleep 2

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 CTF CHALLENGE: Kubernetes Compromise"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚩 FLAG{kubernetes_token_equals_cluster_admin_oops}"
echo "   Points: 200 (Cloud-Native Expert!)"
echo ""
echo "Stolen Kubernetes Secrets:"
cat << 'K8SSECRETS'

╔════════════════════════════════════════════════════════════╗
║              KUBERNETES CLUSTER COMPROMISE                  ║
╠════════════════════════════════════════════════════════════╣
║ • Database passwords from prod namespace                    ║
║ • TLS certificates for all services                        ║
║ • AWS credentials from CI/CD pod                           ║
║ • Admin kubeconfig file                                    ║
║ • 47 pods accessible for lateral movement                  ║
║ • Full cluster admin achieved                              ║
╚════════════════════════════════════════════════════════════╝

K8SSECRETS
echo ""
sleep 2

bash crowdstrike_test_high 2>/dev/null || true

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  LEARNING SUMMARY"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "THIS IS THE #1 KUBERNETES ATTACK VECTOR!"
echo ""
echo "Customer questions:"
echo ""
echo "Q: 'Can't we just not give pods tokens?'"
echo "A: 'Kubernetes requires them for basic functionality. The fix"
echo "    is RBAC - least privilege. Most customers give pods way"
echo "    too much access. Falcon helps audit this.'"
echo ""
echo "Q: 'How would we know if this is happening?'"
echo "A: 'Without Falcon, you wouldn't. No malware to detect. Just"
echo "    legitimate API calls. Falcon's behavior detection sees the"
echo "    suspicious pattern of a pod accessing things it shouldn't.'"
echo ""
echo "🚩 Flag: FLAG{kubernetes_token_equals_cluster_admin_oops}"
echo "🎯 Next: Full Attack Chain Demo"
echo ""
echo "════════════════════════════════════════════════════════════════"
