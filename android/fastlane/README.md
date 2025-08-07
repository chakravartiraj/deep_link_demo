fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android clean

```sh
[bundle exec] fastlane android clean
```

🧹 Clean Flutter project and reset dependencies

### android analyze

```sh
[bundle exec] fastlane android analyze
```

🔍 Run Flutter code analysis

### android test

```sh
[bundle exec] fastlane android test
```

🧪 Run Flutter tests with coverage

### android build_debug

```sh
[bundle exec] fastlane android build_debug
```

🔨 Build debug APK

### android build_release

```sh
[bundle exec] fastlane android build_release
```

🚀 Build release APK with automatic keystore generation

### android build_gradle_release

```sh
[bundle exec] fastlane android build_gradle_release
```

📦 Build and sign release APK using Gradle

### android build_web

```sh
[bundle exec] fastlane android build_web
```

🌐 Build optimized web release

### android deploy_web

```sh
[bundle exec] fastlane android deploy_web
```

🚀 Prepare web deployment with deep linking files

### android ci

```sh
[bundle exec] fastlane android ci
```

🏗️ Complete CI/CD pipeline - test, analyze, and build

### android report

```sh
[bundle exec] fastlane android report
```

📊 Generate project report

### android beta

```sh
[bundle exec] fastlane android beta
```

Submit a new Beta Build to Crashlytics Beta

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Deploy a new version to the Google Play

### android build_for_screengrab

```sh
[bundle exec] fastlane android build_for_screengrab
```

Build debug and test APK for screenshots

### android build_debug_gradle

```sh
[bundle exec] fastlane android build_debug_gradle
```

Build debug APK using Gradle

### android release

```sh
[bundle exec] fastlane android release
```

Build release APK

### android screenshots

```sh
[bundle exec] fastlane android screenshots
```

Take screenshots with proper APK paths

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
