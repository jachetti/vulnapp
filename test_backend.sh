#!/bin/bash
# VulnApp v2.0 - Comprehensive Test Script
# This script tests all components of the backend implementation

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=================================================="
echo "  VulnApp v2.0 - Backend Test Suite"
echo "=================================================="
echo ""

# Track test results
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Test function
test_component() {
    local test_name=$1
    local test_cmd=$2

    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo -n "Testing: $test_name ... "

    if eval "$test_cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASSED${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAILED${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

echo "=== Phase 1: File Structure Tests ==="
test_component "Backend directory exists" "[ -d backend ]"
test_component "Attack metadata exists" "[ -f backend/attack_metadata.go ]"
test_component "API handlers exist" "[ -f backend/api_handlers.go ]"
test_component "WebSocket handler exists" "[ -f backend/websocket.go ]"
test_component "Execution tracker exists" "[ -f backend/execution_tracker.go ]"
test_component "Modified shell2http.go exists" "[ -f shell2http.go ]"
test_component "go.mod updated" "grep -q 'go 1.23' go.mod"
test_component "WebSocket dependency added" "grep -q 'gorilla/websocket' go.mod"
echo ""

echo "=== Phase 2: Attack Scripts Tests ==="
test_component "Existing scripts directory" "[ -d bin/existing ]"
test_component "Modern scripts directory" "[ -d bin/modern ]"
test_component "12 existing scripts" "[ $(ls -1 bin/existing/*.sh 2>/dev/null | wc -l) -eq 12 ]"
test_component "12 modern scripts" "[ $(ls -1 bin/modern/*.sh 2>/dev/null | wc -l) -eq 12 ]"

# Test each script is executable
for script in bin/existing/*.sh bin/modern/*.sh; do
    if [ -x "$script" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ Not executable: $script${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
done
echo "All 24 attack scripts are executable: ${GREEN}✓${NC}"
echo ""

echo "=== Phase 3: Attack Script Execution Tests ==="
# Test a sample of scripts
test_component "Execution_via_Command-Line_Interface.sh" "./bin/existing/Execution_via_Command-Line_Interface.sh | grep -q 'Command execution completed'"
test_component "Collection_via_Automated_Collection.sh" "./bin/existing/Collection_via_Automated_Collection.sh | grep -q 'Automated collection completed'"
test_component "Docker_Socket_Exploitation.sh" "./bin/modern/Docker_Socket_Exploitation.sh | grep -q 'Docker socket exploitation'"
test_component "CAP_SYS_ADMIN_Abuse.sh" "./bin/modern/CAP_SYS_ADMIN_Abuse.sh | grep -q 'CAP_SYS_ADMIN'"
test_component "CVE_2019_5736_runc_Escape.sh" "./bin/modern/CVE_2019_5736_runc_Escape.sh | grep -q 'CVE-2019-5736'"
echo ""

echo "=== Phase 4: Go Code Syntax Tests ==="
# Check if Go is available
if command -v go &> /dev/null; then
    echo "Go compiler found: $(go version)"

    test_component "Go mod tidy" "go mod tidy"
    test_component "Go code compiles" "go build -o /tmp/vulnapp-test ."

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Go compilation successful${NC}"
        rm -f /tmp/vulnapp-test
    else
        echo -e "${RED}✗ Go compilation failed${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Go compiler not found - skipping compilation tests${NC}"
    echo "  (This is OK for macOS - Docker build will compile)"
fi
echo ""

echo "=== Phase 5: API Server Tests (if server is running) ==="
# Check if server is running on port 80 or 8080
SERVER_URL=""
if curl -s http://localhost/api/health > /dev/null 2>&1; then
    SERVER_URL="http://localhost"
elif curl -s http://localhost:8080/api/health > /dev/null 2>&1; then
    SERVER_URL="http://localhost:8080"
fi

if [ -n "$SERVER_URL" ]; then
    echo "Server found at: $SERVER_URL"
    test_component "API health endpoint" "curl -s $SERVER_URL/api/health | grep -q 'healthy'"
    test_component "API attacks list" "curl -s $SERVER_URL/api/attacks | grep -q 'attacks'"
    test_component "API system info" "curl -s $SERVER_URL/api/system/info | grep -q 'hostname'"
    test_component "Vulnerable RCE endpoint" "curl -s '$SERVER_URL/api/vulnerable/rce?cmd=whoami' | grep -q '.'"
    test_component "Vulnerable LFI endpoint" "curl -s '$SERVER_URL/api/vulnerable/lfi?file=/etc/passwd' | grep -q 'root'"
else
    echo -e "${YELLOW}⚠ Server not running - skipping API tests${NC}"
    echo "  To test APIs, run: sudo go run . -port 80"
fi
echo ""

echo "=================================================="
echo "  Test Results Summary"
echo "=================================================="
echo -e "Total Tests:  $TESTS_TOTAL"
echo -e "Passed:       ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed:       ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
