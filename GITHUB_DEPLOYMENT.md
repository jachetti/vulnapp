# GitHub Repository Deployment Guide

This guide covers deploying VulnApp v2.0 to a public GitHub repository.

---

## 📋 Pre-Deployment Checklist

### Required Files ✅
- [x] README.md - Comprehensive project documentation
- [x] LICENSE - Apache 2.0 license file
- [x] CONTRIBUTING.md - Contribution guidelines
- [x] .gitignore - Excludes unnecessary files
- [x] .github/workflows/ - CI/CD pipelines
- [x] Dockerfile - Multi-stage build
- [x] docker-compose.yml - Optional local development
- [x] All source code and attack scripts

### Security Review ✅
- [x] No hardcoded secrets or credentials
- [x] No sensitive data in codebase
- [x] Clear security warnings in README
- [x] Intentional vulnerabilities documented
- [x] Attack scripts are safe (simulations only)

### Documentation ✅
- [x] Installation instructions
- [x] Usage examples
- [x] API documentation
- [x] Architecture diagrams
- [x] Contributing guidelines
- [x] Security warnings

---

## 🚀 Deployment Steps

### Step 1: Initialize Git Repository

```bash
cd "/Users/cjachetti/Documents/claude/New Vulnapp"

# Initialize git (if not already)
git init

# Add all files
git add .

# Create initial commit
git commit -m "feat: VulnApp v2.0 - Complete modernization

- Add React 18.3 + TypeScript frontend
- Add 12 modern container threat scenarios
- Implement WebSocket real-time streaming
- Add MITRE ATT&CK integration
- Update to Go 1.23
- Change default port to 80
- Add interactive LAN testing features
- Create multi-stage Docker build
- Add comprehensive documentation

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

### Step 2: Create GitHub Repository

**Option A: Via GitHub Web Interface**
1. Go to https://github.com/new
2. Repository name: `vulnapp`
3. Description: "Intentionally vulnerable container application for security testing"
4. Visibility: **Public** (or Private if preferred)
5. Do NOT initialize with README (we have one)
6. Click "Create repository"

**Option B: Via GitHub CLI**
```bash
# Install gh CLI if not available
brew install gh  # macOS
# or: apt install gh  # Linux

# Authenticate
gh auth login

# Create repository
gh repo create CrowdStrike/vulnapp \
  --public \
  --description "Intentionally vulnerable container application for security testing" \
  --homepage "https://github.com/CrowdStrike/vulnapp"
```

### Step 3: Push to GitHub

```bash
# Add remote
git remote add origin https://github.com/CrowdStrike/vulnapp.git

# Push to main branch
git branch -M main
git push -u origin main
```

### Step 4: Configure Repository Settings

**In GitHub repository settings:**

1. **General:**
   - ✅ Enable Issues
   - ✅ Enable Discussions (optional)
   - ✅ Enable Wiki (optional)
   - ❌ Disable Merge commits (use Squash and merge)

2. **Branches:**
   - Set `main` as default branch
   - Add branch protection rules:
     - ✅ Require pull request reviews
     - ✅ Require status checks to pass (CI/CD)
     - ✅ Require conversation resolution
     - ❌ Do not allow force pushes

3. **Actions:**
   - ✅ Enable GitHub Actions
   - ✅ Allow all actions
   - Set workflow permissions to "Read and write"

4. **Security:**
   - ✅ Enable Dependabot alerts
   - ✅ Enable Dependabot security updates
   - ✅ Enable code scanning (CodeQL)

5. **Pages (Optional):**
   - Source: Deploy from a branch
   - Branch: `gh-pages` (if you create documentation site)

### Step 5: Add Repository Topics

Add these topics for discoverability:
- `security`
- `container-security`
- `docker`
- `kubernetes`
- `mitre-attack`
- `crowdstrike`
- `falcon`
- `vulnerability-testing`
- `penetration-testing`
- `red-team`
- `security-training`
- `intentionally-vulnerable`

### Step 6: Create Release

```bash
# Tag the release
git tag -a v2.0.0 -m "VulnApp v2.0.0 - Complete Modernization

Major Features:
- Modern React 18.3 + TypeScript UI
- 24 attack scenarios (12 existing + 12 modern)
- Real-time WebSocket streaming
- MITRE ATT&CK integration
- Interactive LAN testing
- Multi-stage Docker build
- Comprehensive documentation

Breaking Changes:
- Port changed from 8080 to 80
- API endpoints restructured
- New frontend replaces simple HTML

See IMPLEMENTATION_COMPLETE.md for full details."

# Push tag
git push origin v2.0.0
```

**In GitHub:**
1. Go to Releases
2. Click "Draft a new release"
3. Choose tag: `v2.0.0`
4. Release title: "VulnApp v2.0.0 - Complete Modernization"
5. Description: See tag message above
6. Attach pre-built Docker image (optional)
7. Mark as "Latest release"
8. Publish release

---

## 🐳 Docker Hub / Quay.io Setup

### Push to Quay.io (CrowdStrike)

```bash
# Login to Quay
docker login quay.io

# Build and tag
docker build -t quay.io/crowdstrike/vulnapp:2.0 .
docker tag quay.io/crowdstrike/vulnapp:2.0 quay.io/crowdstrike/vulnapp:latest

# Push
docker push quay.io/crowdstrike/vulnapp:2.0
docker push quay.io/crowdstrike/vulnapp:latest
```

### Automated Builds (GitHub Actions)

The workflow in `.github/workflows/build-and-test.yml` can be extended to push to registries:

```yaml
# Add to workflow after successful tests
- name: Login to Quay.io
  uses: docker/login-action@v3
  with:
    registry: quay.io
    username: ${{ secrets.QUAY_USERNAME }}
    password: ${{ secrets.QUAY_PASSWORD }}

- name: Build and push
  uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: |
      quay.io/crowdstrike/vulnapp:${{ github.sha }}
      quay.io/crowdstrike/vulnapp:latest
```

---

## 📊 Repository Setup Checklist

### Initial Setup
- [ ] Create GitHub repository
- [ ] Push code to GitHub
- [ ] Configure branch protection
- [ ] Enable GitHub Actions
- [ ] Add repository topics
- [ ] Create v2.0.0 release
- [ ] Update repository description
- [ ] Add security policy (SECURITY.md)

### Documentation
- [ ] Verify README renders correctly
- [ ] Check all links work
- [ ] Ensure images display properly
- [ ] Verify code examples are accurate
- [ ] Test quick start instructions

### CI/CD
- [ ] Verify GitHub Actions workflows run
- [ ] Check all tests pass
- [ ] Validate Docker build succeeds
- [ ] Review security scan results

### Container Registry
- [ ] Push to Quay.io/Docker Hub
- [ ] Tag versions correctly
- [ ] Update README with pull commands
- [ ] Set up automated builds

### Community
- [ ] Create issue templates
- [ ] Add pull request template
- [ ] Enable discussions (optional)
- [ ] Add CODE_OF_CONDUCT.md
- [ ] Create SECURITY.md

---

## 📝 Post-Deployment Tasks

### 1. Update CrowdStrike Documentation
- Link to new repository
- Update internal wikis
- Notify relevant teams

### 2. Announce Release
- Tweet from @CrowdStrike
- Post in security forums
- Share in container security communities
- Blog post (optional)

### 3. Monitor Issues
- Respond to bug reports
- Review pull requests
- Update documentation based on feedback

### 4. Maintain Repository
- Regular dependency updates
- Security patches
- New attack scenarios
- Documentation improvements

---

## 🔐 Security Considerations

### Secrets Management
Never commit:
- API keys
- Passwords
- Private keys
- Tokens
- Credentials

Use GitHub Secrets for CI/CD:
```bash
# Add secrets via gh CLI
gh secret set QUAY_USERNAME
gh secret set QUAY_PASSWORD
```

### Vulnerability Scanning
- Enable Dependabot alerts
- Review CodeQL findings
- Monitor Trivy scan results
- Act on security advisories

### Access Control
- Limit who can push to main
- Require reviews for PRs
- Use CODEOWNERS file
- Audit access regularly

---

## 📈 Analytics & Tracking

### GitHub Insights
Monitor:
- Stars and forks
- Traffic (views, clones)
- Popular content
- Community activity

### Container Registry
Track:
- Pull counts
- Version distribution
- Geographic usage

---

## 🆘 Troubleshooting

### Build Fails on GitHub Actions
```bash
# Run locally to debug
./build-and-test.sh

# Check workflow logs
gh run list
gh run view <run-id> --log-failed
```

### Docker Push Fails
```bash
# Verify authentication
docker login quay.io

# Check image name
docker images | grep vulnapp

# Manual push
docker push quay.io/crowdstrike/vulnapp:2.0
```

### Links Don't Work
- Ensure all markdown links use relative paths
- Verify images exist in repository
- Test links in GitHub preview

---

## 🎯 Success Criteria

Repository is ready when:
- ✅ All files pushed to GitHub
- ✅ CI/CD pipeline runs successfully
- ✅ Docker image builds and tests pass
- ✅ README renders correctly
- ✅ Quick start instructions work
- ✅ Release created and tagged
- ✅ Container registry updated
- ✅ Community features enabled

---

## 📞 Support

For deployment issues:
- GitHub Issues for technical problems
- Internal Slack for CrowdStrike team
- Email: devops@crowdstrike.com (internal)

---

**Ready to Deploy? 🚀**

Run through this checklist, then push to GitHub and share with the community!
