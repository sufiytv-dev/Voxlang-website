# Enforce strict execution: No silent failures, no undefined variables.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$InstallDir = Join-Path $env:USERPROFILE ".vox\bin"
$VoxUrl = "https://github.com/sufiytv-dev/Voxlang/releases/download/v0.4-bootstrap/vxm-windows-amd64.exe"
$VoxPath = Join-Path $InstallDir "vox.exe"

Write-Host ""
Write-Host " VOXLANG " -BackgroundColor Black -ForegroundColor Cyan -NoNewline
Write-Host " Initializing native toolchain deployment..."

# 1. Prepare Sovereign Directory
if (-not (Test-Path $InstallDir)) {
    Write-Host " [+] Creating directory matrix at $InstallDir" -ForegroundColor DarkGray
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# 2. Download the binary directly
Write-Host " [+] Downloading Windows x64 binary..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $VoxUrl -OutFile $VoxPath -UseBasicParsing
    # Ensure the file is executable (PowerShell doesn't track execute bits, but this is Windows)
} catch {
    Write-Host " [!] Download failed. Ensure network connectivity and URI validity." -ForegroundColor Red
    exit 1
}

# 3. Path Mapping
$UserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($UserPath -notmatch [regex]::Escape($InstallDir)) {
    Write-Host " [+] Mapping environment variables..." -ForegroundColor Cyan
    $NewPath = "$UserPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("PATH", $NewPath, "User")
    # Update current session path
    $env:PATH = "$($env:PATH);$InstallDir"
} else {
    Write-Host " [v] Path already mapped." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host " >>> Deployment complete. The compiler is sound." -ForegroundColor Green
Write-Host " >>> Open a new terminal and run 'vox --version' to begin." -ForegroundColor DarkGray
Write-Host ""
