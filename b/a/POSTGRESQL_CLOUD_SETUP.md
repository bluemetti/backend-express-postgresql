# 🌐 Configuração PostgreSQL na Nuvem

Guia completo para configurar PostgreSQL na nuvem (gratuito) e conectar sua aplicação.

## 📋 Opções de Hospedagem PostgreSQL (Gratuitas)

### 🥇 Opção 1: Neon.tech (RECOMENDADO)
- ✅ **Gratuito para sempre**
- ✅ 0.5 GB armazenamento
- ✅ Conexões ilimitadas
- ✅ Serverless (escala automaticamente)
- ✅ SSL por padrão
- ⚡ Setup mais rápido

### 🥈 Opção 2: Supabase
- ✅ 500 MB armazenamento
- ✅ Até 2 GB transferência
- ✅ PostgreSQL + APIs REST automáticas
- ✅ Dashboard integrado

### 🥉 Opção 3: Render
- ✅ 90 dias gratuito
- ✅ PostgreSQL 16
- ✅ 1 GB armazenamento

---

## 🚀 Setup Neon.tech (Recomendado)

### Passo 1: Criar Conta

```bash
# Acesse:
open https://neon.tech
```

1. Clique em **"Sign Up"**
2. Escolha GitHub, Google ou Email
3. Confirme seu email

### Passo 2: Criar Projeto

1. Clique em **"New Project"**
2. Configure:
   - **Project name**: `workout-tracker-api`
   - **Region**: Escolha o mais próximo (ex: `US East`)
   - **PostgreSQL version**: `16`
   - **Compute size**: `0.25 vCPU` (gratuito)

3. Clique em **"Create Project"**

### Passo 3: Obter Connection String

Após criar o projeto, você verá uma **Connection String** assim:

```
postgresql://user:password@ep-xxx.us-east-2.aws.neon.tech/database?sslmode=require
```

**Copie essa string completa!**

### Passo 4: Configurar .env

No seu arquivo `.env` local (ou nas variáveis de ambiente do Codespaces):

```bash
# Adicione a variável DATABASE_URL
DATABASE_URL=postgresql://user:password@ep-xxx.us-east-2.aws.neon.tech/database?sslmode=require
```

### Passo 5: Testar Conexão com Docker

```bash
# Parar containers locais
docker-compose down

# Subir apenas a aplicação em modo cloud
docker-compose up -d app-cloud

# Ver logs
docker-compose logs -f app-cloud

# Você deve ver:
# ✅ PostgreSQL Connected: database_name
```

### Passo 6: Verificar Health Check

```bash
# Se estiver no Codespaces, obtenha a URL pública da porta 3002:
gh codespace ports -c $CODESPACE_NAME

# Teste o health check
curl https://SEU-CODESPACE-3002.app.github.dev/health | jq .
```

Resposta esperada:
```json
{
  "success": true,
  "message": "Server is running!",
  "database": {
    "status": "connected",
    "name": "neondb"
  }
}
```

---

## 🔧 Setup Supabase

### Passo 1: Criar Conta

```bash
open https://supabase.com
```

1. Clique em **"Start your project"**
2. Login com GitHub

### Passo 2: Criar Projeto

1. Clique em **"New Project"**
2. Configure:
   - **Name**: `workout-tracker-api`
   - **Database Password**: Crie uma senha forte (anote!)
   - **Region**: Escolha o mais próximo
   - **Pricing Plan**: `Free`

3. Aguarde 2-3 minutos (criação do banco)

### Passo 3: Obter Connection String

1. No menu lateral, clique em **"Project Settings"** (ícone de engrenagem)
2. Clique em **"Database"**
3. Role até **"Connection string"**
4. Selecione **"URI"** mode
5. Copie a string (exemplo):

```
postgresql://postgres.xxxxx:password@aws-0-us-east-1.pooler.supabase.com:5432/postgres
```

### Passo 4: Configurar e Testar

```bash
# Configure DATABASE_URL no .env
DATABASE_URL=postgresql://postgres.xxxxx:password@...

# Teste com docker
docker-compose up -d app-cloud
docker-compose logs -f app-cloud
```

---

## 🎯 Setup Render

### Passo 1: Criar Conta

```bash
open https://render.com
```

1. Clique em **"Get Started"**
2. Login com GitHub

### Passo 2: Criar Database

1. No Dashboard, clique em **"New +"**
2. Selecione **"PostgreSQL"**
3. Configure:
   - **Name**: `workout-tracker-db`
   - **Database**: `workoutdb`
   - **User**: `workoutuser`
   - **Region**: Escolha o mais próximo
   - **PostgreSQL Version**: `16`
   - **Plan**: `Free`

4. Clique em **"Create Database"**

### Passo 3: Obter Connection String

1. Após criação, vá em **"Info"**
2. Procure por **"External Database URL"**
3. Copie a string (formato):

```
postgresql://user:password@hostname:5432/database
```

### Passo 4: Adicionar SSL

A string do Render **NÃO** vem com `?sslmode=require` por padrão. Adicione:

```bash
# ❌ String original:
postgresql://user:pass@hostname:5432/database

# ✅ String corrigida (adicione ?sslmode=require):
DATABASE_URL=postgresql://user:pass@hostname:5432/database?sslmode=require
```

### Passo 5: Testar

```bash
docker-compose up -d app-cloud
docker-compose logs -f app-cloud
```

---

## 🧪 Testar Aplicação Cloud

### 1. Obter URL Pública do Codespaces

```bash
# Listar portas públicas
gh codespace ports

# Ou acessar manualmente:
# GitHub → Codespaces → Seu codespace → Ports tab
# Tornar porta 3002 pública (botão de visibilidade)
```

A URL será algo como:
```
https://expert-carnival-q7qx97v5grqqh96j6-3002.app.github.dev
```

### 2. Testar Endpoints

```bash
# Health check
curl https://SEU-CODESPACE-3002.app.github.dev/health | jq .

# Registrar usuário
curl -X POST https://SEU-CODESPACE-3002.app.github.dev/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Cloud User",
    "email": "cloud@example.com",
    "password": "Cloud@123"
  }' | jq .

# Login
curl -X POST https://SEU-CODESPACE-3002.app.github.dev/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "cloud@example.com",
    "password": "Cloud@123"
  }' | jq .
```

### 3. Atualizar Insomnia Collection

1. Abra o Insomnia
2. Vá no ambiente **"PRODUCTION - Cloud"**
3. Atualize `base_url` com sua URL do Codespaces (porta 3002)
4. Teste as requisições!

---

## 🔍 Verificar Dados no Banco Cloud

### Neon.tech

1. Acesse https://console.neon.tech
2. Selecione seu projeto
3. Clique em **"SQL Editor"**
4. Execute queries:

```sql
-- Ver usuários
SELECT id, name, email, created_at FROM users;

-- Ver workouts
SELECT id, name, type, duration, date FROM workouts;

-- Ver estatísticas
SELECT 
  COUNT(*) as total_workouts,
  SUM(duration) as total_duration,
  AVG(duration) as avg_duration
FROM workouts;
```

### Supabase

1. Acesse https://supabase.com/dashboard
2. Selecione seu projeto
3. Clique em **"Table Editor"** (menu lateral)
4. Veja as tabelas `users` e `workouts` visualmente

### Render

1. Acesse https://dashboard.render.com
2. Selecione seu database
3. Clique em **"Connect"**
4. Use `psql` command line ou ferramenta como **TablePlus**

---

## 📊 Monitoramento e Limites

### Neon.tech (Free Tier)
- ✅ 0.5 GB storage
- ✅ Conexões ilimitadas
- ✅ Monitoramento de uso no dashboard

### Supabase (Free Tier)
- ✅ 500 MB storage
- ✅ 2 GB bandwidth/mês
- ⚠️ Database pausa após 1 semana de inatividade (reativa automaticamente)

### Render (Free Tier)
- ✅ 1 GB storage
- ⏰ 90 dias gratuito
- ⚠️ Depois cobra $7/mês

---

## 🛠️ Troubleshooting

### Erro: "SSL required"

```bash
# Adicione ?sslmode=require no final da DATABASE_URL
DATABASE_URL=postgresql://...?sslmode=require
```

### Erro: "Connection timeout"

1. Verifique se o IP do Codespaces está na whitelist (Neon e Supabase permitem all IPs por padrão)
2. Teste a conexão diretamente:

```bash
docker-compose exec app-cloud sh
apk add postgresql-client
psql $DATABASE_URL
```

### Erro: "Database does not exist"

Verifique se copiou a URL completa, incluindo o nome do banco no final.

### Tabelas não criadas automaticamente

O TypeORM está configurado com `synchronize: true` em desenvolvimento. Para produção:

```bash
# Conecte no banco e crie manualmente se necessário
# Ou rode a aplicação uma vez para criar as tabelas automaticamente
```

---

## ✅ Checklist de Configuração

- [ ] Conta criada no provedor cloud (Neon/Supabase/Render)
- [ ] Projeto/Database criado
- [ ] Connection string copiada
- [ ] DATABASE_URL configurada no .env
- [ ] SSL habilitado (?sslmode=require)
- [ ] Container app-cloud rodando
- [ ] Health check retornando "connected"
- [ ] Porta 3002 pública no Codespaces
- [ ] Insomnia collection testada no ambiente PRODUCTION
- [ ] Dados visíveis no dashboard do provedor

---

## 🎉 Pronto!

Sua aplicação agora está conectada a um PostgreSQL na nuvem!

**Próximos passos:**
- Use o ambiente LOCAL (porta 3001) para desenvolvimento
- Use o ambiente PRODUCTION (porta 3002) para testes com banco cloud
- Mantenha as duas instâncias rodando simultaneamente
