Set objShell = CreateObject("WScript.Shell")

objShell.Run "powershell -ExecutionPolicy Bypass -File "".\assets\clean.ps1""", 1, True

WScript.Echo "done cleaning..."
