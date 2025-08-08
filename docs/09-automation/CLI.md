# Flutter Deep Link Demo - CLI Commands Reference

This document organizes CLI commands by scenarios and use cases for the Flutter Deep Link Demo project.

## 📁 Project Analysis & Verification

### Check Project Status
```bash
# Display the final reorganized documentation structure
tree docs /F

# Run a final check to see if all files compile correctly
flutter analyze --no-fatal-infos

# Check git status
git status

# Check the last commit to confirm it was successful
git log --oneline -1
```

## 🔧 Git Repository Management

### Initialize/Restore Repository
```bash
# Reinitialize the repository (if corrupted)
git init

# Add the remote origin repository
git remote add origin https://github.com/chakravartiraj/deep_link_demo.git

# Fetch all branches from the remote repository
git fetch origin

# Switch to the main branch
git checkout main
```

### Fix Git Configuration Issues
```bash
# Open global git configuration for editing
git config --global --edit

# Fix the identity used for this commit if needed
git commit --amend --reset-author
```

### Clean & Reset Repository
```bash
# Clean untracked files and directories
git clean -fd

# Reset HEAD to the last commit in the remote repository, discarding the local commit
git reset --hard origin/main

# Reset the working directory to HEAD
git reset --hard HEAD
```

## 🔄 File Management & Recovery

### Restore Specific Files
```bash
# Restore specific web files that were modified
git restore web/index.html web/manifest.json

# Verify that the changes have been reverted
git status
```

### Stash Management
```bash
# Stash the local changes before switching branches
git stash

# Stash with specific message
git stash push -m "Flutter web build for deployment"

# Unstash the built web app
git stash pop
```

## 🚀 GitHub Pages Deployment Workflow

### Complete Deployment Process
```bash
# Step 1: Build Flutter web app with correct base href for GitHub Pages
flutter build web --release --base-href "/deep_link_demo/"

# Step 2: Stash the built web app including untracked files
git add build/web //Applicable when something is not gitignored.
git add -f build/web //The build directory is gitignored. Force add it for the stash
git stash push -m "Flutter web build for deployment"

# Step 3: Switch to the gh-pages branch for deployment
git checkout gh-pages

# Step 4: Remove all files except .git directory (PowerShell)
Remove-Item -Path * -Recurse -Force -Exclude ".git"

# Step 5: Unstash the built web app
git stash pop

# Step 6: Copy the web files from build directory to the root of gh-pages branch
Copy-Item -Path "build\web\*" -Destination "." -Recurse

# Step 7: Remove the build directory after copying
Remove-Item -Path "build" -Recurse -Force

# Step 8: Stage all the web files for commit
git add .

# Step 9: Commit the deployment
git commit -m "🚀 Deploy Flutter Deep Link Demo PWA to GitHub Pages with corrected base-href"

# Step 10: Push to GitHub Pages
git push origin gh-pages
```

## 🛠️ Emergency Recovery Commands

### Force Branch Operations
```bash
# Force checkout to gh-pages branch
git checkout -f gh-pages

# Check all the branches existing for the repository
git branch -a
```

### PowerShell File Operations
```bash
# Remove all files except specific directories (PowerShell)
Remove-Item -Path * -Recurse -Force -Exclude ".git"

# Copy files recursively (PowerShell)
Copy-Item -Path "build\web\*" -Destination "." -Recurse
```

## 📝 Development Workflow

### Regular Development Commits
```bash

# Switch to a proper main branch
git checkout -b main

# Stage all changes
git add .

# Commit with descriptive message
git commit -m "docs: enhance CLI.md with comprehensive command descriptions"

# Push to main branch
git push origin main

# Push the changes to origin main branch and set upstream
git push -u origin main
```

---

## 🎯 Quick Reference by Scenario

### Scenario 1: First Time Setup
1. Initialize repository
2. Fetch remote branches
3. Checkout main branch

### Scenario 2: Deploy to GitHub Pages
1. Build Flutter web app
2. Stash the build
3. Switch to gh-pages
4. Clean gh-pages
5. Unstash and deploy
6. Commit and push

### Scenario 3: Fix Deployment Issues
1. Check project status
2. Clean and reset if needed
3. Rebuild and redeploy

### Scenario 4: Repository Recovery
1. Reinitialize git
2. Add remote origin
3. Fetch branches
4. Restore working state