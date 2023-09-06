# Ensure the script runs with elevated permissions
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    exit
}

# Create COM object for Windows Update
$updateSession = New-Object -ComObject "Microsoft.Update.Session"
$updateSearcher = $updateSession.CreateUpdateSearcher()

# Search for updates
$searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Software'")

# Download and install updates
if ($searchResult.Updates.Count -gt 0) {
    $updatesToDownload = New-Object -ComObject "Microsoft.Update.UpdateColl"
    
    $searchResult.Updates | ForEach-Object {
        # Add to collection of updates to download
        $updatesToDownload.Add($_) | Out-Null
    }
    
    # Download updates
    $downloader = $updateSession.CreateUpdateDownloader()
    $downloader.Updates = $updatesToDownload
    $downloader.Download()
    
    # Install updates
    $installer = $updateSession.CreateUpdateInstaller()
    $installer.Updates = $updatesToDownload
    $installResult = $installer.Install()

    if ($installResult.ResultCode -eq 2) {
        Write-Output "Updates installed successfully!"
    } else {
        Write-Output "Failed to install updates. Result Code: $($installResult.ResultCode)"
    }
} else {
    Write-Output "No updates found."
}
