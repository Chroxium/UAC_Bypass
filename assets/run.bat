@ECHO OFF
cd %~dp0

:: Run the PowerShell script
powershell -Nop -ExecutionPolicy Bypass -File "menu.ps1"
FOR /F "usebackq tokens=*" %%Q IN (`powershell -Nop -C "Add-Type -A System.Windows.Forms;$f=New-Object Windows.Forms.OpenFileDialog;if($f.ShowDialog()-eq'OK'){$f.FileName}"`) DO SET file=%%Q
call flags

if "%mode%"=="1" ( goto :Admin )
if "%mode%"=="2" ( goto :System )

goto :eof

:Admin
if not exist "C:\myfolder" ( mkdir "C:\myfolder" )
powershell -Nop -ExecutionPolicy Bypass -File "admin.ps1" -file "%file%"
goto :eof

:System
schtasks /delete /tn "RunAsSystem" /f >NUL 2>&1
schtasks /create /tn "RunAsSystem" /tr "cmd.exe /C start %file%" /sc once /st 00:00 /ru SYSTEM /IT >NUL 2>&1
schtasks /run /tn "RunAsSystem" >NUL 2>&1
goto :eof