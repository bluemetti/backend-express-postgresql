#!/bin/bash

# Registro com email repetido
echo "=== REGISTRO COM EMAIL REPETIDO ==="
curl -X POST http://localhost:3000/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Maria Santos",
    "email": "joao.silva@email.com",
    "password": "outrasenha123"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
