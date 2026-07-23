# ZCode Fast Installer (Pre-compiled Binary)
# This script downloads the compiled ZCode.exe directly. No Go or Git required.

$ErrorActionPreference = "Stop"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "     ZCode Fast Auto-Installer        " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# 1. Define paths
$installDir = "$env:USERPROFILE\.zcode\bin"
$exePath = "$installDir\zcode.exe"
$repo = "tkjij77-ctrl/ZCode"

# 2. Create the hidden directory if it doesn't exist
if (!(Test-Path -Path $installDir)) {
    Write-Host "Creating installation directory at $installDir..."
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# 3. Check for Releases on GitHub
Write-Host "Looking for the latest ZCode release..." -ForegroundColor Yellow
$apiUrl = "https://api.github.com/repos/$repo/releases/latest"

try {
    $release = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
    # Look for a windows executable asset
    $asset = $release.assets | Where-Object { $_.name -match "zcode.exe" -or $_.name -match "windows" }
    
    if ($null -eq $asset) {
        Write-Host "Found a release ($($release.tag_name)), but couldn't find the Windows .exe file in it." -ForegroundColor Red
        Write-Host "The developer needs to upload 'zcode.exe' to the GitHub Releases page." -ForegroundColor Red
        exit 1
    }

    $downloadUrl = $asset.browser_download_url
    Write-Host "Downloading ZCode version $($release.tag_name)..." -ForegroundColor Green
    Invoke-WebRequest -Uri $downloadUrl -OutFile $exePath
    
} catch {
    Write-Host "No official releases found yet on GitHub!" -ForegroundColor Red
    Write-Host "To make this fast installer work, you must:" -ForegroundColor White
    Write-Host "1. Build the code: go build -o zcode.exe main.go" -ForegroundColor White
    Write-Host "2. Go to your GitHub Repo -> Releases -> Create a new release." -ForegroundColor White
    Write-Host "3. Upload the 'zcode.exe' file there." -ForegroundColor White
    exit 1
}

# 4. Add to PATH
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notmatch [regex]::Escape($installDir)) {
    Write-Host "Adding ZCode to your system PATH..."
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$installDir", "User")
    Write-Host "PATH updated. Please close and reopen your terminal to use the 'zcode' command from anywhere." -ForegroundColor Yellow
}

Write-Host "======================================" -ForegroundColor Green
Write-Host " ZCode installed successfully! 🚀" -ForegroundColor Green
Write-Host " You can now run it by typing: zcode" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
