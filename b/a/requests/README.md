# 📂 Pasta Requests - Scripts de Teste

Esta pasta contém scripts para testar a API em diferentes ambientes.

---

## 🌍 Ambientes Disponíveis

### LOCAL - MongoDB Docker (porta 3001)
- **URL:** `http://localhost:3001`
- **MongoDB:** Container Docker local
- **Uso:** Desenvolvimento e testes

### PRODUCTION - MongoDB Atlas (porta 3002)
- **URL:** `http://localhost:3002`
- **MongoDB:** Atlas Cloud
- **Uso:** Produção / Demonstração

---

## 🔄 Alternar Entre Ambientes

### Método Automático (RECOMENDADO):

```bash
./alternar-ambiente.sh
```

Escolha o ambiente e **todos os scripts** serão atualizados automaticamente!

### Método Manual:

Edite cada script `.sh` e altere a URL:

```bash
# Para LOCAL:
API_URL="http://localhost:3001"

# Para PRODUCTION:
API_URL="http://localhost:3002"
```

---

## 📋 Scripts Disponíveis

### Autenticação:
- `01-register-success.sh` - Registrar usuário
- `02-register-duplicate.sh` - Erro: email duplicado
- `03-register-weak-password.sh` - Erro: senha fraca
- `04-register-invalid-email.sh` - Erro: email inválido
- `05-register-missing-fields.sh` - Erro: campos obrigatórios
- `06-login-success.sh` - Login bem-sucedido
- `07-login-wrong-password.sh` - Erro: senha incorreta
- `08-login-user-not-found.sh` - Erro: usuário não encontrado
- `09-login-invalid-email.sh` - Erro: email inválido
- `10-login-missing-fields.sh` - Erro: campos faltando
- `11-login-malformed-json.sh` - Erro: JSON malformado

### Workouts:
- `13-workout-create-success.sh` - Criar workout
- `14-workout-list-all.sh` - Listar todos
- `15-workout-get-by-id.sh` - Buscar por ID
- `16-workout-update-put.sh` - Atualizar completo (PUT)
- `17-workout-update-patch.sh` - Atualizar parcial (PATCH)
- `18-workout-delete.sh` - Deletar workout
- `19-workout-no-token.sh` - Erro: sem token
- `20-workout-invalid-token.sh` - Erro: token inválido
- `21-workout-invalid-type.sh` - Erro: tipo inválido
- `22-workout-malformed-json.sh` - Erro: JSON malformado

### Utilitários:
- `get-token.sh` - Obter token JWT rapidamente
- `popular-ambientes.sh` - Popular ambos ambientes com dados
- `alternar-ambiente.sh` - Alternar entre LOCAL e PRODUCTION
- `run-all-tests.sh` - Executar todos os testes

---

## 🚀 Fluxo de Uso Básico

### 1️⃣ Escolher o Ambiente

```bash
./alternar-ambiente.sh
# Escolha 1 (LOCAL) ou 2 (PRODUCTION)
```

### 2️⃣ Registrar Usuário

```bash
./01-register-success.sh
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "user": { "id": "...", "name": "João Silva" },
    "token": "eyJhbGci..."
  }
}
```

### 3️⃣ Copiar o Token

Copie o valor do campo `token` da resposta.

### 4️⃣ Configurar Token nos Scripts

**Opção A:** Exportar variável de ambiente (temporário)
```bash
export TOKEN="eyJhbGci..."
```

**Opção B:** Editar cada script manualmente
```bash
nano 13-workout-create-success.sh
# Altere: TOKEN="seu-token-aqui"
```

### 5️⃣ Criar um Workout

```bash
./13-workout-create-success.sh
```

### 6️⃣ Listar Workouts

```bash
./14-workout-list-all.sh
```

### 7️⃣ Ver Estatísticas

```bash
./get-workout-stats.sh
```

---

## 🎯 Exemplos de Uso

### Testar Fluxo Completo em LOCAL:

```bash
# 1. Configurar ambiente
./alternar-ambiente.sh
# Escolha: 1 (LOCAL)

# 2. Registrar e fazer login
./01-register-success.sh

# 3. Copiar token e exportar
export TOKEN="eyJhbGci..."

# 4. Criar workout
./13-workout-create-success.sh

# 5. Listar workouts
./14-workout-list-all.sh
```

### Testar Fluxo Completo em PRODUCTION:

```bash
# 1. Configurar ambiente
./alternar-ambiente.sh
# Escolha: 2 (PRODUCTION)

# 2. Registrar novo usuário
./01-register-success.sh

# 3. Copiar token e exportar
export TOKEN="eyJhbGci..."

# 4. Criar workout
./13-workout-create-success.sh

# 5. Ver no Atlas
# Acesse: https://cloud.mongodb.com/
```

### Popular Ambos Ambientes:

```bash
./popular-ambientes.sh
```

Isso cria automaticamente:
- **LOCAL:** Usuário "João Silva" + 3 workouts
- **PRODUCTION:** Usuário "Maria Santos" + 4 workouts

---

## 🔐 Gerenciamento de Tokens

### Obter Token Rapidamente:

```bash
./get-token.sh
```

Isso faz login e exibe o token pronto para copiar.

### Tokens São Independentes!

⚠️ **IMPORTANTE:**
- Token do **LOCAL** ≠ Token do **PRODUCTION**
- Cada ambiente tem seus próprios usuários
- Ao trocar de ambiente, faça login novamente

### Token Expirou?

Tokens JWT expiram em **24 horas**. Se receber erro 401:

```bash
# Fazer login novamente
./06-login-success.sh

# Copiar novo token
export TOKEN="novo-token-aqui"
```

---

## 📊 Verificar Dados Criados

### LOCAL (Mongo Express):
```bash
# Abrir no navegador:
open http://localhost:8081
# Login: admin / admin123
```

### PRODUCTION (MongoDB Atlas):
```bash
# Abrir no navegador:
open https://cloud.mongodb.com/
# Database → Browse Collections → jwt-auth-db
```

---

## ⚠️ Troubleshooting

### "Connection refused"
**Causa:** Containers não estão rodando  
**Solução:**
```bash
cd /workspaces/backend-express-postgresql/b/a
docker-compose up -d
```

### "401 Unauthorized"
**Causa:** Token ausente ou expirado  
**Solução:**
```bash
./06-login-success.sh
export TOKEN="novo-token"
```

### "404 Not Found"
**Causa:** Endpoint incorreto ou ID inválido  
**Solução:** Verifique a URL no script

### "422 Validation Error"
**Causa:** Dados inválidos  
**Solução:** 
- Senha: 8+ chars, maiúscula, minúscula, número, especial
- Type: cardio, strength, flexibility, sports, other
- Exercises: array não vazio

### Script não executa
**Causa:** Sem permissão de execução  
**Solução:**
```bash
chmod +x *.sh
```

---

## 🎥 Para o Vídeo Demonstrativo

### Sequência Recomendada:

1. **Mostrar LOCAL:**
   ```bash
   ./alternar-ambiente.sh  # Escolha 1
   ./01-register-success.sh
   export TOKEN="..."
   ./13-workout-create-success.sh
   ./14-workout-list-all.sh
   ```
   - Abra Mongo Express: http://localhost:8081
   - Mostre os dados criados

2. **Mostrar PRODUCTION:**
   ```bash
   ./alternar-ambiente.sh  # Escolha 2
   ./01-register-success.sh  # Novo usuário
   export TOKEN="..."
   ./13-workout-create-success.sh
   ./14-workout-list-all.sh
   ```
   - Abra MongoDB Atlas: https://cloud.mongodb.com/
   - Mostre os dados no cloud

3. **Demonstrar Erros:**
   ```bash
   ./19-workout-no-token.sh  # 401
   ./21-workout-invalid-type.sh  # 422
   ```

---

## 📝 Notas Adicionais

- Todos os scripts usam `curl` e `jq` para formatação
- Saídas coloridas para melhor visualização
- Scripts são idempotentes (podem ser executados múltiplas vezes)
- Logs detalhados para debugging

---

**Última atualização:** 25/10/2025
