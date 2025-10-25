#!/bin/bash

# Login bem-sucedido
echo "=== LOGIN BEM-SUCEDIDO ==="
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao.silva@email.com",
    "password": "senha123"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
