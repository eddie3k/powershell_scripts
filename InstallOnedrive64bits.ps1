# Set the download URL for the OneDrive installer
$OneDriveURL = "https://go.microsoft.com/fwlink/p/?LinkID=2182910&clcid=0x409&culture=en-us&country=us"

# Specify the folder where you want to save the installer
$DownloadFolder = "C:\Windows\Temp"

# Set the name of the installer file
$InstallerFile = "OneDriveSetup.exe"

# Full path to the installer
$InstallerPath = Join-Path -Path $DownloadFolder -ChildPath $InstallerFile

# Check if OneDrive is already running
$OneDriveProcess = Get-Process -Name OneDrive -ErrorAction SilentlyContinue

if ($OneDriveProcess) {
    Write-Host "OneDrive is already running."
} else {
  
# Download the OneDrive installer
Invoke-WebRequest -Uri $OneDriveURL -OutFile $InstallerPath

# Check if the installer was downloaded successfully
if (!(Test-Path -Path $InstallerPath)) {
    Write-Host "Failed to download OneDrive installer."
} else {
        # Install OneDrive

    Start-Process -Wait -FilePath $InstallerPath -ArgumentList "/allusers"
    Write-Host "OneDrive installed successfully for all users." 
}}





