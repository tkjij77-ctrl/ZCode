# ZCode Source Build Script for Windows
# This script will automatically clone the repo, install Go if needed, and run ZCode.

$ErrorActionPreference = "Stop"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   Installing ZCode from Source...    " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# 1. Check if Git is installed
try {
    $null = Get-Command git -ErrorAction Stop
} catch {
    Write-Host "Git is not installed. Please install Git from https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# 2. Check if Go is installed
try {
    $null = Get-Command go -ErrorAction Stop
} catch {
    Write-Host "Go is not installed. Please install Go from https://go.dev/dl/ and restart PowerShell." -ForegroundColor Red
    exit 1
}

# 3. Define directories
$installDir = "$env:USERPROFILE\ZCode"

# 4. Clone the repository
if (Test-Path -Path $installDir) {
    Write-Host "ZCode folder already exists at $installDir. Updating..." -ForegroundColor Yellow
    Set-Location -Path $installDir
    git pull origin main
} else {
    Write-Host "Cloning ZCode repository to $installDir..." -ForegroundColor Green
    git clone https://github.com/tkjij77-ctrl/ZCode.git $installDir
    Set-Location -Path $installDir
}

# 5. Build and run
Write-Host "Downloading dependencies and building ZCode... (This might take a minute)" -ForegroundColor Yellow
go mod tidy

Write-Host "Starting ZCode..." -ForegroundColor Green
go run main.go
