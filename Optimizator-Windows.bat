@echo off
cd /d "%~dp0"

REM Disabling Windwos Update and Notifications.
echo Disabling Windows Update and Notifications...
sc config wuauserv start= disabled >nul 2>&1
sc config UsoSvc start= disabled >nul 2>&1
sc config bits start= disabled >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul

echo Success! & echo.
timeout /t 1 /nobreak >nul

REM Loop.
:Loop

REM Getting the RAM amount.
powershell -command "Get-CimInstance Win32_OperatingSystem | ForEach-Object { Write-Output (' {0:N2} GB / Total: {1:N2} GB' -f (($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)/1MB), ($_.TotalVisibleMemorySize/1MB)) }"

REM Clearing TEMP.
del /q /f /s %TEMP%\* >nul 2>&1
del /q /f /s C:\Windows\Temp\* >nul 2>&1

REM Clearing DNS.
ipconfig /flushdns >nul

REM Clearing RAM.
powershell -command "Get-Process | Where-Object { $_.Id -ne $PID } | ForEach-Object { try { $_.MinWorkingSet = $_.MinWorkingSet } catch {} }"
if exist "%~dp0RAMMap\RAMMap64.exe" (
	"%~dp0RAMMap\RAMMap64.exe" -Et -Es -Em -Ew
)
timeout /t 1 /nobreak >nul

REM Disable services.
powercfg /setactive SCHEME_MIN
net stop XblAuthManager /y >nul 2>&1
net stop XblGameSave /y >nul 2>&1
net stop XboxNetApiSvc /y >nul 2>&1
net stop XboxGipSvc /y >nul 2>&1
net stop Spooler /y >nul 2>&1
net stop WSearch /y >nul 2>&1
net stop SysMain /y >nul 2>&1
net stop DiagTrack /y >nul 2>&1

goto Loop