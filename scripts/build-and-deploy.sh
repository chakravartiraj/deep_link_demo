#!/bin/bash

# 🚀 Flutter Build & Deploy Script
# This script builds APK and web, then prepares for GitHub Pages deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Flutter Build & Deploy Script${NC}"
echo "========================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    exit 1
fi

# Check Flutter doctor
echo -e "${YELLOW}🔍 Checking Flutter installation...${NC}"
flutter doctor

# Get version info
VERSION=$(grep "version:" pubspec.yaml | cut -d ' ' -f 2 | cut -d '+' -f 1)
BUILD_NUMBER=$(grep "version:" pubspec.yaml | cut -d '+' -f 2)

echo -e "${GREEN}📋 Building version: $VERSION+$BUILD_NUMBER${NC}"

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean
flutter pub get

# Create downloads directory
mkdir -p web/downloads

# Build APK
echo -e "${YELLOW}📱 Building Android APK...${NC}"
flutter build apk --release \
    --build-name=$VERSION \
    --build-number=$BUILD_NUMBER

# Copy APK to web downloads
APK_NAME="deep-link-demo-v$VERSION-build$BUILD_NUMBER-release.apk"
cp build/app/outputs/flutter-apk/app-release.apk "web/downloads/$APK_NAME"

# Get APK size
APK_SIZE=$(du -h "web/downloads/$APK_NAME" | cut -f1)

echo -e "${GREEN}✅ APK built successfully: $APK_NAME ($APK_SIZE)${NC}"

# Build web
echo -e "${YELLOW}🌐 Building Flutter web...${NC}"
flutter build web --release \
    --build-name=$VERSION \
    --build-number=$BUILD_NUMBER \
    --web-renderer html

# Copy APK to web build downloads
mkdir -p build/web/downloads
cp "web/downloads/$APK_NAME" build/web/downloads/

# Create download info JSON
cat > build/web/downloads/info.json << EOF
{
  "version": "$VERSION",
  "buildNumber": "$BUILD_NUMBER",
  "buildDate": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "platforms": {
    "android": {
      "available": true,
      "filename": "$APK_NAME",
      "size": "$APK_SIZE"
    },
    "ios": {
      "available": false,
      "message": "iOS build coming soon!"
    }
  }
}
EOF

echo -e "${GREEN}✅ Web build completed${NC}"

# Display summary
echo ""
echo -e "${BLUE}📋 Build Summary${NC}"
echo "==================="
echo -e "Version: ${GREEN}$VERSION+$BUILD_NUMBER${NC}"
echo -e "APK: ${GREEN}$APK_NAME ($APK_SIZE)${NC}"
echo -e "Web: ${GREEN}build/web/${NC}"
echo ""

# Instructions
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo "1. Test the web app locally:"
echo "   cd build/web && python -m http.server 8000"
echo ""
echo "2. Deploy to GitHub Pages:"
echo "   - Push changes to main branch"
echo "   - GitHub Actions will deploy automatically"
echo ""
echo "3. Access your app:"
echo "   - Web: https://your-username.github.io/deep_link_demo"
echo "   - Downloads: https://your-username.github.io/deep_link_demo/downloads.html"
echo ""

echo -e "${GREEN}🎉 Build completed successfully!${NC}"
