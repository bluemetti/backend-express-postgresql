#!/bin/bash

# Registro com email inválido
echo "=== REGISTRO COM EMAIL INVÁLIDO ==="
curl -X POST http://localhost:3000/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Ana Oliveira",
    "email": "email-invalido",
    "password": "senha123"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
