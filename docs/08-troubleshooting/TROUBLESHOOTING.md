# CLI Commands Troubleshooting Guide

**Comprehensive troubleshooting guide for common CLI issues and their solutions**

## 🎯 Overview

This guide provides solutions to common command-line issues encountered during Flutter Deep Link Demo development, deployment, and maintenance.

## 🔧 Git Repository Issues

### Issue: "fatal: not a git repository"

**Symptoms:**
```bash
fatal: not a git repository (or any of the parent directories): .git
```

**Causes:**
- `.git` directory was accidentally deleted
- Working in wrong directory
- Repository was never initialized

**Solutions:**

```bash
# Solution 1: Reinitialize existing repository
git init
git remote add origin https://github.com/username/repository.git
git fetch origin
git checkout main

# Solution 2: Clone fresh copy
cd ..
git clone https://github.com/username/repository.git
cd repository
```

### Issue: "error: pathspec 'branch' did not match any file(s)"

**Symptoms:**
```bash
error: pathspec 'main' did not match any file(s) known to git
```

**Causes:**
- Branch doesn't exist locally
- Remote branch not fetched
- Wrong branch name

**Solutions:**

```bash
# Check available branches
git branch -a

# Fetch remote branches
git fetch origin

# Create and switch to branch
git checkout -b main origin/main

# Or switch to existing remote branch
git checkout main
```

### Issue: Detached HEAD state

**Symptoms:**
```bash
HEAD detached at origin/main
```

**Solutions:**

```bash
# Create new branch from current state
git checkout -b main

# Or switch to existing branch
git checkout main
```

## 🚀 Flutter Build Issues

### Issue: "Flutter command not found"

**Symptoms:**
```bash
'flutter' is not recognized as an internal or external command
```

**Causes:**
- Flutter not installed
- Flutter not in PATH
- Wrong terminal/shell

**Solutions:**

```bash
# Windows: Add to PATH
$env:PATH += ";C:\path\to\flutter\bin"

# Verify installation
flutter doctor

# Linux/Mac: Add to shell profile
export PATH="$PATH:/path/to/flutter/bin"
```

### Issue: Flutter build fails

**Symptoms:**
```bash
Error: Could not resolve the package 'package_name'
```

**Solutions:**

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Clear pub cache if needed
flutter pub cache repair

# Rebuild
flutter build web --release
```

### Issue: Base-href configuration

**Symptoms:**
- Web app loads but shows blank page
- 404 errors for resources
- Incorrect asset paths

**Solutions:**

```bash
# For GitHub Pages subdirectory
flutter build web --release --base-href "/repository-name/"

# For custom domain
flutter build web --release

# For localhost testing
flutter build web --release --base-href "/"
```

## 📁 File Operation Issues

### Issue: PowerShell execution policy

**Symptoms:**
```powershell
Remove-Item : cannot be loaded because running scripts is disabled
```

**Solutions:**

```powershell
# Check current policy
Get-ExecutionPolicy

# Set policy for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Alternative: Run single command
powershell -ExecutionPolicy Bypass -Command "Remove-Item ..."
```

### Issue: File access denied

**Symptoms:**
```bash
Permission denied
Access is denied
```

**Solutions:**

```bash
# Run as administrator (Windows)
# Right-click PowerShell -> "Run as administrator"

# Check file permissions
icacls filename

# Force removal (use carefully)
Remove-Item -Path file -Force
```

### Issue: Path not found

**Symptoms:**
```powershell
Cannot find path 'C:\path\to\file'
```

**Solutions:**

```powershell
# Check current directory
pwd

# Use absolute paths
Copy-Item -Path "C:\full\path\source" -Destination "C:\full\path\dest"

# Verify path exists
Test-Path "C:\path\to\check"
```

## 🔐 Certificate and Keystore Issues

### Issue: Keytool command not found

**Symptoms:**
```bash
'keytool' is not recognized as an internal or external command
```

**Solutions:**

```bash
# Add Java to PATH (Windows)
$env:PATH += ";C:\Program Files\Java\jdk-version\bin"

# Or use full path
"C:\Program Files\Java\jdk-version\bin\keytool.exe" -list ...

# Verify Java installation
java -version
```

### Issue: Keystore password incorrect

**Symptoms:**
```bash
keytool error: java.io.IOException: Keystore was tampered with, or password was incorrect
```

**Solutions:**

```bash
# Verify password
keytool -list -keystore keystores/release-keystore.jks -storepass 321123

# Check keystore integrity
keytool -list -keystore keystores/release-keystore.jks

# Generate new keystore if corrupted
keytool -genkey -v -keystore new-keystore.jks ...
```

## 🌐 Network and Deployment Issues

### Issue: GitHub authentication failed

**Symptoms:**
```bash
remote: Permission denied (publickey)
fatal: Authentication failed
```

**Solutions:**

```bash
# Use HTTPS with token
git remote set-url origin https://token@github.com/username/repo.git

# Or setup SSH keys
ssh-keygen -t ed25519 -C "email@example.com"
# Add public key to GitHub

# Test connection
ssh -T git@github.com
```

### Issue: GitHub Pages not updating

**Symptoms:**
- Site shows old content
- Changes not reflected on live site
- 404 errors on GitHub Pages

**Solutions:**

```bash
# Check GitHub Pages settings
# Repository -> Settings -> Pages

# Force rebuild pages
git commit --allow-empty -m "Trigger Pages rebuild"
git push origin gh-pages

# Clear browser cache
# Ctrl+F5 or Cmd+Shift+R

# Check deployment status
# Repository -> Actions -> Pages build
```

## 🔄 Stash and Branch Issues

### Issue: Stash conflicts

**Symptoms:**
```bash
error: Your local changes to the following files would be overwritten by merge
```

**Solutions:**

```bash
# Force stash (lose changes)
git stash --include-untracked

# Or commit changes first
git add .
git commit -m "Save changes before stash"
git stash

# Apply stash with conflict resolution
git stash pop
# Resolve conflicts manually
git add .
git commit -m "Resolve stash conflicts"
```

### Issue: Cannot switch branches

**Symptoms:**
```bash
error: Your local changes to the following files would be overwritten by checkout
```

**Solutions:**

```bash
# Stash changes
git stash
git checkout branch-name
git stash pop

# Or force checkout (lose changes)
git checkout -f branch-name

# Or commit changes first
git add .
git commit -m "WIP: Save before branch switch"
git checkout branch-name
```

## 🚨 Emergency Recovery

### Complete Repository Reset

```bash
# WARNING: This will lose all local changes
git fetch origin
git reset --hard origin/main
git clean -fd

# Or start completely fresh
cd ..
rm -rf project-directory
git clone https://github.com/username/repository.git
```

### Corrupted Working Directory

```bash
# Check repository status
git status
git fsck

# Reset to last known good state
git reflog
git reset --hard HEAD@{n}  # where n is a good state

# Clean untracked files
git clean -fd
```

## 📋 Diagnostic Commands

### Repository Health Check

```bash
# Check git status
git status

# Check remote configuration
git remote -v

# Check branch information
git branch -a

# Check commit history
git log --oneline -10

# Check repository integrity
git fsck
```

### Environment Verification

```bash
# Check Flutter
flutter doctor

# Check Git
git --version

# Check Java (for keytool)
java -version

# Check PowerShell
$PSVersionTable.PSVersion
```

### Build Verification

```bash
# Check build output
ls build/web

# Verify web files
Test-Path "build/web/index.html"

# Check file sizes
Get-ChildItem build/web -Recurse | Measure-Object -Property Length -Sum
```

## 🆘 Getting Help

### When to Seek Additional Help

1. **Persistent errors** after trying documented solutions
2. **System-specific issues** not covered in this guide
3. **Complex git history** problems
4. **Security-related** certificate issues

### Useful Debugging Information

When seeking help, provide:

```bash
# System information
flutter doctor -v

# Git status
git status
git log --oneline -5

# Error output (full stack trace)
# Build output
# Repository structure
```

### External Resources

- **Flutter Documentation**: https://docs.flutter.dev/
- **Git Documentation**: https://git-scm.com/docs
- **GitHub Pages Help**: https://docs.github.com/en/pages
- **Stack Overflow**: Search for specific error messages
