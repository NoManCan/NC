rem @echo off
rem netsh advfirewall firewall delete rule name="File Transfer Program" dir=in
netsh advfirewall firewall add rule name="File Transfer Program" dir=in action=allow program="C:\windows\system32\ftp.exe" enable=yes
set "ch="
set /p ch=Choose mode Directory or File (D/F): 
if not defined ch (set ch=f)
if /i %ch%==d (goto Directory)
if /i %ch%==f (goto File)
:Directory
set "a="
set /p a=Enter Folder Path to Upload (Current Path is Default): 
if not defined a (set a=%cd%\*.*)
echo %a%
goto FTP
:File
::
::chk if the last letter is "\"
rem if /i %a:~-1%==\ (echo Directory)
set "a="
set /p a=Enter File Path to Upload (Accept Wildcard *): 
if not defined a (goto File)

:FTP
echo open 192.168.100.73> temp.txt
echo kali>> temp.txt
echo kali>> temp.txt
echo cd Desktop>> temp.txt
echo cd recieved>> temp.txt
echo pwd>> temp.txt
echo prompt>> temp.txt
echo mput "%a%">> temp.txt
echo disconnect>> temp.txt
echo quit>> temp.txt
ftp -s:temp.txt
del temp.txt
netsh advfirewall firewall delete rule name="File Transfer Program" dir=in
