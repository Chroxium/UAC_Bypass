# Check if the registry key exists and remove it if found
if (Test-Path "HKCU:\Software\Classes\ms-settings\shell\open\command") {
    Remove-Item -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Recurse -Force
} else {
    Write-Host "Registry key not found...(1/4)"
}

# Check if the folder exists and remove it if found
if (Test-Path "C:\myfolder") {
    Write-Host "C:\myfolder folder removed...(2/4)"
    Remove-Item -Path "C:\myfolder" -Recurse -Force
} else {
    Write-Host "Folder not found...(2/4)"
}


# Check if PSGallery repository exists
$repo = Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue
if ($repo) {
    # Remove the PSGallery repository if it was previously set
    Unregister-PSRepository -Name PSGallery
    Write-Host "PSGallery repository removed...(3/4)"
} else {
    Write-Host "PSGallery repository not found...(3/4)"
}

# Check if the module is installed
$module = Get-InstalledModule -Name NtObjectManager -ErrorAction SilentlyContinue
if ($module) {
    # Uninstall the NtObjectManager module if it exists
    Uninstall-Module -Name NtObjectManager -Force
    Write-Host "NtObjectManager module uninstalled...(4/4)"
} else {
    Write-Host "NtObjectManager module not found...(4/4)"
}
