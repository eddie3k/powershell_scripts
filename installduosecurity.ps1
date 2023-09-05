# Ensure the script is being run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script needs to be run as an Administrator." -ForegroundColor Red
    Start-Self -Verb runAs
    exit
}

# URL for the installer
$url = "https://dl.duosecurity.com/duo-win-login-latest.exe"

# Download location (temp directory)
$outFile = "$env:TEMP\duo-win-login-latest.exe"

# Download the installer
Invoke-WebRequest -Uri $url -OutFile $outFile

# Arguments for the installation
$arguments = @(
    "/S /V`" /qn",
    "IKEY=FINDKEYINDUOADMIN",
    "SKEY=FINDKEYINDUOADMIN",
    "HOST=FINDHOSTINDUOADMIN",
    "AUTOPUSH=#1",
    "FAILOPEN=#1",
    "SMARTCARD=#0",
    "RDPONLY=#1"
)

# Install the program
Start-Process -Wait -FilePath $outFile -ArgumentList $arguments

# Cleanup downloaded file
Remove-Item -Path $outFile -Force

Write-Host "Installation completed." -ForegroundColor Green
