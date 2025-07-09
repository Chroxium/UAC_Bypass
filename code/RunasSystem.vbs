
Set s=CreateObject("Shell.Application"):s.ShellExecute "powershell.exe", "-nop -ep bypass -File RunasSystem.ps1", "", "runas", 1
