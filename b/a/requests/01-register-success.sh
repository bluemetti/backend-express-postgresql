#!/bin/bash

# Registro bem-sucedido
echo "=== REGISTRO BEM-SUCEDIDO ==="
curl -X POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao.silva@email.com",
    "password": "Senha@123"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
