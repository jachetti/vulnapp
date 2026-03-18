#!/bin/bash
# Validation script for GitHub deployment readiness
# Tests project structure, files, and configuration

echo "========================================="
echo "VulnApp v2.0 GitHub Readiness Validation"
echo "========================================="
echo ""

PASS=0
FAIL=0

check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1"
        PASS=$((PASS + 1))
    else
        echo "❌ $1 - MISSING"
        FAIL=$((FAIL + 1))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "✅ $1/"
        PASS=$((PASS + 1))
    else
        echo "❌ $1/ - MISSING"
        FAIL=$((FAIL + 1))
    fi
}

check_executable() {
    if [ -x "$1" ]; then
        echo "✅ $1 (executable)"
        PASS=$((PASS + 1))
    else
        echo "❌ $1 - NOT EXECUTABLE"
        FAIL=$((FAIL + 1))
    fi
}

echo "📋 Core Documentation Files"
echo "-------------------------------------------"
check_file "README.md"
check_file "LICENSE"
check_file "CONTRIBUTING.md"
check_file "GITHUB_DEPLOYMENT.md"
check_file ".gitignore"
echo ""

echo "🏗️  Build & Configuration Files"
echo "-------------------------------------------"
check_file "Dockerfile"
check_file "docker-compose.yml"
check_file "go.mod"
check_file "go.sum"
check_executable "entrypoint.sh"
check_executable "build-and-test.sh"
check_executable "test_backend.sh"
check_executable "test_api.sh"
echo ""

echo "🐳 Kubernetes/OpenShift Configs"
echo "-------------------------------------------"
check_file "vulnerable.example.yaml"
check_file "vulnerable.openshift.yaml"
echo ""

echo "🔧 Backend Files"
echo "-------------------------------------------"
check_file "shell2http.go"
check_file "config.go"
check_dir "backend"
check_file "backend/api_handlers.go"
check_file "backend/websocket.go"
check_file "backend/attack_metadata.go"
check_file "backend/execution_tracker.go"
echo ""

echo "💻 Frontend Files"
echo "-------------------------------------------"
check_dir "frontend"
check_file "frontend/package.json"
check_file "frontend/vite.config.ts"
check_file "frontend/tsconfig.json"
check_file "frontend/tailwind.config.js"
check_file "frontend/index.html"
check_dir "frontend/src"
check_file "frontend/src/App.tsx"
check_file "frontend/src/main.tsx"
check_dir "frontend/src/components"
check_dir "frontend/src/hooks"
check_dir "frontend/src/api"
check_dir "frontend/src/types"
echo ""

echo "⚔️  Attack Scripts - Existing (12)"
echo "-------------------------------------------"
check_dir "bin/existing"
check_executable "bin/existing/Defense_Evasion_via_Rootkit.sh"
check_executable "bin/existing/Defense_Evasion_via_Masquerading.sh"
check_executable "bin/existing/Exfiltration_via_Exfiltration_Over_Alternative_Protocol.sh"
check_executable "bin/existing/Command_Control_via_Remote_Access.sh"
check_executable "bin/existing/Command_Control_via_Remote_Access-obfuscated.sh"
check_executable "bin/existing/Credential_Access_via_Credential_Dumping.sh"
check_executable "bin/existing/Collection_via_Automated_Collection.sh"
check_executable "bin/existing/Execution_via_Command-Line_Interface.sh"
check_executable "bin/existing/Reverse_Shell_Trojan.sh"
check_executable "bin/existing/ContainerDrift_Via_File_Creation_and_Execution.sh"
check_executable "bin/existing/Malware_Linux_Trojan_Local.sh"
check_executable "bin/existing/Malware_Linux_Trojan_Remote.sh"
echo ""

echo "🚀 Attack Scripts - Modern (12)"
echo "-------------------------------------------"
check_dir "bin/modern"
check_executable "bin/modern/Docker_Socket_Exploitation.sh"
check_executable "bin/modern/Privileged_Container_Escape.sh"
check_executable "bin/modern/CAP_SYS_ADMIN_Abuse.sh"
check_executable "bin/modern/CAP_SYS_PTRACE_Injection.sh"
check_executable "bin/modern/CAP_DAC_READ_SEARCH_Bypass.sh"
check_executable "bin/modern/HostPath_Volume_Backdoor.sh"
check_executable "bin/modern/Service_Account_Token_Theft.sh"
check_executable "bin/modern/DaemonSet_Persistence.sh"
check_executable "bin/modern/Namespace_Escape_nsenter.sh"
check_executable "bin/modern/Seccomp_Profile_Bypass.sh"
check_executable "bin/modern/Image_Supply_Chain_Poison.sh"
check_executable "bin/modern/CVE_2019_5736_runc_Escape.sh"
echo ""

echo "🔄 CI/CD & GitHub Files"
echo "-------------------------------------------"
check_dir ".github"
check_dir ".github/workflows"
check_file ".github/workflows/build-and-test.yml"
echo ""

echo "🖼️  Static Assets"
echo "-------------------------------------------"
check_dir "images"
check_file "images/CrowdStrike_Signature_Lockup_Reversed.png"
echo ""

echo "📊 Code Quality Checks"
echo "-------------------------------------------"

# Check for hardcoded secrets patterns (basic check)
if grep -r "password\s*=\s*['\"]" --include="*.go" --include="*.sh" --include="*.ts" --include="*.tsx" . 2>/dev/null | grep -v "# password" | grep -v "example" > /dev/null; then
    echo "⚠️  WARNING: Potential hardcoded passwords found"
    FAIL=$((FAIL + 1))
else
    echo "✅ No obvious hardcoded passwords"
    PASS=$((PASS + 1))
fi

# Check Go mod is valid
if command -v go > /dev/null 2>&1; then
    if go mod verify > /dev/null 2>&1; then
        echo "✅ go.mod is valid"
        PASS=$((PASS + 1))
    else
        echo "❌ go.mod verification failed"
        FAIL=$((FAIL + 1))
    fi
else
    echo "⚠️  go.mod verification skipped (Go not in PATH)"
fi

# Check frontend package.json is valid JSON
if cat frontend/package.json | python3 -m json.tool > /dev/null 2>&1; then
    echo "✅ frontend/package.json is valid JSON"
    PASS=$((PASS + 1))
else
    echo "❌ frontend/package.json has JSON errors"
    FAIL=$((FAIL + 1))
fi

# Check Dockerfile exists and has multi-stage build
if grep -q "FROM.*AS.*builder" Dockerfile; then
    echo "✅ Dockerfile uses multi-stage build"
    PASS=$((PASS + 1))
else
    echo "❌ Dockerfile missing multi-stage build"
    FAIL=$((FAIL + 1))
fi

# Check if port 80 is used
if grep -q "port.*80" shell2http.go && grep -q "EXPOSE 80" Dockerfile; then
    echo "✅ Port 80 configured correctly"
    PASS=$((PASS + 1))
else
    echo "❌ Port 80 not configured properly"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "========================================="
echo "📈 Validation Summary"
echo "========================================="
echo "✅ Passed: $PASS"
echo "❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "🎉 SUCCESS: Project is ready for GitHub deployment!"
    echo ""
    echo "Next steps:"
    echo "1. Initialize git repository: git init"
    echo "2. Create GitHub repository"
    echo "3. Follow steps in GITHUB_DEPLOYMENT.md"
    exit 0
else
    echo "⚠️  WARNING: Some checks failed. Review issues above."
    echo "You may still proceed, but address failures before GitHub deployment."
    exit 1
fi
