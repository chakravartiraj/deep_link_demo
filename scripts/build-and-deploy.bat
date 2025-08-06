@echo off
setlocal enabledelayedexpansion

echo.
echo 🚀 Flutter Build ^& Deploy Script
echo ========================================

REM Check if Flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter is not installed or not in PATH
    pause
    exit /b 1
)

REM Check Flutter doctor
echo 🔍 Checking Flutter installation...
flutter doctor

REM Get version info from pubspec.yaml
for /f "tokens=2 delims= " %%a in ('findstr "version:" pubspec.yaml') do set FULL_VERSION=%%a
for /f "tokens=1 delims=+" %%a in ("!FULL_VERSION!") do set VERSION=%%a
for /f "tokens=2 delims=+" %%a in ("!FULL_VERSION!") do set BUILD_NUMBER=%%a

echo 📋 Building version: !VERSION!+!BUILD_NUMBER!

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean
flutter pub get

REM Create downloads directory
if not exist "web\downloads" mkdir "web\downloads"

REM Build APK
echo 📱 Building Android APK...
flutter build apk --release --build-name=!VERSION! --build-number=!BUILD_NUMBER!

REM Copy APK to web downloads
set APK_NAME=deep-link-demo-v!VERSION!-build!BUILD_NUMBER!-release.apk
copy "build\app\outputs\flutter-apk\app-release.apk" "web\downloads\!APK_NAME!"

echo ✅ APK built successfully: !APK_NAME!

REM Build web
echo 🌐 Building Flutter web...
flutter build web --release --build-name=!VERSION! --build-number=!BUILD_NUMBER! --web-renderer html

REM Copy APK to web build downloads
if not exist "build\web\downloads" mkdir "build\web\downloads"
copy "web\downloads\!APK_NAME!" "build\web\downloads\"

REM Create download info JSON
echo Creating download info...
(
echo {
echo   "version": "!VERSION!",
echo   "buildNumber": "!BUILD_NUMBER!",
echo   "buildDate": "%date% %time%",
echo   "platforms": {
echo     "android": {
echo       "available": true,
echo       "filename": "!APK_NAME!",
echo       "size": "TBD"
echo     },
echo     "ios": {
echo       "available": false,
echo       "message": "iOS build coming soon!"
echo     }
echo   }
echo }
) > "build\web\downloads\info.json"

echo ✅ Web build completed

echo.
echo 📋 Build Summary
echo ===================
echo Version: !VERSION!+!BUILD_NUMBER!
echo APK: !APK_NAME!
echo Web: build\web\
echo.

echo 📝 Next Steps:
echo 1. Test the web app locally:
echo    cd build\web ^&^& python -m http.server 8000
echo.
echo 2. Deploy to GitHub Pages:
echo    - Push changes to main branch
echo    - GitHub Actions will deploy automatically
echo.
echo 3. Access your app:
echo    - Web: https://your-username.github.io/deep_link_demo
echo    - Downloads: https://your-username.github.io/deep_link_demo/downloads.html
echo.

echo 🎉 Build completed successfully!
pause
