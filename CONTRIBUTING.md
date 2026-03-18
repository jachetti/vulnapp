# Contributing to VulnApp

Thank you for your interest in contributing to VulnApp! This document provides guidelines for contributing to the project.

## 🤝 How to Contribute

### Reporting Issues

1. **Search existing issues** to avoid duplicates
2. **Use issue templates** when available
3. **Provide detailed information:**
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, Docker version, etc.)
   - Logs and screenshots

### Suggesting Features

1. **Open a GitHub issue** with the `enhancement` label
2. **Describe the feature** and its use case
3. **Explain the value** to VulnApp users
4. **Consider implementation** complexity

### Pull Requests

1. **Fork the repository** and create a branch
2. **Make your changes** with clear commit messages
3. **Test thoroughly** (see Testing section below)
4. **Update documentation** if needed
5. **Submit a pull request** with a clear description

## 📋 Development Guidelines

### Code Style

**Go:**
- Follow [Effective Go](https://golang.org/doc/effective_go.html)
- Use `gofmt` for formatting
- Run `go vet` before committing
- Add comments for exported functions

**TypeScript/React:**
- Use TypeScript strict mode
- Follow React best practices
- Use functional components with hooks
- Add JSDoc comments for complex functions

**Bash:**
- Use shellcheck for validation
- Include error handling (`set -e`)
- Add comments explaining complex logic
- Follow MITRE ATT&CK comment format

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new container escape attack
fix: resolve WebSocket connection issue
docs: update Docker deployment guide
test: add integration tests for API
chore: update dependencies
```

### Branch Naming

```
feature/attack-scenario-name
bugfix/issue-description
docs/documentation-update
```

## 🧪 Testing

### Before Submitting PR

**Backend:**
```bash
go mod verify
go vet ./...
go test ./...
./test_backend.sh
```

**Frontend:**
```bash
cd frontend
npm run lint
npm run build
```

**Docker:**
```bash
./build-and-test.sh
```

### Adding New Attack Scenarios

1. **Create attack script** in `bin/existing/` or `bin/modern/`
2. **Add metadata** to `backend/attack_metadata.go`
3. **Add route** to `entrypoint.sh`
4. **Test execution** manually
5. **Document** MITRE ATT&CK mapping
6. **Update README** attack count

**Attack Script Template:**
```bash
#!/bin/bash
# Attack: [Name]
# MITRE ATT&CK: [Tactic] - [Technique ID]
# Severity: [CRITICAL|HIGH|MEDIUM|LOW]
# Description: [What this demonstrates]

set -e
echo "[+] Starting: [Name]"
echo "[+] MITRE ATT&CK: [Technique ID] - [Technique Name]"
echo "[+] Severity: [Level]"
echo ""

# Attack logic here

echo ""
echo "[✓] Attack completed"
```

## 🏗️ Project Structure

```
vulnapp/
├── backend/              # Go API handlers
├── bin/                  # Attack scripts
│   ├── existing/        # Classic attacks
│   └── modern/          # Modern threats
├── frontend/            # React application
│   └── src/
│       ├── components/  # React components
│       ├── hooks/       # Custom hooks
│       ├── api/         # API client
│       └── types/       # TypeScript types
├── images/              # Static images
├── Dockerfile           # Multi-stage build
├── entrypoint.sh        # Server startup
└── *.go                 # Go source files
```

## 🔍 Areas for Contribution

### High Priority

1. **Additional Attack Scenarios**
   - Kubernetes-specific attacks
   - Cloud provider escapes
   - Recent CVEs

2. **Frontend Enhancements**
   - Attack history persistence
   - Export results functionality
   - Advanced filtering

3. **Testing**
   - Unit tests for Go code
   - Component tests for React
   - E2E tests with Playwright

### Medium Priority

1. **Documentation**
   - Attack walkthroughs
   - Lab setup guides
   - Video tutorials

2. **DevOps**
   - CI/CD improvements
   - Multi-arch builds (ARM64)
   - Helm charts

3. **Integrations**
   - Falcon API integration
   - Splunk/SIEM export
   - Prometheus metrics

## 🛡️ Security

### Reporting Security Issues

**DO NOT** open public GitHub issues for security vulnerabilities.

Instead:
1. Email security@crowdstrike.com
2. Include "VulnApp Security" in subject
3. Provide detailed description
4. Wait for acknowledgment before disclosure

### Security Considerations

Remember:
- VulnApp is **intentionally vulnerable** for training
- New features should maintain this purpose
- Don't add real vulnerabilities that aren't documented
- Always warn about dangerous configurations

## 📜 License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.

## 🤔 Questions?

- **General questions:** Open a GitHub discussion
- **Bug reports:** GitHub issues
- **Feature requests:** GitHub issues with `enhancement` label
- **Security issues:** security@crowdstrike.com

## 🎯 Good First Issues

Look for issues labeled `good first issue` for newcomer-friendly contributions:

- Documentation improvements
- Additional attack scenarios
- Frontend UI enhancements
- Test coverage improvements

## ✅ PR Checklist

Before submitting your PR, ensure:

- [ ] Code follows project style guidelines
- [ ] All tests pass (`./build-and-test.sh`)
- [ ] Documentation is updated
- [ ] Commit messages follow conventions
- [ ] Branch is up to date with main
- [ ] No merge conflicts
- [ ] Changes are focused and minimal
- [ ] Added tests for new features
- [ ] Screenshots for UI changes

## 🙏 Thank You!

Your contributions help make VulnApp better for the security community. Whether it's code, documentation, or bug reports, all contributions are valued and appreciated!

---

**Happy Contributing! 🎉**
