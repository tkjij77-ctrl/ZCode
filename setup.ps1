# ZCode Direct Auto-Installer
$ErrorActionPreference = "Continue"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   ZCode Auto Installer (Windows)     " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# 1. Check and Install Git
try {
    $null = Get-Command git -ErrorAction Stop
} catch {
    Write-Host "Installing Git..." -ForegroundColor Yellow
    winget install -e --id Git.Git --accept-source-agreements --accept-package-agreements --silent
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# 2. Check and Install Go
try {
    $null = Get-Command go -ErrorAction Stop
} catch {
    Write-Host "Installing Go..." -ForegroundColor Yellow
    winget install -e --id GoLang.Go --accept-source-agreements --accept-package-agreements --silent
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Test if it updated in session
    try {
        $null = Get-Command go -ErrorAction Stop
    } catch {
        Write-Host "Go was installed, but Windows needs a refresh." -ForegroundColor Red
        Write-Host "Please close this PowerShell window, open a new one, and run the command again." -ForegroundColor Red
        exit
    }
}

# 3. Setup Directories
$installDir = "$env:USERPROFILE\ZCode"

# 4. Clone or Update
if (Test-Path -Path $installDir) {
    Write-Host "Updating ZCode..." -ForegroundColor Yellow
    Set-Location -Path $installDir
    git pull origin main
} else {
    Write-Host "Downloading ZCode..." -ForegroundColor Green
    git clone https://github.com/tkjij77-ctrl/ZCode.git $installDir
    Set-Location -Path $installDir
}

# 5. Build & Run
Write-Host "Preparing ZCode (first run takes a moment)..." -ForegroundColor Yellow
go mod tidy
go run main.go
