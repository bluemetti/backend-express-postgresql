#!/bin/bash

# Primeiro, fazer login para obter o token
echo "=== OBTENDO TOKEN ==="
TOKEN=$(curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao.silva@email.com",
    "password": "senha123"
  }' \
  -s | jq -r '.data.token')

echo "Token obtido: $TOKEN"
echo ""

# Acesso à rota protegida com token válido
echo "=== ACESSO À ROTA PROTEGIDA COM TOKEN VÁLIDO ==="
curl -X GET http://localhost:3000/protected \
  -H "Authorization: Bearer $TOKEN" \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
