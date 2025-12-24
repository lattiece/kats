<#
    kats Windows Installation Script
    Installs the kats language analyzer tool globally on Windows
#>

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges to install globally."
    Write-Host "Please run PowerShell as Administrator and try again."
    exit 1
}

# Check if kats is already installed
$katsPath = "$env:ProgramFiles\kats\kats.ps1"
if (Test-Path -Path $katsPath) {
    Write-Host "kats is already installed at: $katsPath"
    Write-Host "You can run it using: & '$katsPath'"
    exit 0
}

# Create installation directory
$installDir = "$env:ProgramFiles\kats"
if (-not (Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# Copy the PowerShell script
Copy-Item -Path "$PSScriptRoot\windows\kats.ps1" -Destination "$installDir\kats.ps1" -Force

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

Write-Host "kats installed successfully!"
Write-Host ""
Write-Host "You can now run kats from anywhere:"
Write-Host "  kats [directory]"
Write-Host "  kats --help"
Write-Host ""

# Show version
& "$installDir\kats.ps1" --version