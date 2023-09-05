# Ensure the script is being run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script needs to be run as an Administrator." -ForegroundColor Red
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File", $PSCommandPath -Verb RunAs
    exit
}

# Try to get the uninstall string from the registry
$uninstallInfo = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* |
                   Where-Object { $_.DisplayName -like "Duo*" }

if (-not $uninstallInfo) {
    Write-Host "Duo Security does not appear to be installed." -ForegroundColor Red
    exit
}

$uninstallString = $uninstallInfo.UninstallString

# If it looks like an MSI uninstaller, add the necessary parameters for silent uninstall
if ($uninstallString -like "msiexec*") {
    $uninstallString = "$uninstallString /quiet /norestart"
}

# Execute the uninstall string
Start-Process -Wait -FilePath cmd.exe -ArgumentList "/c", $uninstallString

Write-Host "Uninstallation initiated." -ForegroundColor Green
