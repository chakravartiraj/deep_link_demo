#!/usr/bin/env pwsh
# Fastlane Setup Script for Flutter Deep Link Demo
# This script automates the complete setup process

param(
    [switch]$SkipJDK,
    [switch]$SkipRuby,
    [switch]$SkipFastlane,
    [switch]$QuickSetup
)

# Color functions
function Write-Success { param($Message) Write-Host "✅ $Message" -ForegroundColor Green }
function Write-Info { param($Message) Write-Host "ℹ️  $Message" -ForegroundColor Cyan }
function Write-Warning { param($Message) Write-Host "⚠️  $Message" -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host "❌ $Message" -ForegroundColor Red }
function Write-Step { param($Message) Write-Host "🔄 $Message" -ForegroundColor Blue }

Write-Host "🚀 Fastlane Setup Script for Flutter Deep Link Demo" -ForegroundColor Magenta
Write-Host "======================================================" -ForegroundColor Magenta

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Warning "Some installations may require administrator privileges"
}

# Step 1: Install JDK 17
if (-not $SkipJDK) {
    Write-Step "Checking Java installation..."
    try {
        $javaVersion = java -version 2>&1
        if ($javaVersion -match "17\.") {
            Write-Success "Java 17 is already installed"
        } else {
            Write-Info "Java 17 not found, installing..."
            winget install Microsoft.OpenJDK.17
        }
    } catch {
        Write-Info "Installing Microsoft OpenJDK 17..."
        winget install Microsoft.OpenJDK.17
    }
    
    # Set environment variables
    $jdkPath = "C:\Program Files\Microsoft\jdk-17.0.16.8-hotspot"
    if (Test-Path $jdkPath) {
        $env:JAVA_HOME = $jdkPath
        $env:PATH = "$env:PATH;$jdkPath\bin"
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "User")
        
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($currentPath -notlike "*$jdkPath\bin*") {
            $newPath = "$currentPath;$jdkPath\bin"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        }
        Write-Success "Java environment variables configured"
    }
}

# Step 2: Install Ruby
if (-not $SkipRuby) {
    Write-Step "Checking Ruby installation..."
    try {
        $rubyVersion = ruby --version
        Write-Success "Ruby is already installed: $rubyVersion"
    } catch {
        Write-Info "Installing Ruby..."
        winget install RubyInstallerTeam.Ruby.3.3
        Write-Success "Ruby installed successfully"
    }
}

# Step 3: Install Fastlane
if (-not $SkipFastlane) {
    Write-Step "Installing Fastlane and dependencies..."
    try {
        gem install fastlane -NV
        gem install bundler
        Write-Success "Fastlane and Bundler installed successfully"
    } catch {
        Write-Error "Failed to install Fastlane. Please check Ruby installation."
        exit 1
    }
}

# Step 4: Verify installations
Write-Step "Verifying installations..."

$checks = @(
    @{ Command = "java -version"; Name = "Java" },
    @{ Command = "javac -version"; Name = "Java Compiler" },
    @{ Command = "keytool -help"; Name = "Keytool" },
    @{ Command = "ruby --version"; Name = "Ruby" },
    @{ Command = "gem --version"; Name = "RubyGems" },
    @{ Command = "fastlane --version"; Name = "Fastlane" },
    @{ Command = "bundle --version"; Name = "Bundler" },
    @{ Command = "flutter --version"; Name = "Flutter" }
)

$allGood = $true
foreach ($check in $checks) {
    try {
        $output = Invoke-Expression $check.Command 2>&1
        Write-Success "$($check.Name) is working"
    } catch {
        Write-Error "$($check.Name) is not working properly"
        $allGood = $false
    }
}

if ($allGood) {
    Write-Success "All dependencies are properly installed and configured!"
} else {
    Write-Warning "Some dependencies need attention. Please check the errors above."
}

# Step 5: Quick setup
if ($QuickSetup) {
    Write-Step "Running quick project setup..."
    
    # Navigate to android directory
    if (Test-Path "android") {
        Set-Location "android"
        
        # Test Fastlane
        Write-Step "Testing Fastlane with analyze lane..."
        try {
            fastlane android analyze
            Write-Success "Fastlane is working correctly!"
        } catch {
            Write-Warning "Fastlane test failed. You may need to initialize Fastlane first."
            Write-Info "Run: fastlane init"
        }
        
        Set-Location ".."
    } else {
        Write-Warning "Not in a Flutter project directory. Navigate to your project and run this script."
    }
}

# Step 6: Show next steps
Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Navigate to your Flutter project directory" -ForegroundColor White
Write-Host "2. cd android" -ForegroundColor White
Write-Host "3. fastlane init (if not already done)" -ForegroundColor White
Write-Host "4. fastlane android clean" -ForegroundColor White
Write-Host "5. fastlane android build_debug" -ForegroundColor White
Write-Host ""
Write-Host "📚 Available commands:" -ForegroundColor Yellow
Write-Host "fastlane android clean          # Clean project" -ForegroundColor White
Write-Host "fastlane android analyze        # Code analysis" -ForegroundColor White
Write-Host "fastlane android test           # Run tests" -ForegroundColor White
Write-Host "fastlane android build_debug    # Debug build" -ForegroundColor White
Write-Host "fastlane android build_release  # Release build" -ForegroundColor White
Write-Host "fastlane android deploy_web     # Web deployment" -ForegroundColor White
Write-Host "fastlane android ci             # Full pipeline" -ForegroundColor White
Write-Host ""
Write-Success "Setup completed! Happy coding! 🚀"
