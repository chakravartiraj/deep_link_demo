# PowerShell script to launch VS Code with environment variables
# Set environment variables to prevent keyring usage
$env:FLUTTER_SECURE_STORAGE_USE_PLAINTEXT = "true"
$env:DART_ANALYTICS_DISABLED = "true"
$env:FLUTTER_ANALYTICS_DISABLED = "true"
$env:NO_ANALYTICS = "1"
$env:DART_DISABLE_ANALYTICS = "1"

# Launch VS Code with the project
code "c:\Users\raja.chakraborty\StudioProjects\deep_link_demo"
