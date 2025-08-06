# Check what changes were made and revert them.
git status
git restore web/index.html web/manifest.json
# Verify that the changes have been reverted
git status