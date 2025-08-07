# Keyring Issue Fix

## Problem
When opening this project in VS Code, you might see the message: "An OS keyring couldn't be identified for storing the encryption related data in your current desktop environment."

## Solution
This issue has been resolved with the following configurations:

### 1. VS Code Settings
- Analytics disabled for Dart/Flutter extensions
- Environment variables set to use plain text storage
- Secure storage disabled

### 2. Environment Variables
The following environment variables are configured:
- `FLUTTER_SECURE_STORAGE_USE_PLAINTEXT=true`
- `DART_ANALYTICS_DISABLED=true`
- `FLUTTER_ANALYTICS_DISABLED=true`
- `NO_ANALYTICS=1`
- `DART_DISABLE_ANALYTICS=1`

### 3. Launch Scripts
Use one of these scripts to launch VS Code with proper environment variables:

**For Command Prompt:**
```cmd
launch_vscode.bat
```

**For PowerShell:**
```powershell
.\launch_vscode.ps1
```

### 4. Manual Setup
If you still see the keyring message, run these commands:

```bash
flutter --disable-analytics
dart --disable-analytics
```

### 5. Alternative Solution
If the issue persists, you can:
1. Close VS Code
2. Run the PowerShell script: `.\launch_vscode.ps1`
3. This will launch VS Code with the correct environment variables

## Files Modified
- `.vscode/settings.json` - VS Code workspace settings
- `.vscode/launch.json` - Debug configuration
- `.env` - Environment variables
- `launch_vscode.bat` - Windows batch launcher
- `launch_vscode.ps1` - PowerShell launcher
