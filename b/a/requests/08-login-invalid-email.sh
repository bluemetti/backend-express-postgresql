#!/bin/bash

# Login com email inválido
echo "=== LOGIN COM EMAIL INVÁLIDO ==="
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "email-inexistente",
    "password": "senha123"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
