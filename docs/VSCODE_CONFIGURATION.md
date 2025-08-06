# VS Code Configuration for Flutter Development

## Overview
This document details the VS Code configuration setup for optimal Flutter development experience while avoiding keyring-related issues.

## Configuration Files

### `.vscode/settings.json`
```json
{
  "IDX.agenticWorkspace": true,
  "dart.flutterSdkPath": null,
  "dart.enableSdkFormatter": true,
  "dart.warnWhenEditingFilesOutsideWorkspace": false,
  "dart.allowAnalytics": false,
  "dart.promptToGetPackages": false,
  "dart.previewFlutterUiGuides": true,
  "dart.flutterHotReloadOnSave": "manual",
  "dart.analysisServerFolding": false,
  "dart.insertArgumentPlaceholders": false,
  "dart.reportAnalyzerErrors": false,
  "dart.sendAnalytics": false,
  "dart.additionalAnalyzerFileExtensions": [],
  "terminal.integrated.env.windows": {
    "FLUTTER_SECURE_STORAGE_USE_PLAINTEXT": "true",
    "DART_ANALYTICS_DISABLED": "true",
    "FLUTTER_ANALYTICS_DISABLED": "true",
    "NO_ANALYTICS": "1",
    "DART_DISABLE_ANALYTICS": "1"
  }
}
```

### `.vscode/launch.json`
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Flutter (Debug)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "debug",
            "env": {
                "FLUTTER_SECURE_STORAGE_USE_PLAINTEXT": "true"
            }
        },
        {
            "name": "Flutter (Release)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release",
            "env": {
                "FLUTTER_SECURE_STORAGE_USE_PLAINTEXT": "true"
            }
        }
    ]
}
```

## Key Settings Explained

### Dart Extension Settings
| Setting | Value | Purpose |
|---------|-------|---------|
| `dart.allowAnalytics` | `false` | Prevents analytics data collection |
| `dart.sendAnalytics` | `false` | Disables analytics transmission |
| `dart.reportAnalyzerErrors` | `false` | Reduces error reporting |
| `dart.flutterHotReloadOnSave` | `"manual"` | Manual control over hot reload |

### Environment Variables
| Variable | Value | Purpose |
|----------|-------|---------|
| `FLUTTER_SECURE_STORAGE_USE_PLAINTEXT` | `"true"` | Forces plain text storage instead of keyring |
| `DART_ANALYTICS_DISABLED` | `"true"` | Disables Dart analytics |
| `FLUTTER_ANALYTICS_DISABLED` | `"true"` | Disables Flutter analytics |
| `NO_ANALYTICS` | `"1"` | Universal analytics disable flag |
| `DART_DISABLE_ANALYTICS` | `"1"` | Alternative Dart analytics disable |

## Benefits

### Security
- No sensitive data stored in OS keyring
- Plain text storage for development environment
- Reduced external data transmission

### Performance
- Faster VS Code startup
- Reduced background processes
- Less network activity

### Reliability
- Consistent behavior across different Windows environments
- No dependency on Windows Credential Manager
- Reduced permission-related issues

## Recommended Extensions

### Essential Extensions
1. **Dart** - Language support for Dart
2. **Flutter** - Flutter development tools
3. **Flutter Intl** - Internationalization support

### Optional Extensions
1. **GitLens** - Enhanced Git capabilities
2. **Bracket Pair Colorizer** - Visual bracket matching
3. **Error Lens** - Inline error display
4. **Thunder Client** - API testing

## Launch Configurations

### Debug Mode
- Launches app in debug mode
- Enables hot reload and hot restart
- Includes debugging symbols
- Sets secure storage environment variable

### Release Mode
- Optimized build for testing
- Reduced app size
- Better performance
- Production-like behavior

## Troubleshooting VS Code Issues

### Extension Not Working
1. Reload VS Code window: `Ctrl+Shift+P` → "Developer: Reload Window"
2. Check Dart/Flutter SDK paths
3. Verify extension versions are compatible

### IntelliSense Issues
1. Run "Dart: Restart Analysis Server"
2. Clear VS Code workspace cache
3. Reload window

### Debug Issues
1. Check launch configuration
2. Verify device connectivity
3. Ensure Flutter project is valid

### Environment Variable Issues
1. Close VS Code completely
2. Use PowerShell launcher script
3. Verify variables in terminal: `echo $env:FLUTTER_SECURE_STORAGE_USE_PLAINTEXT`

## Best Practices

### Development Workflow
1. Use the provided launch scripts
2. Keep VS Code and extensions updated
3. Regularly run `flutter doctor` to check setup
4. Use version control for VS Code settings

### Security Considerations
- Only use plain text storage in development
- Use secure storage in production
- Be aware of sensitive data in environment variables
- Regular security audits of development environment

## Maintenance

### Regular Tasks
- Update VS Code and extensions monthly
- Review and update settings as needed
- Clean workspace cache if issues arise
- Monitor Flutter SDK updates

### When to Modify
- Adding new Flutter/Dart features
- Changing development workflow
- Updating SDK versions
- Adding team-specific settings
