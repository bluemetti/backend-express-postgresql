# 🎯 Guia Rápido - Insomnia com 2 Ambientes

## ✅ Collections Atualizadas

A collection completa foi atualizada com **2 ambientes**:

### Arquivo Disponível:
- **`insomnia-collection.json`** - Collection completa com todos os testes e 2 ambientes

---

## 🌍 Ambientes Configurados

### 1️⃣ LOCAL - MongoDB Docker (porta 3001)
- **URL:** `http://localhost:3001`
- **MongoDB:** Container Docker local
- **Uso:** Desenvolvimento e testes
- **Cor:** Roxo 🟣

### 2️⃣ PRODUCTION - MongoDB Atlas (porta 3002)
- **URL:** `http://localhost:3002`
- **MongoDB:** Atlas Cloud (cluster0.zg2nt.mongodb.net)
- **Uso:** Produção / Demonstração
- **Cor:** Verde 🟢

---

## 📥 Como Importar

### No Insomnia:

1. **Application** → **Preferences** → **Data** → **Import Data**
2. Selecione: `insomnia-collection.json`
3. Confirme a importação

Você verá **2 ambientes** no dropdown superior! ✅

---

## 🔄 Como Alternar Entre Ambientes

### No Insomnia:

1. Clique no **dropdown de ambiente** (canto superior)
2. Selecione:
   - **"LOCAL - MongoDB Docker"** (roxo 🟣) → Testa na porta 3001
   - **"PRODUCTION - MongoDB Atlas"** (verde 🟢) → Testa na porta 3002

### Atalho de Teclado:
- **Ctrl + E** (ou **Cmd + E**) → Abre o editor de ambientes

---

## 🎯 Fluxo de Teste Completo

### Para CADA Ambiente:

#### 1️⃣ Selecione o Ambiente
- Escolha **LOCAL** ou **PRODUCTION** no dropdown

#### 2️⃣ Registre um Usuário
- Requisição: **"Register - Success"**
- Clique **Send**

#### 3️⃣ Faça Login
- Requisição: **"Login - Success"**
- Clique **Send**
- **COPIE O TOKEN** da resposta

#### 4️⃣ Configure o Token no Ambiente
- Pressione **Ctrl + E**
- Cole o token no campo `"token": ""`
- Salve **Ctrl + S**

#### 5️⃣ Crie um Workout
- Requisição: **"Workout - Create Success"**
- Clique **Send**
- Deve retornar **201 Created** ✅

#### 6️⃣ Liste os Workouts
- Requisição: **"Workout - List All"**
- Clique **Send**
- Deve mostrar o workout criado ✅

#### 7️⃣ Veja Estatísticas
- Requisição: **"Workout - Get Statistics"**
- Clique **Send**
- Deve mostrar totais ✅

---

## 🔐 Tokens São Independentes!

⚠️ **IMPORTANTE:**

- Token do ambiente **LOCAL** ≠ Token do ambiente **PRODUCTION**
- Cada ambiente precisa de seu próprio token
- Tokens expiram em 24h

### Como Funciona:

```
LOCAL:
1. Login em http://localhost:3001/login → Token A
2. Configure Token A no ambiente LOCAL
3. Use Token A para workouts na porta 3001

PRODUCTION:
1. Login em http://localhost:3002/login → Token B
2. Configure Token B no ambiente PRODUCTION
3. Use Token B para workouts na porta 3002
```

---

## 📊 Visualizar Dados

### MongoDB Docker (LOCAL):
**Mongo Express:**
- URL: http://localhost:8081
- User: `admin`
- Pass: `admin123`
- Database: `jwt-auth-db`

### MongoDB Atlas (PRODUCTION):
**Atlas Web Interface:**
- URL: https://cloud.mongodb.com/
- Login com sua conta
- Navegue até **Database** → **Browse Collections**
- Database: `jwt-auth-db`

---

## 🎥 Para o Vídeo Demonstrativo

Mostre ambos os ambientes funcionando:

### 1️⃣ Ambiente LOCAL (desenvolvimento):
- Selecione **LOCAL - MongoDB Docker**
- Faça login
- Crie workouts
- Mostre no **Mongo Express** (localhost:8081)

### 2️⃣ Ambiente PRODUCTION (produção):
- Selecione **PRODUCTION - MongoDB Atlas**
- Faça login (com outro usuário)
- Crie workouts
- Mostre no **MongoDB Atlas Web** (cloud.mongodb.com)

### 3️⃣ Demonstre Erros:
- Requisição sem token → **401 Unauthorized**
- Tipo inválido → **422 Validation Error**

---

## ⚠️ Troubleshooting

### "Couldn't connect to server"
**Causa:** Containers não estão rodando  
**Solução:**
```bash
cd /workspaces/backend-express-postgresql/b/a
docker-compose up -d
```

### "401 Unauthorized"
**Causa:** Token ausente ou expirado  
**Solução:** Faça login novamente no ambiente correto

### "No body returned"
**Causa:** Ambiente errado selecionado  
**Solução:** Verifique se está usando o ambiente correto (LOCAL ou PRODUCTION)

### Token de um ambiente não funciona no outro
**Isso é NORMAL!** Cada ambiente tem seus próprios usuários e tokens.

---

## 📋 Checklist de Verificação

Antes de gravar o vídeo:

- [ ] Ambos containers rodando: `docker-compose ps`
- [ ] LOCAL health check: `curl http://localhost:3001/health`
- [ ] PRODUCTION health check: `curl http://localhost:3002/health`
- [ ] Collection importada no Insomnia
- [ ] 2 ambientes visíveis no dropdown
- [ ] Token configurado em cada ambiente
- [ ] Workouts criados em ambos ambientes
- [ ] Mongo Express acessível (LOCAL)
- [ ] MongoDB Atlas acessível (PRODUCTION)

---

## 🚀 Comandos Úteis

### Verificar Status:
```bash
cd /workspaces/backend-express-postgresql/b/a
docker-compose ps
```

### Ver Logs:
```bash
docker logs jwt-auth-app-local --tail 50
docker logs jwt-auth-app-atlas --tail 50
```

### Reiniciar Tudo:
```bash
docker-compose restart
```

### Parar Tudo:
```bash
docker-compose down
```

### Iniciar Tudo:
```bash
docker-compose up -d
```

---

**Pronto!** Agora você tem tudo configurado para demonstrar ambos os ambientes! 🎉

**Última atualização:** 25/10/2025
