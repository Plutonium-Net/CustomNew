$ErrorActionPreference = "Stop"

$Repo = "Plutonium-Net/CustomNew"
$InstallDir = Join-Path $env:LOCALAPPDATA "CustomNew"
$ApiUrl = "https://api.github.com/repos/$Repo/releases/latest"

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "          CustomNew Installer         " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check Windows
if ($env:OS -ne "Windows_NT") {
    throw "CustomNew is only supported on Windows."
}

# Detect architecture
if ([Environment]::Is64BitOperatingSystem) {
    $Architecture = "win-x64"
}
else {
    throw "32-bit Windows is not supported."
}

Write-Host "[1/5] Checking latest release..." -ForegroundColor Yellow

$Headers = @{
    "User-Agent" = "CustomNew-Installer"
}

$Release = Invoke-RestMethod `
    -Uri $ApiUrl `
    -Headers $Headers

if (-not $Release.assets) {
    throw "The latest GitHub release does not contain any downloadable assets."
}

$Asset = $Release.assets |
    Where-Object { $_.name -eq "CustomNew-$Architecture.zip" } |
    Select-Object -First 1

if (-not $Asset) {
    throw "Could not find CustomNew-$Architecture.zip in the latest release."
}

Write-Host "Found version $($Release.tag_name)." -ForegroundColor Green

# Temporary download location
$TempDir = Join-Path $env:TEMP "CustomNew-Install"
$ZipPath = Join-Path $TempDir $Asset.name

Write-Host "[2/5] Downloading CustomNew..." -ForegroundColor Yellow

if (Test-Path $TempDir) {
    Remove-Item $TempDir -Recurse -Force
}

New-Item -ItemType Directory -Path $TempDir | Out-Null

Invoke-WebRequest `
    -Uri $Asset.browser_download_url `
    -OutFile $ZipPath `
    -Headers $Headers

Write-Host "Download complete." -ForegroundColor Green

# Install
Write-Host "[3/5] Installing CustomNew..." -ForegroundColor Yellow

if (Test-Path $InstallDir) {
    Remove-Item $InstallDir -Recurse -Force
}

New-Item -ItemType Directory -Path $InstallDir | Out-Null

Expand-Archive `
    -Path $ZipPath `
    -DestinationPath $InstallDir `
    -Force

$ExePath = Join-Path $InstallDir "CustomNew.exe"

if (-not (Test-Path $ExePath)) {
    throw "CustomNew.exe was not found after extraction."
}

Write-Host "Installed to:" -ForegroundColor Green
Write-Host "  $InstallDir"

# Registry
Write-Host "[4/5] Registering File Explorer integration..." -ForegroundColor Yellow

$ShellKey = "HKCU:\Software\Classes\Directory\Background\shell\CustomNew"
$CommandKey = "$ShellKey\command"

if (Test-Path $ShellKey) {
    Remove-Item $ShellKey -Recurse -Force
}

New-Item -Path $ShellKey -Force | Out-Null
New-Item -Path $CommandKey -Force | Out-Null

Set-ItemProperty `
    -Path $ShellKey `
    -Name "(Default)" `
    -Value "Custom File..."

$Command = "`"$ExePath`" `"%V`""

Set-ItemProperty `
    -Path $CommandKey `
    -Name "(Default)" `
    -Value $Command

# Cleanup
Write-Host "[5/5] Cleaning up..." -ForegroundColor Yellow

Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "       CustomNew installed!           " -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Right-click inside a File Explorer folder"
Write-Host "and select:"
Write-Host ""
Write-Host "    Custom File..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed version: $($Release.tag_name)"
Write-Host ""

# Restart Explorer
Write-Host "Restarting File Explorer..." -ForegroundColor Yellow

Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500
Start-Process explorer.exe

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host ""