# Deep Link Demo - Environment Setup Documentation

## Project Overview
This Flutter project demonstrates deep linking functionality across multiple platforms while providing a comprehensive development environment setup that resolves common Windows keyring issues.

## Quick Start Guide

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK (included with Flutter)
- VS Code with Dart and Flutter extensions
- Git for version control

### Initial Setup
1. **Clone the repository**
   ```bash
   git clone https://github.com/chakravartiraj/deep_link_demo.git
   cd deep_link_demo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Launch VS Code with proper environment**
   ```powershell
   .\launch_vscode.ps1
   ```

## Documentation Structure

### 📁 `/docs` Directory Contents

| File | Purpose | Audience |
|------|---------|----------|
| `FLUTTER_SETUP_GUIDE.md` | Comprehensive setup and configuration guide | Developers, DevOps |
| `VSCODE_CONFIGURATION.md` | VS Code specific settings and optimizations | Developers |
| `KEYRING_ISSUE_RESOLUTION.md` | Detailed keyring issue troubleshooting | Support, Developers |
| `PLATFORM_CONFIGURATION.md` | Multi-platform Flutter configuration | Developers, Architects |
| `ENVIRONMENT_SETUP.md` | This file - overview and quick reference | All stakeholders |

### 📋 Key Topics Covered

#### 1. **Keyring Issue Resolution**
- **Problem**: Windows OS keyring access errors in VS Code
- **Solution**: Environment variables and configuration files
- **Impact**: Seamless development experience without security prompts

#### 2. **Multi-Platform Support**
- **Platforms**: Android, iOS, Web, Windows Desktop
- **Configuration**: `flutter config --enable-*` commands
- **Verification**: Device detection and build testing

#### 3. **VS Code Integration**
- **Settings**: Optimized workspace configuration
- **Launch**: Debug and release configurations
- **Extensions**: Recommended development tools

#### 4. **Development Workflow**
- **Scripts**: Automated launch and build scripts
- **Environment**: Consistent development environment setup
- **Testing**: Multi-platform testing strategy

## File Structure Analysis

### Configuration Files Created/Modified

```
deep_link_demo/
├── .flutter                    # Flutter CLI configuration
├── .env                        # Environment variables
├── .vscode/
│   ├── settings.json          # VS Code workspace settings
│   └── launch.json            # Debug configurations
├── docs/                      # Documentation (this folder)
│   ├── FLUTTER_SETUP_GUIDE.md
│   ├── VSCODE_CONFIGURATION.md
│   ├── KEYRING_ISSUE_RESOLUTION.md
│   ├── PLATFORM_CONFIGURATION.md
│   └── ENVIRONMENT_SETUP.md
├── launch_vscode.ps1          # PowerShell launcher
├── launch_vscode.bat          # Batch launcher
├── analysis_options_server.yaml # Dart Analysis Server config
└── KEYRING_FIX.md            # Quick reference guide
```

### Core Project Files
```
lib/
├── main.dart                  # Application entry point
├── app.dart                   # Main app widget
├── app_router.dart            # Navigation configuration
├── app_theme.dart             # Theme configuration
├── home_page.dart             # Home screen
├── details_page.dart          # Details screen
├── profile_page.dart          # Profile screen
├── report_page.dart           # Report screen
├── deeplink_page.dart         # Deep link handler
├── error_page.dart            # Error handling
└── deep_links_helper.dart     # Deep link utilities
```

## Environment Variables Reference

### Required Environment Variables
```bash
# Security and Analytics
FLUTTER_SECURE_STORAGE_USE_PLAINTEXT=true
DART_ANALYTICS_DISABLED=true
FLUTTER_ANALYTICS_DISABLED=true
NO_ANALYTICS=1
DART_DISABLE_ANALYTICS=1
```

### Platform Configuration
```bash
# Flutter Platform Settings (managed by flutter config)
enable-android=true
enable-ios=true
enable-web=true
enable-windows-desktop=true
```

## Common Commands Reference

### Development Commands
```bash
# Check Flutter setup
flutter doctor -v

# Check available devices
flutter devices

# Run on specific platform
flutter run -d android
flutter run -d ios
flutter run -d web-server
flutter run -d windows

# Build for specific platform
flutter build apk --release
flutter build ios --release
flutter build web --release
flutter build windows --release
```

### Configuration Commands
```bash
# Check current configuration
flutter config --list

# Enable platforms
flutter config --enable-android
flutter config --enable-ios
flutter config --enable-web
flutter config --enable-windows-desktop

# Disable analytics
flutter --disable-analytics
dart --disable-analytics
```

### Debugging Commands
```bash
# Clean build cache
flutter clean
flutter pub get

# Restart Dart Analysis Server (in VS Code)
Ctrl+Shift+P → "Dart: Restart Analysis Server"

# Check for issues
flutter analyze
flutter test
```

## Troubleshooting Quick Reference

### Issue: Keyring Error on VS Code Start
**Solution**: Use `.\launch_vscode.ps1` to launch VS Code with proper environment variables.

### Issue: Platform Not Available
**Solution**: Run `flutter config --enable-[platform]` and check `flutter doctor`.

### Issue: VS Code Extension Issues
**Solution**: Reload window, restart analysis server, check extension versions.

### Issue: Build Failures
**Solution**: Run `flutter clean && flutter pub get`, check platform-specific requirements.

## Development Team Guidelines

### For New Team Members
1. Follow the **Quick Start Guide** above
2. Read `FLUTTER_SETUP_GUIDE.md` for comprehensive setup
3. Use provided launch scripts for consistent environment
4. Refer to platform-specific documentation as needed

### For DevOps/CI Setup
1. Review `PLATFORM_CONFIGURATION.md` for build automation
2. Use environment variables from `.env` file
3. Implement multi-platform build pipeline
4. Configure platform-specific testing

### For Support Teams
1. Use `KEYRING_ISSUE_RESOLUTION.md` for Windows-specific issues
2. Reference `VSCODE_CONFIGURATION.md` for IDE problems
3. Follow troubleshooting sections in each document
4. Escalate to development team for code-related issues

## Maintenance Schedule

### Weekly Tasks
- [ ] Test application on all enabled platforms
- [ ] Verify VS Code configuration is working
- [ ] Check for Flutter/Dart SDK updates

### Monthly Tasks
- [ ] Update VS Code extensions
- [ ] Review and update documentation
- [ ] Test keyring fix with latest Windows updates
- [ ] Validate multi-platform build process

### Quarterly Tasks
- [ ] Major Flutter SDK updates
- [ ] Security review of development environment
- [ ] Platform-specific dependency updates
- [ ] CI/CD pipeline optimization

## Resources and Support

### Internal Resources
- Project repository: `https://github.com/chakravartiraj/deep_link_demo`
- Documentation: `/docs` folder in repository
- Issue tracking: GitHub Issues

### External Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [VS Code Dart Extension](https://dartcode.org/)
- [Flutter Community](https://flutter.dev/community)

### Getting Help
1. Check documentation in `/docs` folder
2. Search existing GitHub issues
3. Create new issue with detailed description
4. Contact development team for urgent issues

## Success Metrics

### Environment Setup Success Indicators
- ✅ VS Code opens without keyring errors
- ✅ All platforms show as available in `flutter devices`
- ✅ Debug and release builds work on all platforms
- ✅ Hot reload and hot restart function properly
- ✅ Analysis server provides proper IntelliSense

### Project Health Indicators
- ✅ All tests pass on all platforms
- ✅ Build times are acceptable
- ✅ No security warnings in development environment
- ✅ Team members can set up environment quickly
- ✅ CI/CD pipeline builds successfully

---

**Last Updated**: August 5, 2025  
**Version**: 1.0.0  
**Maintainer**: Development Team
