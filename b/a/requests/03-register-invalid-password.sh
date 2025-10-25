#!/bin/bash

# Registro com senha inválida (muito curta)
echo "=== REGISTRO COM SENHA INVÁLIDA ==="
curl -X POST http://localhost:3000/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Pedro Costa",
    "email": "pedro.costa@email.com",
    "password": "123"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
