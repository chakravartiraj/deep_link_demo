@echo off
REM Set environment variables to prevent keyring usage
set FLUTTER_SECURE_STORAGE_USE_PLAINTEXT=true
set DART_ANALYTICS_DISABLED=true
set FLUTTER_ANALYTICS_DISABLED=true
set NO_ANALYTICS=1
set DART_DISABLE_ANALYTICS=1

REM Launch VS Code with the project
code "c:\Users\raja.chakraborty\StudioProjects\deep_link_demo"
