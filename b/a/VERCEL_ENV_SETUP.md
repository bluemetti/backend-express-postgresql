# 🔧 Configuração de Variáveis de Ambiente no Vercel

## ⚠️ PROBLEMA ATUAL
O servidor no Vercel está rodando, mas o MongoDB aparece como **"disconnected"** porque as variáveis de ambiente não estão configuradas no Vercel.

## 📋 Variáveis Necessárias

Acesse: https://vercel.com/dashboard → Selecione seu projeto **"b"** → Settings → Environment Variables

Configure as seguintes variáveis (todas para **Production, Preview e Development**):

### 1. NODE_ENV
```
production
```

### 2. MONGODB_URI_PRODUCTION
```
mongodb+srv://daviblumetti:D4vi1234@cluster0.zg2nt.mongodb.net/jwt-auth-db?retryWrites=true&w=majority&appName=Cluster0
```

### 3. JWT_SECRET
```
e64c60b2ce4429ceb041a6f19058f726f55f0eb56b452fcba2ac4e32957fa5c9
```

### 4. JWT_EXPIRES_IN
```
24h
```

### 5. BCRYPT_SALT_ROUNDS
```
12
```

## 🚀 Como Configurar

1. Acesse: https://vercel.com/dashboard
2. Selecione o projeto **"b"**
3. Vá em **Settings** → **Environment Variables**
4. Para cada variável:
   - Clique em **"Add New"**
   - **Key**: Nome da variável (ex: `NODE_ENV`)
   - **Value**: Valor correspondente
   - **Environments**: Selecione **Production**, **Preview** e **Development**
   - Clique em **Save**

## 🔄 Após Configurar

Depois de adicionar todas as variáveis, você tem 2 opções:

### Opção 1: Redeploy pelo Dashboard
- No Vercel Dashboard → Deployments → Clique nos 3 pontos do último deployment → **Redeploy**

### Opção 2: Redeploy por Commit
```bash
git commit --allow-empty -m "chore: trigger Vercel redeploy"
git push origin main
```

## ✅ Verificar se Funcionou

Após o redeploy, teste:

```bash
curl -s https://b-yeqy.vercel.app/health | jq '.'
```

O resultado deve mostrar:
```json
{
  "success": true,
  "message": "Server is running!",
  "timestamp": "...",
  "environment": "production",
  "database": {
    "status": "connected"  // ✅ Deve aparecer "connected"
  }
}
```

## 🧪 Testar Registro de Usuário

```bash
curl -X POST https://b-yeqy.vercel.app/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "Test@1234"
  }'
```

Resposta esperada (sucesso):
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {...},
    "token": "eyJhbGci..."
  }
}
```

---

**📝 Nota**: As variáveis de ambiente são sensíveis - não as compartilhe publicamente!
