#!/bin/bash

# Script para fazer login e obter o token JWT automaticamente
# Uso: ./get-token.sh [local|atlas]

# Detectar ambiente atual dos scripts
CURRENT_URL=$(grep -o 'API_URL="[^"]*"' 01-register-success.sh 2>/dev/null | cut -d'"' -f2)

if [ -z "$CURRENT_URL" ]; then
  CURRENT_URL="http://localhost:3001"
fi

# Permitir override via parâmetro
if [ "$1" == "atlas" ] || [ "$1" == "production" ]; then
  API_URL="http://localhost:3002"
  ENV_NAME="PRODUCTION (MongoDB Atlas)"
elif [ "$1" == "local" ]; then
  API_URL="http://localhost:3001"
  ENV_NAME="LOCAL (MongoDB Docker)"
else
  API_URL="$CURRENT_URL"
  if [[ "$API_URL" == *"3002"* ]]; then
    ENV_NAME="PRODUCTION (MongoDB Atlas)"
  else
    ENV_NAME="LOCAL (MongoDB Docker)"
  fi
fi

echo "🔐 Fazendo login no ambiente: $ENV_NAME"
echo "   URL: $API_URL"
echo ""

# Fazer login
RESPONSE=$(curl -s -X POST "${API_URL}/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "Senha@123"
  }')

# Extrair o token
TOKEN=$(echo "$RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ Erro ao fazer login!"
  echo ""
  echo "Resposta completa:"
  echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
  echo ""
  echo "💡 Dicas:"
  echo "   • Verifique se o usuário existe. Se não, registre primeiro:"
  echo "     ./01-register-success.sh"
  echo ""
  echo "   • Use os usuários pré-criados:"
  echo "     LOCAL: joao@local.com / Senha@123"
  echo "     PRODUCTION: maria@production.com / Senha@123"
  exit 1
fi

echo "✅ Login realizado com sucesso!"
echo ""
echo "🎫 Seu token JWT:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$TOKEN"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Token copiado para clipboard automaticamente (se possível)"
echo "$TOKEN" | xclip -selection clipboard 2>/dev/null || echo "$TOKEN" | pbcopy 2>/dev/null || echo "⚠️  Copie manualmente o token acima"
echo ""
echo "🔧 Para usar no Insomnia:"
echo "   1. Pressione Ctrl+E (ou Cmd+E no Mac)"
echo "   2. Selecione o ambiente: $ENV_NAME"
echo "   3. Cole o token no campo \"token\": \"\""
echo "   4. Salve (Ctrl+S)"
echo ""
echo "🚀 Para usar em outros scripts:"
echo "   export TOKEN=\"$TOKEN\""
echo ""

# Salvar em arquivo para facilitar
echo "$TOKEN" > /tmp/jwt-token.txt
echo "💾 Token salvo em: /tmp/jwt-token.txt"
echo ""
