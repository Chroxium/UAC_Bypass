 Check if the registry key exists and remove it if found
if (Test-Path "HKCU:\Software\Classes\ms-settings\shell\open\command") {
    Remove-Item -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Recurse -Force
} else {
    Write-Host "Registry key not found...(1/2)"
}

# Check if the folder exists and remove it if found
if (Test-Path "C:\myfolder") {
    Write-Host "C:\myfolder folder removed...(2/2)"
    Remove-Item -Path "C:\myfolder" -Recurse -Force
} else {
    Write-Host "Folder not found...(2/2)"
}
