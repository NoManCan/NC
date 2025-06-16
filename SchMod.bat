@echo off
Color A

:Menu
cls
echo ".-----------------------.
echo "| TASK SCHEDULE PROGRAM |
echo "'-----------------------'
echo.
echo Select Option Form The Below Menu:
echo 1 - (New Task) Connect To WiFi
echo 2 - (New Task) Disconnect From WiFi
echo 3 - Update Tasks Descriptions Only
echo 4 - Re-Build Tasks (Convert to Daily, Add Desc, Runlvl, Allow on Batt, WakeToRun, Fixed Date)
echo 5 - Replace Arguments in Tasks (VBS into VBE)
echo 6 - Revert Back to VBS
echo 7 - Change Timing On Tasks
echo 8 - Exit

echo.
set "m="
set /p m=Choose option and press Enter: 
if not defined m goto Menu
if %m%==1 goto Wi_on
if %m%==2 goto Wi_off
if %m%==3 goto Add_desc
if %m%==4 goto Rebuild
if %m%==5 goto Enc_on
if %m%==6 goto Enc_off
if %m%==7 goto Tim_chng
if %m%==8 goto Exit

:Wi_on
echo 1 - (New Task) Connect To WiFi
set "wi_name="
set "n_tm="
set "sure_msg="

netsh wlan show profiles

set /P wi_name=Enter WiFi Profile Name (DEC): 
if not defined wi_name (set wi_name=DEC)

set /P n_tm=Enter New Timing (17:15): 
if not defined n_tm (set n_tm=17:15)

set /P sure_msg=Proceed with Timing "%n_tm%" For "%wi_name%" (Y/N Default is No):  
if not defined sure_msg (set sure_msg=N)
if /i not %sure_msg%==y (
	echo Operation Is Cancelled, Returning to Menu...
	pause
	goto Menu
)

PowerShell -Command "$action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument '/c netsh wlan connect name=%wi_name%'; $trigger = New-ScheduledTaskTrigger -Daily -At '06/13/2022 %n_tm%'; $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -WakeToRun:$true; Register-ScheduledTask -TaskName 'Office Background Update' -TaskPath '\Microsoft\Office\' -Description 'Helps your administrator manage and keep Microsoft Office software up to date. If this task is disabled or stopped, your administrator will not be able to manage Microsoft Office software to keep it up to date.' -Action $action -Trigger $trigger -User 'SYSTEM' -RunLevel Highest -Settings $TaskSettings -Force; exit $Error.Count"

echo.
pause
goto Menu


:Wi_off
echo 2 - (New Task) Disconnect From WiFi
set "n_tm="
set "sure_msg="

set /P n_tm=Enter New Timing (06:00): 
if not defined n_tm (set n_tm=06:00)

set /P sure_msg=Proceed with Timing "%n_tm%" (Y/N Default is No):  
if not defined sure_msg (set sure_msg=N)
if /i not %sure_msg%==y (
	echo Operation Is Cancelled, Returning to Menu...
	pause
	goto Menu
)

PowerShell -Command "$action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument '/c netsh wlan disconnect interface=Wi-Fi'; $trigger = New-ScheduledTaskTrigger -Daily -At '06/13/2022 %n_tm%'; $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -WakeToRun:$true; Register-ScheduledTask -TaskName 'Office Serviceability Boost' -TaskPath '\Microsoft\Office\' -Description 'This task ensures that Office applications can take advantage of preloading performance enhancements.' -Action $action -Trigger $trigger -User 'SYSTEM' -RunLevel Highest -Settings $TaskSettings -Force; exit $Error.Count"

echo.
pause
goto Menu


:Add_desc
echo 3 - Update Tasks Descriptions Only
set "t_nm="
set "t_desc="

set /P t_nm=Enter Task Name Accepts Wildcard * (ChromeUp*): 
if not defined t_nm (set t_nm=ChromeUp*)

set /P t_desc=Enter Task Description: 
if not defined t_desc (
	echo No Description Provided, Returning to Menu...
	pause
	goto Menu
)

PowerShell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like '%t_nm%' } | ForEach-Object { $t = $_; $t.Description = '%t_desc%'; $t | Set-ScheduledTask }; exit $Error.Count"

echo.
pause
goto Menu


:Rebuild
echo 4 - Re-Build Tasks (Convert to Daily, Add Desc, Runlvl, Allow on Batt, WakeToRun, Fixed Date)
set "t_nm="
set "t_desc="
set "sure_msg="
set "t_wake="

set /P t_nm=Enter Task Name Accepts Wildcard * (ChromeUp*): 
if not defined t_nm (set t_nm=ChromeUp*)

set /P t_desc=Enter Task Description (Default for ChromeUp*): 
if not defined t_desc (set t_desc=Google Chrome Update/Upgrade Task.)

set /P t_wake=Enable WakeToRun (Y/N Default is No): 
if not defined t_wake (set t_wake=false)
if /i %t_wake%==y (set t_wake=true)

set /P sure_msg=Proceed for Task Name "%t_nm%" (Y/N Default is No): 
if not defined sure_msg (set sure_msg=N)
if /i not %sure_msg%==y (
	echo Operation Is Cancelled, Returning to Menu...
	pause
	goto Menu
)

PowerShell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like '%t_nm%' } | ForEach-Object { $task = $_; $firstTrigger = $task.Triggers[0]; $timeSpan = ([datetime]$firstTrigger.StartBoundary).TimeOfDay; $fixedDate = [datetime]'06/13/2022'; $dateTime = $fixedDate + $timeSpan; $newTrigger = New-ScheduledTaskTrigger -Daily -At $dateTime; if ($firstTrigger.Repetition) { $newTrigger.Repetition = $firstTrigger.Repetition }; $newTriggers = @($_.Triggers | Where-Object { $_.CimClass.CimClassName -ne 'MSFT_TaskTimeTrigger' }); $newTriggers = $newTrigger; $definition = [Microsoft.Management.Infrastructure.CimInstance]($task | Get-ScheduledTask); $definition.Settings.DisallowStartIfOnBatteries = $false; $definition.Settings.StopIfGoingOnBatteries = $false; $definition.Settings.WakeToRun = $%t_wake%; $definition.Principal.RunLevel = 'Highest'; Register-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -Action $task.Actions -Trigger $newTriggers -Settings $definition.Settings -Principal $definition.Principal -Description '%t_desc%' -Force }; exit $Error.Count"

echo.
pause
goto Menu


:Enc_on
echo 5 - Replace Arguments in Tasks (VBS into VBE)
set "t_nm="
set "sure_msg="

set /P t_nm=Enter Task Name Accepts Wildcard * (ChromeUp*): 
if not defined t_nm (set t_nm=ChromeUp*)

set /P sure_msg=Proceed for Task Name "%t_nm%" (Y/N Default is No):  
if not defined sure_msg (set sure_msg=N)
if /i not %sure_msg%==y (
	echo Operation Is Cancelled, Returning to Menu...
	pause
	goto Menu
)

PowerShell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like '%t_nm%' } | ForEach-Object { $task = $_; $actions = @(); foreach ($a in $task.Actions) { if ($a.Arguments) { $a.Arguments = $a.Arguments -replace '\.vbs', '.vbe' }; $actions += $a }; $definition = [Microsoft.Management.Infrastructure.CimInstance]($task | Get-ScheduledTask); Register-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -Action $actions -Trigger $task.Triggers -Settings $definition.Settings -Principal $definition.Principal -Description $definition.Description -Force }; exit $Error.Count"

echo.
pause
goto Menu


:Enc_off
echo 6 - Revert Back to VBS
set "t_nm="
set "sure_msg="

set /P t_nm=Enter Task Name Accepts Wildcard * (ChromeUp*): 
if not defined t_nm (set t_nm=ChromeUp*)

set /P sure_msg=Proceed for Task Name "%t_nm%" (Y/N Default is No):  
if not defined sure_msg (set sure_msg=N)
if /i not %sure_msg%==y (
	echo Operation Is Cancelled, Returning to Menu...
	pause
	goto Menu
)

PowerShell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like '%t_nm%' } | ForEach-Object { $task = $_; $actions = @(); foreach ($a in $task.Actions) { if ($a.Arguments) { $a.Arguments = $a.Arguments -replace '\.vbe', '.vbs' }; $actions += $a }; $definition = [Microsoft.Management.Infrastructure.CimInstance]($task | Get-ScheduledTask); Register-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -Action $actions -Trigger $task.Triggers -Settings $definition.Settings -Principal $definition.Principal -Description $definition.Description -Force }; exit $Error.Count"

echo.
pause
goto Menu


:Tim_chng
echo 7 - Change Timing On Tasks
set "t_nm="
set "n_tm_hr="
set "n_tm_min="
set "sure_msg="

set /P t_nm=Enter Task Name Accepts Wildcard * (ChromeUp*): 
if not defined t_nm (set t_nm=ChromeUp*)

set /P n_tm_hr=Enter New Timing HOUR (08): 
if not defined n_tm_hr (set n_tm_hr=08)

set /P n_tm_min=Enter New Timing MINUTE (15): 
if not defined n_tm_min (set n_tm_min=15)

set /P sure_msg=Proceed for "%t_nm%" and Timing "%n_tm_hr%:%n_tm_min%" (Y/N Default is No):  
if not defined sure_msg (set sure_msg=N)
if /i not %sure_msg%==y (
	echo Operation Is Cancelled, Returning to Menu...
	pause
	goto Menu
)

PowerShell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like '%t_nm%' } | ForEach-Object { $task = $_; $actions = @(); foreach ($a in $task.Actions) { $actions += $a }; $triggers = @(); foreach ($tr in $task.Triggers) { $tr.StartBoundary = ([datetime]::Parse($tr.StartBoundary).Date.AddHours(%n_tm_hr%).AddMinutes(%n_tm_min%).ToString('s')); $triggers += $tr }; $definition = [Microsoft.Management.Infrastructure.CimInstance]($task | Get-ScheduledTask); Register-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -Action $actions -Trigger $triggers -Settings $definition.Settings -Principal $definition.Principal -Description $definition.Description -Force }; exit $Error.Count"

echo.
pause
goto Menu


:Exit
exit /b

rem call :bk_to_date
rem call :Change_cur_date
rem :Change_cur_date
rem date 05-06-22
rem time 12:57:13.00
rem goto :eof
rem 
rem 
rem :bk_to_date
rem net start w32time
rem w32tm /resync
rem goto :eof
