# GitHub Pages Deployment Guide

**Comprehensive guide for deploying Flutter Deep Link Demo to GitHub Pages**

## 🎯 Overview

This document provides a complete guide for deploying the Flutter Deep Link Demo to GitHub Pages, including troubleshooting common issues and best practices.

## 📋 Prerequisites

- Flutter SDK installed and configured
- Git repository with remote origin set to GitHub
- Access to GitHub repository with Pages enabled
- PowerShell or Command Prompt access

## 🚀 Deployment Process

### Step 1: Build Flutter Web App

```bash
# Build with correct base-href for GitHub Pages subdirectory
flutter build web --release --base-href "/deep_link_demo/"
```

**Important Notes:**
- The `--base-href` parameter is crucial for subdirectory hosting
- Replace `/deep_link_demo/` with your actual repository name
- This ensures all resources load from the correct paths

### Step 2: Prepare Build for Deployment

```bash
# Add build directory to git (usually gitignored)
git add build/web

# Stash the build with descriptive message
git stash push -m "Flutter web build for deployment"
```

### Step 3: Switch to Deployment Branch

```bash
# Switch to gh-pages branch
git checkout gh-pages
```

### Step 4: Clean Deployment Environment

```powershell
# Remove all files except .git directory (PowerShell)
Remove-Item -Path * -Recurse -Force -Exclude ".git"
```

**Critical:** Never remove the `.git` directory as it contains repository metadata.

### Step 5: Deploy Build

```bash
# Unstash the build
git stash pop

# Copy web files to root directory
Copy-Item -Path "build\web\*" -Destination "." -Recurse

# Clean up build directory
Remove-Item -Path "build" -Recurse -Force
```

### Step 6: Commit and Push

```bash
# Stage all changes
git add .

# Commit with descriptive message
git commit -m "🚀 Deploy Flutter Deep Link Demo PWA to GitHub Pages"

# Push to GitHub Pages
git push origin gh-pages
```

## 🔧 Troubleshooting

### Issue: Landing Page Not Displaying

**Symptoms:**
- GitHub Pages site loads but shows blank page
- Browser console shows 404 errors for resources
- Flutter app doesn't initialize

**Solution:**
```bash
# Rebuild with correct base-href
flutter build web --release --base-href "/your-repo-name/"
```

### Issue: Git Repository Corruption

**Symptoms:**
- `fatal: not a git repository` error
- Missing `.git` directory
- Unable to switch branches

**Solution:**
```bash
# Reinitialize repository
git init

# Add remote origin
git remote add origin https://github.com/username/repository.git

# Fetch remote branches
git fetch origin

# Switch to desired branch
git checkout main
```

### Issue: Resource Loading Failures

**Symptoms:**
- CSS styles not applied
- JavaScript files fail to load
- Images and fonts missing

**Root Cause:** Incorrect base-href configuration

**Solution:** Always use the correct repository name in base-href:
```bash
flutter build web --release --base-href "/your-repository-name/"
```

## 🌐 GitHub Pages Configuration

### Repository Settings

1. **Navigate to Settings** → **Pages**
2. **Source**: Deploy from a branch
3. **Branch**: gh-pages
4. **Folder**: / (root)

### Custom Domain (Optional)

If using a custom domain:
```bash
# Build without base-href for custom domain
flutter build web --release
```

## 📊 Verification Steps

### 1. Check Deployment Status

Visit your GitHub repository's Actions tab to monitor deployment status.

### 2. Test Live Site

Access your site at: `https://username.github.io/repository-name/`

### 3. Verify Deep Linking Files

Check that deep linking verification files are accessible:
- `https://username.github.io/repository-name/.well-known/assetlinks.json`
- `https://username.github.io/repository-name/.well-known/apple-app-site-association`

### 4. Test Responsive Design

Test the landing page on different devices:
- Desktop browsers (Chrome, Firefox, Safari, Edge)
- Tablet views (iPad, Android tablets)
- Mobile devices (iOS, Android)

## 🔄 Automation Options

### GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x'
    
    - name: Build web
      run: flutter build web --release --base-href "/repository-name/"
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
```

## 📱 PWA Features

The deployed site includes:

- **Service Worker**: Enables offline functionality
- **Web App Manifest**: Allows installation as PWA
- **Responsive Design**: Optimized for all device sizes
- **Performance Optimizations**: Fast loading and smooth animations

## 🔐 Security Considerations

- **HTTPS**: GitHub Pages serves content over HTTPS by default
- **Content Security Policy**: Implemented in meta tags
- **Deep Linking Verification**: SHA256 fingerprints properly configured

## 📈 Performance Monitoring

Monitor your deployed site using:
- **Google PageSpeed Insights**
- **Lighthouse audits**
- **Web Vitals**
- **GitHub Pages insights**

## 🆘 Emergency Recovery

If deployment fails completely:

```bash
# 1. Reset gh-pages branch
git checkout gh-pages
git reset --hard origin/main

# 2. Force clean deployment
git clean -fd
Remove-Item -Path * -Recurse -Force -Exclude ".git"

# 3. Redeploy from scratch
git checkout main
# ... follow deployment process
```

## 📞 Support Resources

- **GitHub Pages Documentation**: https://docs.github.com/en/pages
- **Flutter Web Deployment**: https://docs.flutter.dev/deployment/web
- **PWA Best Practices**: https://web.dev/progressive-web-apps/
