# 🌐 URLs de Acesso ao Projeto

## 📡 Ambiente Codespace (Desenvolvimento)

### API Backend
**URL Principal:** https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev

**Endpoints Principais:**
- Health Check: https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/health
- Register: POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/register
- Login: POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/login
- Workouts: https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts

### MongoDB - Interface Web (Mongo Express)
**URL:** https://expert-carnival-q7qx97v5grqqh96j6-8081.app.github.dev

**Credenciais:**
- Usuário: `admin`
- Senha: `admin123`

**Coleções:**
- `users` - Usuários cadastrados
- `workouts` - Treinos registrados

---

## 🚀 Ambiente Produção (Vercel)

**URL:** https://backend.daviblumetti.tech

**MongoDB:** MongoDB Atlas (cloud)

---

## 📥 Importar Collection no Insomnia

### Arquivo Disponível

**Collection Completa:**
```
b/a/insomnia-collection.json
```
- ✅ Todas as requisições (30+)
- ✅ Dois ambientes (LOCAL e PRODUCTION)
- ✅ Casos de erro detalhados

---

## 🧪 Testar Rapidamente

### Via Terminal (cURL)

```bash
# 1. Health Check
curl https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/health

# 2. Criar Usuário
curl -X POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Teste User",
    "email": "teste@email.com",
    "password": "Senha@123"
  }'

# 3. Fazer Login (copie o token retornado)
curl -X POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@email.com",
    "password": "Senha@123"
  }'

# 4. Criar Workout (substitua SEU_TOKEN)
curl -X POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN" \
  -d '{
    "name": "Treino Teste",
    "type": "strength",
    "duration": 60,
    "calories": 400,
    "exercises": [
      {
        "name": "Agachamento",
        "sets": 4,
        "reps": 12,
        "weight": 80
      }
    ],
    "notes": "Treino teste via API"
  }'

# 5. Listar Workouts (substitua SEU_TOKEN)
curl https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts \
  -H "Authorization: Bearer SEU_TOKEN"
```

### Via Scripts (dentro do Codespace)

```bash
cd /workspaces/backend-express-postgresql/b/a/requests

# Executar todos os testes
./run-all-tests.sh

# Ou testes individuais
./01-register-success.sh
./06-login-success.sh
./13-workout-create-success.sh
```

---

## 🔐 Configurar Token no Insomnia

Após fazer login:

1. **Copie o token** da resposta do login
2. **Abra o ambiente** (dropdown no canto superior)
3. **Clique no ícone de engrenagem** ⚙️
4. **Cole o token**:
   ```json
   {
     "base_url": "https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev",
     "token": "SEU_TOKEN_COMPLETO_AQUI"
   }
   ```
5. **Salve** (Ctrl+S ou CMD+S)

Agora todas as requisições protegidas funcionarão automaticamente! ✅

---

## 📊 Visualizar Dados no MongoDB

### Opção 1: Mongo Express (Interface Web)

1. Acesse: https://expert-carnival-q7qx97v5grqqh96j6-8081.app.github.dev
2. Login: `admin` / `admin123`
3. Navegue até: `jwt-auth-db` → Collections
4. Visualize:
   - `users` - Ver usuários cadastrados
   - `workouts` - Ver treinos registrados

### Opção 2: MongoDB Compass (Desktop)

1. Baixe: https://www.mongodb.com/try/download/compass
2. Conecte com: `mongodb://localhost:27017`
3. Database: `jwt-auth-db`

### Opção 3: VS Code Extension

1. Instale: MongoDB for VS Code
2. Conecte com: `mongodb://localhost:27017`
3. Explore collections visualmente

---

## 🎥 Para o Vídeo Demonstrativo

### URLs para Mostrar:

**API em funcionamento:**
- https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/health

**MongoDB com dados:**
- https://expert-carnival-q7qx97v5grqqh96j6-8081.app.github.dev

**Requisições no Insomnia:**
- Usar a collection importada
- Mostrar cadastro, login, criar workout, listar, estatísticas

**Casos de erro:**
- Sem token (401)
- Tipo inválido (422)
- Sem exercícios (422)

---

## ⚠️ Observações Importantes

1. **Porta Pública:** As portas 3001 e 8081 estão configuradas como públicas no Codespace
2. **Token Expira:** Tokens JWT expiram em 24h - faça login novamente se necessário
3. **Ambiente Temporário:** URLs do Codespace mudam se você recriar o ambiente
4. **Produção:** Para produção real, use a URL da Vercel configurada

---

## 🆘 Problemas Comuns

### ❌ "Couldn't connect to server"
- Verifique se o Docker está rodando: `docker ps`
- Reinicie os containers: `docker-compose restart`
- Verifique se as portas estão públicas

### ❌ "401 Unauthorized"
- Token expirado ou inválido
- Faça login novamente
- Atualize o token no ambiente do Insomnia

### ❌ "422 Validation Error"
- Verifique o formato dos dados
- Senha deve ter: 8+ chars, maiúscula, minúscula, número, caractere especial
- Exercises não pode ser array vazio

---

**Última atualização:** 24/10/2025
**Codespace:** expert-carnival-q7qx97v5grqqh96j6
