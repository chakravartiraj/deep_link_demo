# Check what changes were made and revert them.
git status
git restore web/index.html web/manifest.json
# Verify that the changes have been reverted
git status
# Try the git log to confirm if the last commit was successful
git log --oneline -1
# Displaying the final reorganized documentation structure
tree docs /F
# Run a final check to see if all files compile correctly
flutter analyze --no-fatal-infos