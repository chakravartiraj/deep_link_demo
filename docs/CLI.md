# Check what changes were made and revert them.
git status
git restore web/index.html web/manifest.json
# Verify that the changes have been reverted
git status
# Try the git log to confirm if the last commit was successful
git log --oneline -1
# Reset HEAD to the last commit in the remote repository, discarding the local commit
git reset --hard origin/main
# Displaying the final reorganized documentation structure
tree docs /F
# Run a final check to see if all files compile correctly
flutter analyze --no-fatal-infos
# Run the following command and follow the instructions in your editor to edit your configuration file:
git config --global --edit
# After doing this, you may fix the identity used for this commit with:   
git commit --amend --reset-author
# Clean untracked files and directories
git clean -fd