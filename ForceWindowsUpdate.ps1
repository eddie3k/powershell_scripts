# Must run this script as admin
# Create COM object for Windows Update
$updateSession = New-Object -ComObject "Microsoft.Update.Session"
$updateSearcher = $updateSession.CreateUpdateSearcher()

# Search for updates
$searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Software'")

# Download and install updates
if ($searchResult.Updates.Count -gt 0) {
    $updatesToDownload = New-Object -ComObject "Microsoft.Update.UpdateColl"
    
    $searchResult.Updates | ForEach-Object {
        # Check if update is not already downloaded
        if ($_.IsDownloaded -eq $false) {
            # Add to collection of updates to download
            $updatesToDownload.Add($_) | Out-Null
        }
    }
    
    # If there are updates to download
    if ($updatesToDownload.Count -gt 0) {
        # Download updates
        $downloader = $updateSession.CreateUpdateDownloader()
        $downloader.Updates = $updatesToDownload
        $downloader.Download()
        
        # Collection for updates to install
        $updatesToInstall = New-Object -ComObject "Microsoft.Update.UpdateColl"
        
        # Select the downloaded updates to install
        $searchResult.Updates | ForEach-Object {
            if ($_.IsDownloaded) {
                $updatesToInstall.Add($_) | Out-Null
            }
        }
        
        # Install updates
        $installer = $updateSession.CreateUpdateInstaller()
        $installer.Updates = $updatesToInstall
        $installResult = $installer.Install()

        if ($installResult.ResultCode -eq 2) {
            Write-Output "Updates installed successfully!"
        } else {
            Write-Output "Failed to install updates. Result Code: $($installResult.ResultCode)"
        }
    } else {
        Write-Output "Updates already downloaded."
    }
} else {
    Write-Output "No updates found."
}
