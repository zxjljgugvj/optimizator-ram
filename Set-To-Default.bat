@echo off
cd /d "%~dp0"

REM Enable Windows Update and Notifications.
echo Enabling Windows Update and Notifications...
sc config wuauserv start= auto >nul 2>&1
sc start wuauserv >nul 2>&1
sc config UsoSvc start= demand >nul 2>&1
sc start UsoSvc >nul 2>&1
sc config bits start= delayed-auto >nul 2>&1
sc start bits >nul 2>&1

reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f >nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /f >nul
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /f >nul

REM Enable scheduled tasks.
echo Enabling scheduled tasks...
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /Enable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\sih" /Enable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\sihboot" /Enable >nul 2>&1

REM Enable services.
echo Enabling services...
net start XblAuthManager >nul 2>&1
net start XblGameSave >nul 2>&1
net start XboxNetApiSvc >nul 2>&1
net start XboxGipSvc >nul 2>&1
net start Spooler >nul 2>&1
net start WSearch >nul 2>&1
net start SysMain >nul 2>&1
net start DiagTrack >nul 2>&1

echo. & echo Done! & pause
