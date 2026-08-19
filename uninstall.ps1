$ErrorActionPreference = "Stop"

$InstallDir = Join-Path $env:LOCALAPPDATA "CustomNew"
$ShellKey = "HKCU:\Software\Classes\Directory\Background\shell\CustomNew"

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "         CustomNew Uninstaller        " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] Removing Explorer integration..." -ForegroundColor Yellow

if (Test-Path $ShellKey) {
    Remove-Item $ShellKey -Recurse -Force
    Write-Host "Explorer integration removed." -ForegroundColor Green
}
else {
    Write-Host "Explorer integration was not found." -ForegroundColor DarkGray
}

Write-Host "[2/3] Removing CustomNew..." -ForegroundColor Yellow

if (Test-Path $InstallDir) {
    Remove-Item $InstallDir -Recurse -Force
    Write-Host "CustomNew removed." -ForegroundColor Green
}
else {
    Write-Host "Installation directory was not found." -ForegroundColor DarkGray
}

Write-Host "[3/3] Restarting File Explorer..." -ForegroundColor Yellow

Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500
Start-Process explorer.exe

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "      CustomNew uninstalled!          " -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""