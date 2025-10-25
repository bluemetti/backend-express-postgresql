#!/bin/bash

# Listar todos os treinos
echo "=== LISTAR TODOS OS TREINOS ==="
echo "Insira o token JWT:"
read TOKEN

curl -X GET https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts \
  -H "Authorization: Bearer $TOKEN" \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
