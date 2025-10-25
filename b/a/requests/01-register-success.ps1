# PowerShell version of the test script
Write-Host "=== REGISTRO BEM-SUCEDIDO ===" -ForegroundColor Green

$body = @{
    name = "João Silva"
    email = "joao.silva@email.com"
    password = "senha123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/register" `
        -Method POST `
        -ContentType "application/json" `
        -Body $body
    
    Write-Host "✅ Success:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Error:" -ForegroundColor Red
    $_.Exception.Response.StatusCode
    $_.Exception.Response | ConvertTo-Json -Depth 10
}
