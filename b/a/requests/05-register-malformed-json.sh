#!/bin/bash

# Registro com requisição mal formatada (JSON inválido)
echo "=== REGISTRO COM REQUISIÇÃO MAL FORMATADA ==="
curl -X POST http://localhost:3000/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Carlos Souza",
    "email": "carlos.souza@email.com"
    "password": "senha123"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
