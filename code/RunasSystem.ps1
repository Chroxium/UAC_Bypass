<#
.SYNOPSIS
    Run any executable or command as TrustedInstaller using a temporary Windows Service.

.DESCRIPTION
    This PowerShell script dynamically compiles a minimal C# Windows Service that spawns a child process 
    (like cmd.exe or powershell.exe) under the TrustedInstaller security context. The compiled service 
    is registered, run, and then deleted.

.PARAMETER Command
    The command or executable to run as TrustedInstaller. If not provided, defaults to cmd.exe.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File RunasSystem.ps1
    → Launches an interactive cmd.exe as TrustedInstaller.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File RunasSystem.ps1 -Command "powershell.exe"
    → Launches PowerShell as TrustedInstaller and keeps the window open.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File RunasSystem.ps1 -Command "notepad.exe"
    → Opens Notepad as TrustedInstaller.

.NOTES
    - Requires Administrator privileges.
    - Uses temporary service named 'RunAsTI_SVC' and cleans up after itself.
    - Tested on Windows 10/11 with .NET Framework 4.0+ installed.
#>

param (
    [string]$Command = "cmd.exe"
)

$svc = "RunAsTI_SVC"
$exe = "$env:TEMP\RunAsTI.exe"

# Find C# compiler path (.NET Framework)
$csc = "${env:WINDIR}\Microsoft.NET\Framework\v4.0.30319\csc.exe"
if (!(Test-Path $csc)) {
    $csc = "${env:WINDIR}\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
}

# Write the C# source from external file
$csCodePath = ".\RunasSystem.cs"
if (!(Test-Path $csCodePath)) {
    Write-Error "Missing C# source file: $csCodePath"
    exit 1
}

# Compile service executable
& $csc /nologo /out:$exe /t:exe /reference:System.ServiceProcess.dll $csCodePath

# Create and start the temporary service with the command to execute
sc.exe create $svc binPath= "`"$exe `"$Command`"`"" start= demand type= own
sc.exe start $svc

# Wait a bit and clean up
Start-Sleep 3
sc.exe delete $svc
Remove-Item $exe -Force
