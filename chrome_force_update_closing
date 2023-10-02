# Ensure the script runs with administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "You need to have Administrator rights to run this script. Restarting with admin rights..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File $($MyInvocation.MyCommand)" -Verb RunAs
    exit
}

# Close all Chrome instances
Stop-Process -Name chrome -Force

# Trigger Google Chrome update
$chromeUpdatePath = "${Env:ProgramFiles(x86)}\Google\Update\GoogleUpdate.exe"
if (Test-Path $chromeUpdatePath) {
    Start-Process -FilePath $chromeUpdatePath -ArgumentList '/ua /taget=chrome'
} else {
    Write-Error "Cannot find GoogleUpdate.exe. Ensure Chrome is installed correctly."
    exit
}

# Give the updater some time to initiate the update
Start-Sleep -Seconds 20

# Restart Chrome
Start-Process -Name chrome

Write-Output "Update process initiated. Chrome should be updated and restarted."
