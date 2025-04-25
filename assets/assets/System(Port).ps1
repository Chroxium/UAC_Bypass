<#
.SYNOPSIS
    Starts a specified executable under the TrustedInstaller account.
.DESCRIPTION
    This script ensures the NtObjectManager module is available, makes sure the TrustedInstaller service
    is running, and then spawns a child process under TrustedInstaller.
.PARAMETER Executable
    The path to the executable to launch (defaults to cmd.exe).
.EXAMPLE
    .\StartProcessAsTrustedInstaller.ps1 -Executable "powershell.exe"
#>
[CmdletBinding()]    
param(
    [Parameter(Mandatory = $false)]
    [string]$Executable = 'cmd.exe'
)

function Ensure-Module {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )
    if (-not (Get-Module -ListAvailable -Name $Name)) {
        Write-Host "Installing module '$Name'..."
        Register-PSRepository -Default
        Install-Module -Name $Name -Scope CurrentUser -Force -ErrorAction Stop
        Write-Host "Configuring PSGallery ..."
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction Stop
    }
    Import-Module -Name $Name -ErrorAction Stop
}

function Ensure-ServiceRunning {
    param(
        [Parameter(Mandatory)]
        [string]$ServiceName
    )
    $svc = Get-Service -Name $ServiceName -ErrorAction Stop
    if ($svc.Status -ne 'Running') {
        Write-Verbose "Starting service '$ServiceName'..."
        Start-Service -Name $ServiceName -ErrorAction Stop

        # Manually wait for the service to start (replacement for Wait-Service)
        $maxWait = 5
        $elapsed = 0
        while ((Get-Service -Name $ServiceName).Status -ne 'Running' -and $elapsed -lt $maxWait) {
            Start-Sleep -Seconds 1
            $elapsed++
        }
        if ((Get-Service -Name $ServiceName).Status -ne 'Running') {
            throw "Service '$ServiceName' failed to start within $maxWait seconds."
        }
    }
}

try {
    # Ensure required module is present
    Ensure-Module -Name 'NtObjectManager'

    # Make sure TrustedInstaller service is up
    Ensure-ServiceRunning -ServiceName 'TrustedInstaller'

    # Locate the TrustedInstaller process
    $tiProcess = (Get-NtProcess -Name 'TrustedInstaller.exe' -ErrorAction Stop | Select-Object -First 1)

    # Launch the desired executable as a child of TrustedInstaller
    Write-Verbose "Launching '$Executable' under TrustedInstaller (PID: $($tiProcess.ProcessId))..."
    $newProc = New-Win32Process $Executable -CreationFlags NewConsole -ParentProcess $tiProcess -ErrorAction Stop

    Write-Host "Successfully started '$Executable' (PID: $($newProc.ProcessId)) as user $($newProc.Process.User)"
}
catch {
    Write-Error "Error: $($_.Exception.Message)"
    exit 1
}