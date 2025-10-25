# 🚀 Guia Rápido - Insomnia Collection Atualizada

## ✅ Collection Corrigida

O arquivo `insomnia-collection.json` foi atualizado para funcionar corretamente com 2 ambientes.

---

## 📥 Como Importar

### 1️⃣ No Insomnia:

1. **Application** → **Preferences** → **Data** → **Import Data**
2. Selecione: `/workspaces/backend-express-postgresql/b/a/insomnia-collection.json`
3. Clique em **Import**

### 2️⃣ Você Verá:

- **Workspace:** "JWT Authentication API"
- **Ambientes:** (dropdown no topo)
  - Base Environment (não use diretamente)
  - **LOCAL - MongoDB Docker (porta 3001)** 🟣
  - **PRODUCTION - MongoDB Atlas (porta 3002)** 🟢

---

## 🔧 Configurar Ambiente

### Passo 1: Selecionar Ambiente

No dropdown do ambiente (canto superior), escolha:
- **LOCAL** para testar com MongoDB Docker
- **PRODUCTION** para testar com MongoDB Atlas

### Passo 2: Fazer Login

1. Abra a requisição **"Login - Success"**
2. Clique em **Send**
3. **Copie o token** da resposta

### Passo 3: Configurar Token

1. Pressione **Ctrl+E** (ou Cmd+E no Mac)
2. O ambiente selecionado já tem `base_url` configurado:
   - LOCAL: `http://localhost:3001`
   - PRODUCTION: `http://localhost:3002`
3. Cole o token no campo `"token": ""`
4. Salve (Ctrl+S)

---

## 🎯 Exemplo de Uso

### Testar Ambiente LOCAL:

1. **Selecione:** "LOCAL - MongoDB Docker (porta 3001)"

2. **Requisição:** "Register - Success"
   - Send → Cria usuário
   - Copie o token da resposta

3. **Configure o token:**
   - Ctrl+E
   - Cole no campo token
   - Ctrl+S

4. **Requisição:** "Workout - Create Success"
   - Send → Deve retornar 201 Created ✅

5. **Requisição:** "Workout - List All"
   - Send → Deve mostrar o workout criado ✅

### Testar Ambiente PRODUCTION:

1. **Selecione:** "PRODUCTION - MongoDB Atlas (porta 3002)"

2. **Requisição:** "Register - Success"
   - Use um email diferente!
   - Copie o novo token

3. **Configure o token:**
   - Ctrl+E
   - Cole o novo token
   - Ctrl+S

4. **Teste as requisições de workout**
   - Todos os workouts ficarão no MongoDB Atlas

---

## ⚠️ Problemas Comuns Resolvidos

### ❌ "URL using bad/illegal format or missing URL"
**RESOLVIDO!** Os ambientes agora têm URLs diretas:
- `"base_url": "http://localhost:3001"` (LOCAL)
- `"base_url": "http://localhost:3002"` (PRODUCTION)

### ✅ Como Verificar se Está Correto:

1. Pressione **Ctrl+E**
2. Selecione o ambiente (LOCAL ou PRODUCTION)
3. Você deve ver:
   ```json
   {
     "base_url": "http://localhost:3001",  // ou 3002
     "token": ""
   }
   ```

4. Se estiver vazio ou com `{{ _.base_url_local }}`, **reimporte a collection**!

---

## 📋 Estrutura da Collection

### Pastas Organizadas:

```
JWT Authentication API
├── 01 - Health Check
│   └── Health Check
├── 02 - Authentication
│   ├── 01 - Register
│   │   ├── Register - Success
│   │   ├── Register - Duplicate Email
│   │   ├── Register - Invalid Password
│   │   ├── Register - Invalid Email
│   │   └── Register - Malformed JSON
│   └── 02 - Login
│       ├── Login - Success
│       ├── Login - Wrong Password
│       ├── Login - User Not Found
│       ├── Login - Invalid Email
│       └── Login - Malformed JSON
└── 03 - Workouts
    ├── 01 - Success Cases
    │   ├── Workout - Create Success
    │   ├── Workout - List All
    │   ├── Workout - Get by ID
    │   ├── Workout - Update (PUT)
    │   ├── Workout - Update (PATCH)
    │   ├── Workout - Delete
    │   └── Workout - Get Statistics
    ├── 02 - Query Filters
    │   ├── Workout - Filter by Type
    │   ├── Workout - Filter by Date Range
    │   ├── Workout - Filter by Duration
    │   └── Workout - Filter by Calories
    └── 03 - Error Cases
        ├── Workout - No Token (401)
        ├── Workout - Invalid Token (401)
        ├── Workout - Invalid Type (422)
        ├── Workout - Empty Exercises (422)
        └── Workout - Malformed JSON (400)
```

---

## 🎥 Pronto para o Vídeo

### Checklist Final:

- [ ] Collection importada no Insomnia
- [ ] Ambiente LOCAL selecionável
- [ ] Ambiente PRODUCTION selecionável
- [ ] Ambos com `base_url` correto (não vazio)
- [ ] Token configurado em cada ambiente
- [ ] Requisições funcionando (201, 200)
- [ ] Erros demonstráveis (401, 422)

---

## 💡 Dicas Extras

1. **Cores dos Ambientes:**
   - LOCAL = Roxo 🟣
   - PRODUCTION = Verde 🟢

2. **Tokens São Independentes:**
   - Cada ambiente tem seus próprios usuários
   - Não use o mesmo token em ambos

3. **Atalhos Úteis:**
   - `Ctrl+E` - Abrir ambientes
   - `Ctrl+R` - Buscar requisição
   - `Ctrl+Enter` - Enviar requisição

4. **Visualizar Resposta:**
   - JSON formatado automaticamente
   - Status code visível
   - Headers disponíveis

---

**Tudo corrigido e funcionando!** 🎉

**Data:** 25/10/2025
