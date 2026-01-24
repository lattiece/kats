<#
    kats Windows installer
    Downloads and installs kats globally on your system
#>

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This installer needs administrator privileges to install globally."
    Write-Host "Please run PowerShell as Administrator and try again."
    exit 1
}

# Check if curl is available (Windows 10 1803+ and Windows 11 have it built-in)
if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Error: curl is required but not found on your system."
    Write-Host "Please install curl or upgrade to Windows 10 version 1803 or later."
    exit 1
}

# Check if kats is already installed
$katsPath = "$env:ProgramFiles\kats\kats.ps1"
if (Test-Path -Path $katsPath) {
    Write-Host "kats is already installed at: $katsPath"
    Write-Host "Run 'kats --version' to check your current version."
    exit 0
}

Write-Host "Installing kats..."

# Create installation directory
$installDir = "$env:ProgramFiles\kats"
if (-not (Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# Download the kats PowerShell script from GitHub
$katsUrl = "https://raw.githubusercontent.com/laticee/kats/main/windows/kats.ps1"
$tempFile = "$installDir\kats.ps1"

try {
    Write-Host "Downloading kats from GitHub..."
    & curl.exe -sL $katsUrl -o $tempFile
    
    if (-not (Test-Path -Path $tempFile)) {
        throw "Download failed - file not created"
    }
}
catch {
    Write-Host "Error: Failed to download kats from $katsUrl"
    Write-Host "Please check your internet connection and try again."
    Write-Host "You can also install manually from: https://github.com/laticee/kats"
    exit 1
}

# Create a batch file wrapper for easier execution
$batchContent = @"
@echo off
powershell.exe -ExecutionPolicy Bypass -File "%ProgramFiles%\kats\kats.ps1" %*
"@

Set-Content -Path "$installDir\kats.bat" -Value $batchContent

# Add to PATH if not already there
$pathEnv = [Environment]::GetEnvironmentVariable("PATH", "Machine")
if ($pathEnv -notlike "*$installDir*") {
    $newPath = $pathEnv + ";$installDir"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
    Write-Host "Added $installDir to system PATH"
}

Write-Host ""
Write-Host "kats installed successfully!"
Write-Host ""
Write-Host "You can now run kats from anywhere:"
Write-Host "  kats [directory]"
Write-Host "  kats --help"
Write-Host ""

# Show version
& "$installDir\kats.ps1" --version