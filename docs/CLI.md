# Check what changes were made and revert them
git status
# Restore specific web files that were modified
git restore web/index.html web/manifest.json
# Verify that the changes have been reverted
git status
# Check the last commit to confirm it was successful
git log --oneline -1
# Reset HEAD to the last commit in the remote repository, discarding the local commit
git reset --hard origin/main
# Display the final reorganized documentation structure
tree docs /F
# Run a final check to see if all files compile correctly
flutter analyze --no-fatal-infos
# Open global git configuration for editing
git config --global --edit
# Fix the identity used for this commit if needed
git commit --amend --reset-author
# Clean untracked files and directories
git clean -fd
# Reinitialize the repository
git init
# Add the remote origin repository
git remote add origin https://github.com/chakravartiraj/deep_link_demo.git
# Fetch all branches from the remote repository
git fetch origin
# Switch to the main branch
git checkout main
# Rebuild the web app with the correct base href for GitHub Pages
flutter build web --release --base-href "/deep_link_demo/"
# Switch to the gh-pages branch for deployment
git checkout gh-pages
# Remove all files except .git and build directories (PowerShell)
Remove-Item -Path * -Recurse -Force -Exclude ".git","build\web\*"
# Copy the built web files to the root of gh-pages branch
Copy-Item -Path "build\web\*" -Destination "." -Recurse
# Check all the branches existing for the repository
git branch -a
# 
git add .
# 
git commit -m "docs: enhance CLI.md with comprehensive command descriptions"
# Stash the local changes before switching branches
git stash
# Force checkout to gh-pages branch
git checkout -f gh-pages
# Reset the working directory to HEAD
git reset --hard HEAD