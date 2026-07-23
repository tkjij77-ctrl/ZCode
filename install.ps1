# ZCode Installation Script for Windows
# This script downloads the latest release of ZCode for Windows.

$ErrorActionPreference = "Stop"

$repo = "tkjij77-ctrl/ZCode"
$binaryName = "zcode.exe"
$installDir = "$env:USERPROFILE\.zcode\bin"

Write-Host "Installing ZCode from $repo..." -ForegroundColor Cyan

# Create installation directory if it doesn't exist
if (!(Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# In a real scenario, this would hit the GitHub Releases API to get the latest .exe
# Since we don't have a release yet, we will output a helpful message for the developer.

Write-Host "========================================================" -ForegroundColor Yellow
Write-Host "Note: ZCode does not have compiled Windows releases yet." -ForegroundColor Yellow
Write-Host "To run ZCode on Windows right now, please use Go:" -ForegroundColor White
Write-Host "1. Install Go from https://go.dev/dl/" -ForegroundColor White
Write-Host "2. Run: git clone https://github.com/tkjij77-ctrl/ZCode.git" -ForegroundColor White
Write-Host "3. Run: cd ZCode && go run main.go" -ForegroundColor White
Write-Host "========================================================" -ForegroundColor Yellow

# Future download logic (commented out until releases are built via GitHub Actions)
<#
$apiUrl = "https://api.github.com/repos/$repo/releases/latest"
$release = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
$asset = $release.assets | Where-Object { $_.name -match "windows" -and $_.name -match "amd64" }

if ($null -eq $asset) {
    Write-Host "Could not find a Windows release for ZCode." -ForegroundColor Red
    exit 1
}

$downloadUrl = $asset.browser_download_url
$destPath = "$installDir\$binaryName"

Write-Host "Downloading $($asset.name)..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $destPath

# Add to PATH if not already there
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notmatch [regex]::Escape($installDir)) {
    Write-Host "Adding $installDir to your PATH..."
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$installDir", "User")
    Write-Host "Please restart your terminal to use the 'zcode' command." -ForegroundColor Green
}

Write-Host "ZCode installed successfully!" -ForegroundColor Green
#>
