#!/usr/bin/env pwsh

# Migration script to update ResponsiveUtils.getValue to ResponsiveUtils.getResponsiveValue
Write-Host "🚀 Starting ResponsiveUtils migration..." -ForegroundColor Green

$files = @(
    "lib\features\landing\pages\landing_page.dart",
    "lib\features\splash\pages\splash_page.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "📝 Processing $file..." -ForegroundColor Cyan
        
        $content = Get-Content $file -Raw
        
        # Pattern to match ResponsiveUtils.getValue(context, value1, value2, value3)
        # Handle multi-line cases and various spacing
        $pattern = 'ResponsiveUtils\.getValue\(\s*context,\s*([^,]+),\s*([^,]+),\s*([^)]+)\)'
        $replacement = 'ResponsiveUtils.getResponsiveValue<double>(context, mobile: $1, tablet: $2, desktop: $3)'
        
        $newContent = $content -replace $pattern, $replacement
        
        # Special pattern for EdgeInsets cases
        $edgeInsetsPattern = 'ResponsiveUtils\.getResponsiveValue<double>\(\s*context,\s*mobile:\s*EdgeInsets\.'
        $edgeInsetsReplacement = 'ResponsiveUtils.getResponsiveValue<EdgeInsets>(context, mobile: EdgeInsets.'
        $newContent = $newContent -replace $edgeInsetsPattern, $edgeInsetsReplacement
        
        if ($content -ne $newContent) {
            Set-Content $file $newContent -NoNewline
            Write-Host "✅ Updated $file" -ForegroundColor Green
        } else {
            Write-Host "ℹ️  No changes needed for $file" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ File not found: $file" -ForegroundColor Red
    }
}

Write-Host "🎉 Migration completed!" -ForegroundColor Green
