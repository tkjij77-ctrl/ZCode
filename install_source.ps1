# ZCode Source Build Script for Windows
# This script will automatically install Go/Git if missing, clone the repo, and run ZCode.

$ErrorActionPreference = "Stop"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   Installing ZCode from Source...    " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# 1. Helper function to use winget for installation
function Install-WithWinget ($packageId, $name) {
    Write-Host "$name is not installed. Attempting to install via winget..." -ForegroundColor Yellow
    try {
        winget install -e --id $packageId --accept-source-agreements --accept-package-agreements
        Write-Host "Successfully installed $name. Refreshing environment variables..." -ForegroundColor Green
        
        # Refresh Path variable for the current session
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
    } catch {
        Write-Host "Failed to install $name automatically." -ForegroundColor Red
        Write-Host "Please install it manually and restart PowerShell." -ForegroundColor Red
        exit 1
    }
}

# 2. Check if Git is installed
try {
    $null = Get-Command git -ErrorAction Stop
} catch {
    Install-WithWinget "Git.Git" "Git"
    # Check again after install
    try { $null = Get-Command git -ErrorAction Stop } catch { Write-Host "Please restart PowerShell and try again." -ForegroundColor Yellow; exit 1 }
}

# 3. Check if Go is installed
try {
    $null = Get-Command go -ErrorAction Stop
} catch {
    Install-WithWinget "GoLang.Go" "Go"
    # Check again after install
    try { $null = Get-Command go -ErrorAction Stop } catch { Write-Host "Go was installed, but you must close and RESTART PowerShell for the changes to take effect. Then run the command again." -ForegroundColor Yellow; exit 1 }
}

# 4. Define directories
$installDir = "$env:USERPROFILE\ZCode"

# 5. Clone the repository
if (Test-Path -Path $installDir) {
    Write-Host "ZCode folder already exists at $installDir. Updating..." -ForegroundColor Yellow
    Set-Location -Path $installDir
    git pull origin main
} else {
    Write-Host "Cloning ZCode repository to $installDir..." -ForegroundColor Green
    git clone https://github.com/tkjij77-ctrl/ZCode.git $installDir
    Set-Location -Path $installDir
}

# 6. Build and run
Write-Host "Downloading dependencies and building ZCode... (This might take a minute)" -ForegroundColor Yellow
go mod tidy

Write-Host "Starting ZCode..." -ForegroundColor Green
go run main.go
