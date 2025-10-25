# PowerShell script to run all tests
Write-Host "🧪 EXECUTANDO TODOS OS TESTES DA API" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if server is running
try {
    $healthCheck = Invoke-RestMethod -Uri "http://localhost:3001/health" -Method GET -TimeoutSec 5
    Write-Host "✅ Servidor está rodando!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ Servidor não está rodando. Inicie o servidor com 'npm run dev'" -ForegroundColor Red
    Write-Host "   Execute: npm run dev" -ForegroundColor Yellow
    exit 1
}

# Test 1: Successful registration
Write-Host "📋 Teste 1: Registro bem-sucedido" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

$registerBody = @{
    name = "João Silva"
    email = "joao.silva@email.com"
    password = "senha123"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "http://localhost:3001/register" -Method POST -ContentType "application/json" -Body $registerBody
    Write-Host "✅ Registro realizado com sucesso!" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "⚠️  Usuário já existe (esperado em testes subsequentes)" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Erro no registro: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""

# Test 2: Successful login
Write-Host "📋 Teste 2: Login bem-sucedido" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

$loginBody = @{
    email = "joao.silva@email.com"
    password = "senha123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:3001/login" -Method POST -ContentType "application/json" -Body $loginBody
    $token = $loginResponse.data.token
    Write-Host "✅ Login realizado com sucesso!" -ForegroundColor Green
    Write-Host "Token obtido: $($token.Substring(0, 20))..." -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erro no login: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 3: Access protected route with valid token
Write-Host "📋 Teste 3: Acesso à rota protegida (token válido)" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

try {
    $headers = @{
        Authorization = "Bearer $token"
    }
    $protectedResponse = Invoke-RestMethod -Uri "http://localhost:3001/protected" -Method GET -Headers $headers
    Write-Host "✅ Acesso autorizado à rota protegida!" -ForegroundColor Green
    Write-Host "Mensagem: $($protectedResponse.data.message)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erro no acesso à rota protegida: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 4: Access protected route without token
Write-Host "📋 Teste 4: Acesso à rota protegida (sem token)" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

try {
    $protectedResponse = Invoke-RestMethod -Uri "http://localhost:3001/protected" -Method GET
    Write-Host "❌ Não deveria ter conseguido acessar sem token!" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✅ Acesso negado corretamente (sem token)" -ForegroundColor Green
    } else {
        Write-Host "❌ Erro inesperado: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""

# Test 5: Login with invalid credentials
Write-Host "📋 Teste 5: Login com credenciais inválidas" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

$invalidLoginBody = @{
    email = "joao.silva@email.com"
    password = "senhaerrada"
} | ConvertTo-Json

try {
    $invalidLoginResponse = Invoke-RestMethod -Uri "http://localhost:3001/login" -Method POST -ContentType "application/json" -Body $invalidLoginBody
    Write-Host "❌ Não deveria ter conseguido fazer login com senha errada!" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✅ Login negado corretamente (credenciais inválidas)" -ForegroundColor Green
    } else {
        Write-Host "❌ Erro inesperado: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""

# Test 6: Register with duplicate email
Write-Host "📋 Teste 6: Registro com email duplicado" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

$duplicateEmailBody = @{
    name = "Maria Santos"
    email = "joao.silva@email.com"
    password = "outrasenha123"
} | ConvertTo-Json

try {
    $duplicateResponse = Invoke-RestMethod -Uri "http://localhost:3001/register" -Method POST -ContentType "application/json" -Body $duplicateEmailBody
    Write-Host "❌ Não deveria ter conseguido registrar com email duplicado!" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "✅ Registro negado corretamente (email duplicado)" -ForegroundColor Green
    } else {
        Write-Host "❌ Erro inesperado: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎉 Todos os testes principais foram executados!" -ForegroundColor Green
Write-Host "Para testes mais detalhados, execute os scripts individuais na pasta requests/" -ForegroundColor Cyan
