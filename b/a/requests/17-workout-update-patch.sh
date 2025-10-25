#!/bin/bash

# Atualizar treino parcialmente (PATCH)
echo "=== ATUALIZAR TREINO PARCIALMENTE (PATCH) ==="
echo "Insira o token JWT:"
read TOKEN
echo "Insira o ID do treino:"
read WORKOUT_ID

curl -X PATCH https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts/$WORKOUT_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "duration": 45,
    "calories": 300,
    "notes": "Treino reduzido por falta de tempo"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
