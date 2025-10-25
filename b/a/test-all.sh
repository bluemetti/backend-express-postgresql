#!/bin/bash

# Script de Teste Completo - JWT Auth Backend
# Execute: ./test-all.sh

set -e

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

BASE_URL="${BASE_URL:-http://localhost:3001}"
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  JWT AUTH BACKEND - TESTE COMPLETO${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Base URL: $BASE_URL"
echo ""

# Função para testar endpoint
test_endpoint() {
    local test_name="$1"
    local expected_status="$2"
    local method="$3"
    local endpoint="$4"
    local data="$5"
    local headers="$6"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -n "[$TOTAL_TESTS] Testing: $test_name ... "
    
    if [ -n "$headers" ]; then
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -H "$headers" \
            -d "$data" 2>/dev/null)
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data" 2>/dev/null)
    fi
    
    status_code=$(echo "$response" | tail -n1)
    
    if [ "$status_code" = "$expected_status" ]; then
        echo -e "${GREEN}✓ PASSED${NC} (Status: $status_code)"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}✗ FAILED${NC} (Expected: $expected_status, Got: $status_code)"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# ========================================
# TESTES
# ========================================

echo -e "${YELLOW}[Health Check]${NC}"
test_endpoint "Health check" "200" "GET" "/health" ""

echo ""
echo -e "${YELLOW}[Cadastro - Sucesso]${NC}"
# Limpar usuário de teste se existir
test_endpoint "Cadastro bem-sucedido" "201" "POST" "/register" '{
    "name": "Teste User",
    "email": "teste.user@email.com",
    "password": "Senha@123"
}'

echo ""
echo -e "${YELLOW}[Cadastro - Erros]${NC}"
test_endpoint "Cadastro email duplicado" "422" "POST" "/register" '{
    "name": "Teste Duplicado",
    "email": "teste.user@email.com",
    "password": "Senha@456"
}'

test_endpoint "Cadastro senha curta" "422" "POST" "/register" '{
    "name": "Teste Senha",
    "email": "teste2@email.com",
    "password": "123"
}'

test_endpoint "Cadastro senha sem especial" "422" "POST" "/register" '{
    "name": "Teste Senha2",
    "email": "teste3@email.com",
    "password": "Senha123"
}'

test_endpoint "Cadastro email inválido" "422" "POST" "/register" '{
    "name": "Teste Email",
    "email": "email-sem-arroba",
    "password": "Senha@123"
}'

test_endpoint "Cadastro JSON malformado" "400" "POST" "/register" '{
    "name": "Teste",
    "email": "teste@email.com"
    "password": "Senha@123"
}'

test_endpoint "Cadastro nome muito curto" "422" "POST" "/register" '{
    "name": "A",
    "email": "teste4@email.com",
    "password": "Senha@123"
}'

echo ""
echo -e "${YELLOW}[Login - Sucesso]${NC}"
RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "teste.user@email.com",
        "password": "Senha@123"
    }')

TOKEN=$(echo "$RESPONSE" | jq -r '.data.token' 2>/dev/null)

test_endpoint "Login bem-sucedido" "200" "POST" "/login" '{
    "email": "teste.user@email.com",
    "password": "Senha@123"
}'

echo ""
echo -e "${YELLOW}[Login - Erros]${NC}"
test_endpoint "Login senha incorreta" "401" "POST" "/login" '{
    "email": "teste.user@email.com",
    "password": "SenhaErrada@123"
}'

test_endpoint "Login usuário não existe" "404" "POST" "/login" '{
    "email": "nao.existe@email.com",
    "password": "Senha@123"
}'

test_endpoint "Login email inválido" "422" "POST" "/login" '{
    "email": "email-invalido",
    "password": "Senha@123"
}'

test_endpoint "Login JSON malformado" "400" "POST" "/login" '{
    "email": "teste@email.com"
    "password": "Senha@123"
}'

echo ""
echo -e "${YELLOW}[Rota Protegida]${NC}"

if [ -n "$TOKEN" ] && [ "$TOKEN" != "null" ]; then
    test_endpoint "Acesso com token válido" "200" "GET" "/protected" "" "Authorization: Bearer $TOKEN"
else
    echo -e "${RED}Não foi possível obter token para testes${NC}"
    FAILED_TESTS=$((FAILED_TESTS + 1))
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
fi

test_endpoint "Acesso sem token" "401" "GET" "/protected" ""
test_endpoint "Acesso token inválido" "401" "GET" "/protected" "" "Authorization: Bearer token_invalido_xyz123"

# ========================================
# RESULTADO FINAL
# ========================================

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  RESULTADO FINAL${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Total de testes: $TOTAL_TESTS"
echo -e "${GREEN}Passou: $PASSED_TESTS${NC}"
echo -e "${RED}Falhou: $FAILED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}🎉 TODOS OS TESTES PASSARAM! 🎉${NC}"
    exit 0
else
    echo -e "${RED}❌ ALGUNS TESTES FALHARAM${NC}"
    exit 1
fi
