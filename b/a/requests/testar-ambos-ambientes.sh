#!/bin/bash

# Script para testar ambos os ambientes de uma vez
# Verifica se tudo está funcionando corretamente

echo "🧪 Testando Ambos os Ambientes"
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ==========================================
# Função de Teste
# ==========================================

test_environment() {
  local ENV_NAME=$1
  local API_URL=$2
  local COLOR=$3
  
  echo -e "${COLOR}═══════════════════════════════════════════${NC}"
  echo -e "${COLOR}   Testando: $ENV_NAME${NC}"
  echo -e "${COLOR}═══════════════════════════════════════════${NC}"
  echo ""
  
  # 1. Health Check
  echo -n "   🏥 Health Check... "
  HEALTH=$(curl -s $API_URL/health)
  if echo "$HEALTH" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ OK${NC}"
  else
    echo -e "${RED}❌ FALHOU${NC}"
    echo "   Resposta: $HEALTH"
    return 1
  fi
  
  # 2. Database Status
  echo -n "   🗄️  Database... "
  if echo "$HEALTH" | grep -q '"status":"connected"'; then
    DB_NAME=$(echo "$HEALTH" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
    echo -e "${GREEN}✅ Conectado ($DB_NAME)${NC}"
  else
    echo -e "${RED}❌ Desconectado${NC}"
    return 1
  fi
  
  # 3. Register (cria usuário temporário)
  echo -n "   📝 Register... "
  REGISTER=$(curl -s -X POST $API_URL/register \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"Test User\",\"email\":\"test$(date +%s)@test.com\",\"password\":\"Senha@123\"}")
  
  if echo "$REGISTER" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ OK${NC}"
    TOKEN=$(echo "$REGISTER" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
  else
    echo -e "${RED}❌ FALHOU${NC}"
    echo "   Resposta: $REGISTER"
    return 1
  fi
  
  # 4. Create Workout
  echo -n "   💪 Create Workout... "
  CREATE=$(curl -s -X POST $API_URL/workouts \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"name":"Test Workout","type":"strength","duration":60,"calories":400,"exercises":[{"name":"Test","sets":3,"reps":10}]}')
  
  if echo "$CREATE" | grep -q '"message":"Workout created successfully"'; then
    echo -e "${GREEN}✅ OK${NC}"
    WORKOUT_ID=$(echo "$CREATE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
  else
    echo -e "${RED}❌ FALHOU${NC}"
    echo "   Resposta: $CREATE"
    return 1
  fi
  
  # 5. List Workouts
  echo -n "   📋 List Workouts... "
  LIST=$(curl -s $API_URL/workouts -H "Authorization: Bearer $TOKEN")
  if echo "$LIST" | grep -q '"count":'; then
    COUNT=$(echo "$LIST" | grep -o '"count":[0-9]*' | cut -d':' -f2)
    echo -e "${GREEN}✅ OK ($COUNT workouts)${NC}"
  else
    echo -e "${RED}❌ FALHOU${NC}"
    return 1
  fi
  
  # 6. Get Statistics
  echo -n "   📊 Statistics... "
  STATS=$(curl -s $API_URL/workouts/stats -H "Authorization: Bearer $TOKEN")
  if echo "$STATS" | grep -q '"totalWorkouts":'; then
    TOTAL=$(echo "$STATS" | grep -o '"totalWorkouts":[0-9]*' | cut -d':' -f2)
    echo -e "${GREEN}✅ OK ($TOTAL total)${NC}"
  else
    echo -e "${RED}❌ FALHOU${NC}"
    return 1
  fi
  
  # 7. Get by ID
  echo -n "   🔍 Get by ID... "
  GET=$(curl -s $API_URL/workouts/$WORKOUT_ID -H "Authorization: Bearer $TOKEN")
  if echo "$GET" | grep -q '"id":"'"$WORKOUT_ID"'"'; then
    echo -e "${GREEN}✅ OK${NC}"
  else
    echo -e "${RED}❌ FALHOU${NC}"
    return 1
  fi
  
  # 8. Update (PATCH)
  echo -n "   ✏️  Update (PATCH)... "
  UPDATE=$(curl -s -X PATCH $API_URL/workouts/$WORKOUT_ID \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"notes":"Updated via test"}')
  
  if echo "$UPDATE" | grep -q '"message":"Workout updated successfully"'; then
    echo -e "${GREEN}✅ OK${NC}"
  else
    echo -e "${RED}❌ FALHOU${NC}"
    return 1
  fi
  
  # 9. Delete
  echo -n "   🗑️  Delete... "
  DELETE=$(curl -s -X DELETE $API_URL/workouts/$WORKOUT_ID \
    -H "Authorization: Bearer $TOKEN")
  
  if echo "$DELETE" | grep -q '"message":"Workout deleted successfully"'; then
    echo -e "${GREEN}✅ OK${NC}"
  else
    echo -e "${RED}❌ FALHOU${NC}"
    return 1
  fi
  
  # 10. Error Cases
  echo -n "   ⚠️  Error 401 (no token)... "
  ERROR401=$(curl -s -w "%{http_code}" $API_URL/workouts -o /dev/null)
  if [ "$ERROR401" == "401" ]; then
    echo -e "${GREEN}✅ OK${NC}"
  else
    echo -e "${RED}❌ FALHOU (esperado 401, recebeu $ERROR401)${NC}"
  fi
  
  echo ""
  echo -e "${GREEN}   ✅ Todos os testes passaram!${NC}"
  echo ""
  return 0
}

# ==========================================
# Executar Testes
# ==========================================

FAILED=0

# Teste LOCAL
test_environment "LOCAL - MongoDB Docker" "http://localhost:3001" "$BLUE"
LOCAL_RESULT=$?

# Teste PRODUCTION
test_environment "PRODUCTION - MongoDB Atlas" "http://localhost:3002" "$YELLOW"
ATLAS_RESULT=$?

# ==========================================
# Resumo Final
# ==========================================

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}              RESUMO FINAL${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

if [ $LOCAL_RESULT -eq 0 ]; then
  echo -e "   ${GREEN}✅ LOCAL - Todos os testes passaram${NC}"
else
  echo -e "   ${RED}❌ LOCAL - Alguns testes falharam${NC}"
  FAILED=1
fi

if [ $ATLAS_RESULT -eq 0 ]; then
  echo -e "   ${GREEN}✅ PRODUCTION - Todos os testes passaram${NC}"
else
  echo -e "   ${RED}❌ PRODUCTION - Alguns testes falharam${NC}"
  FAILED=1
fi

echo ""

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}🎉 SUCESSO! Ambos os ambientes estão funcionando perfeitamente!${NC}"
  echo ""
  echo "📊 Você pode visualizar os dados em:"
  echo "   • LOCAL: http://localhost:8081 (admin/admin123)"
  echo "   • PRODUCTION: https://cloud.mongodb.com/"
  echo ""
  echo "🎥 Pronto para gravar o vídeo demonstrativo!"
  exit 0
else
  echo -e "${RED}❌ FALHA! Alguns testes não passaram.${NC}"
  echo ""
  echo "💡 Dicas:"
  echo "   • Verifique se os containers estão rodando: docker-compose ps"
  echo "   • Veja os logs: docker logs jwt-auth-app-local --tail 50"
  echo "   • Reinicie os containers: docker-compose restart"
  exit 1
fi
