#!/bin/bash

# Script para popular ambos ambientes com dados de exemplo
# Para usar no vídeo demonstrativo

echo "🚀 Populando ambientes com dados de exemplo..."
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ==========================================
# AMBIENTE LOCAL (porta 3001)
# ==========================================

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}   AMBIENTE LOCAL (MongoDB Docker)${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

# Registrar usuário
echo "📝 Registrando usuário local..."
REGISTER_RESPONSE=$(curl -s -X POST http://localhost:3001/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao@local.com",
    "password": "Senha@123"
  }')

TOKEN_LOCAL=$(echo "$REGISTER_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN_LOCAL" ]; then
  echo "❌ Erro ao registrar usuário local"
  echo "$REGISTER_RESPONSE"
  exit 1
fi

echo -e "${GREEN}✅ Usuário local criado!${NC}"
echo "   Email: joao@local.com"
echo ""

# Criar workouts
echo "💪 Criando workouts locais..."

curl -s -X POST http://localhost:3001/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN_LOCAL" \
  -d '{
    "name": "Treino de Peito e Tríceps",
    "type": "strength",
    "duration": 75,
    "calories": 520,
    "exercises": [
      {"name": "Supino Reto", "sets": 4, "reps": 10, "weight": 80},
      {"name": "Supino Inclinado", "sets": 4, "reps": 10, "weight": 70},
      {"name": "Crucifixo", "sets": 3, "reps": 12, "weight": 20},
      {"name": "Tríceps Testa", "sets": 3, "reps": 12, "weight": 30}
    ],
    "notes": "Treino pesado, aumentar carga semana que vem"
  }' > /dev/null

echo -e "${GREEN}✅ Workout 1 criado${NC}"

curl -s -X POST http://localhost:3001/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN_LOCAL" \
  -d '{
    "name": "Corrida Matinal",
    "type": "cardio",
    "duration": 30,
    "calories": 280,
    "exercises": [
      {"name": "Corrida", "sets": 1, "reps": 1, "rest": 0}
    ],
    "notes": "Ritmo moderado, 6km"
  }' > /dev/null

echo -e "${GREEN}✅ Workout 2 criado${NC}"

curl -s -X POST http://localhost:3001/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN_LOCAL" \
  -d '{
    "name": "Yoga e Alongamento",
    "type": "flexibility",
    "duration": 45,
    "calories": 150,
    "exercises": [
      {"name": "Saudação ao Sol", "sets": 5, "reps": 1, "rest": 30},
      {"name": "Alongamento Posterior", "sets": 3, "reps": 1, "rest": 20}
    ],
    "notes": "Foco em flexibilidade e relaxamento"
  }' > /dev/null

echo -e "${GREEN}✅ Workout 3 criado${NC}"
echo ""

# ==========================================
# AMBIENTE PRODUCTION (porta 3002)
# ==========================================

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}   AMBIENTE PRODUCTION (MongoDB Atlas)${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

# Registrar usuário
echo "📝 Registrando usuário em produção..."
REGISTER_RESPONSE=$(curl -s -X POST http://localhost:3002/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Maria Santos",
    "email": "maria@production.com",
    "password": "Senha@123"
  }')

TOKEN_ATLAS=$(echo "$REGISTER_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN_ATLAS" ]; then
  echo "❌ Erro ao registrar usuário em produção"
  echo "$REGISTER_RESPONSE"
  exit 1
fi

echo -e "${GREEN}✅ Usuário em produção criado!${NC}"
echo "   Email: maria@production.com"
echo ""

# Criar workouts
echo "💪 Criando workouts em produção..."

curl -s -X POST http://localhost:3002/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN_ATLAS" \
  -d '{
    "name": "Treino de Costas e Bíceps",
    "type": "strength",
    "duration": 80,
    "calories": 550,
    "exercises": [
      {"name": "Barra Fixa", "sets": 4, "reps": 8, "weight": 0},
      {"name": "Remada Curvada", "sets": 4, "reps": 10, "weight": 70},
      {"name": "Pulldown", "sets": 3, "reps": 12, "weight": 60},
      {"name": "Rosca Direta", "sets": 3, "reps": 12, "weight": 16}
    ],
    "notes": "Excelente treino, completei todas as séries!"
  }' > /dev/null

echo -e "${GREEN}✅ Workout 1 criado${NC}"

curl -s -X POST http://localhost:3002/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN_ATLAS" \
  -d '{
    "name": "Futebol com Amigos",
    "type": "sports",
    "duration": 90,
    "calories": 650,
    "exercises": [
      {"name": "Futebol", "sets": 1, "reps": 1, "rest": 0}
    ],
    "notes": "Partida intensa, ganhamos 4x2"
  }' > /dev/null

echo -e "${GREEN}✅ Workout 2 criado${NC}"

curl -s -X POST http://localhost:3002/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN_ATLAS" \
  -d '{
    "name": "Treino de Pernas",
    "type": "strength",
    "duration": 70,
    "calories": 580,
    "exercises": [
      {"name": "Agachamento", "sets": 5, "reps": 10, "weight": 100},
      {"name": "Leg Press", "sets": 4, "reps": 12, "weight": 180},
      {"name": "Cadeira Extensora", "sets": 3, "reps": 15, "weight": 50}
    ],
    "notes": "Pernas travadas depois desse treino!"
  }' > /dev/null

echo -e "${GREEN}✅ Workout 3 criado${NC}"

curl -s -X POST http://localhost:3002/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN_ATLAS" \
  -d '{
    "name": "HIIT Intenso",
    "type": "cardio",
    "duration": 25,
    "calories": 320,
    "exercises": [
      {"name": "Burpees", "sets": 4, "reps": 15, "rest": 30},
      {"name": "Mountain Climbers", "sets": 4, "reps": 30, "rest": 30},
      {"name": "Jump Squats", "sets": 4, "reps": 20, "rest": 30}
    ],
    "notes": "HIIT muito intenso, suei muito!"
  }' > /dev/null

echo -e "${GREEN}✅ Workout 4 criado${NC}"
echo ""

# ==========================================
# RESUMO FINAL
# ==========================================

echo -e "${YELLOW}════════════════════════════════════════${NC}"
echo -e "${YELLOW}              RESUMO FINAL${NC}"
echo -e "${YELLOW}════════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}📊 AMBIENTE LOCAL (porta 3001):${NC}"
echo "   Usuário: João Silva (joao@local.com)"
echo "   Workouts: 3"
echo "   Token salvo em: /tmp/token-local.txt"
echo "$TOKEN_LOCAL" > /tmp/token-local.txt
echo ""

echo -e "${BLUE}📊 AMBIENTE PRODUCTION (porta 3002):${NC}"
echo "   Usuário: Maria Santos (maria@production.com)"
echo "   Workouts: 4"
echo "   Token salvo em: /tmp/token-atlas.txt"
echo "$TOKEN_ATLAS" > /tmp/token-atlas.txt
echo ""

echo -e "${GREEN}✅ Ambientes populados com sucesso!${NC}"
echo ""

echo "🔐 Para usar no Insomnia:"
echo ""
echo "   1. Ambiente LOCAL:"
echo "      Token: $TOKEN_LOCAL"
echo ""
echo "   2. Ambiente PRODUCTION:"
echo "      Token: $TOKEN_ATLAS"
echo ""

echo "📋 Visualizar dados:"
echo "   • LOCAL: http://localhost:8081 (admin/admin123)"
echo "   • PRODUCTION: https://cloud.mongodb.com/"
echo ""

echo "🎥 Tudo pronto para gravar o vídeo demonstrativo!"
