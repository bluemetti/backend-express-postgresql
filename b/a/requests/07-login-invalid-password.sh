#!/bin/bash

# Login com senha inválida
echo "=== LOGIN COM SENHA INVÁLIDA ==="
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao.silva@email.com",
    "password": "senhaerrada"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
