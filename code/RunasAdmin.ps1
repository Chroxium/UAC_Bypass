<#
.SYNOPSIS
    Launches an executable as Administrator (elevated).

.DESCRIPTION
    This PowerShell script dynamically compiles a small C# launcher with your specified 
    command and arguments, and then runs it as Administrator using COM Elevation 
    (via RunasAdmin.cs). You can choose to show or hide the window.

.PARAMETER Command
    The executable to run (e.g., "cmd.exe", "powershell.exe", "notepad.exe"). Default is "cmd.exe".

.PARAMETER Arguments
    Optional command-line arguments to pass to the executable.

.PARAMETER ShowWindow
    Set to 1 to show the window, or 0 to hide it. Default is 1 (visible).

.EXAMPLE
    .\RunasAdmin.ps1 -Command "cmd.exe"

    Starts Command Prompt as Administrator in a visible window.

.EXAMPLE
    .\RunasAdmin.ps1 -Command "powershell.exe" -Arguments "-NoExit -Command `"whoami`"" -ShowWindow 0

    Starts PowerShell as Administrator with the window hidden.

.NOTES
    - Requires the C# file (RunasAdmin.cs) to define a COM elevation helper.
    - You must have `RunasAdmin.cs` with static method: RunElevated(string exe, string args, int showWindow)
#>

param(
    [string]$Command = "cmd.exe",  
    [string]$Arguments = $null,         
    [int]$ShowWindow = 1
)

# Load COM elevation C# helper
Add-Type -Path ".\RunasAdmin.cs"

# Escape PowerShell strings to valid C# string literals
function Escape-CSharpString($str) {
    return '"' + ($str -replace '\\', '\\' -replace '"', '\"') + '"'
}
$Command = Escape-CSharpString $Command
$Arguments = Escape-CSharpString $Arguments

# Generate boolean value in C# syntax
$boolShowWindow = if ($ShowWindow -eq 0) { "true" } else { "false" }

# Create full embedded launcher code with values injected
$launcherCode = @"
using System;
using System.Diagnostics;

class ArgLauncher
{
    static void Main()
    {
        var psi = new ProcessStartInfo
        {
            FileName = $Command,
            Arguments = $Arguments,
            UseShellExecute = false,
            CreateNoWindow = $boolShowWindow
        };
        Process.Start(psi);
    }
}
"@

# Write and compile
$tempLauncher = "$env:TEMP\ArgLauncher.exe"
Add-Type -TypeDefinition $launcherCode -OutputAssembly $tempLauncher -OutputType ConsoleApplication

# Run the launcher as admin using COM elevation
[ElevationHelper]::RunElevated($tempLauncher, "", $ShowWindow)

# Wait a moment to ensure the process starts
Start-Sleep -Milliseconds 500

# Cleanup: remove temp EXE and debug source file
Remove-Item -Path $tempLauncher -Force -ErrorAction SilentlyContinue