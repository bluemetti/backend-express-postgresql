#!/bin/bash

# Deletar treino
echo "=== DELETAR TREINO ==="
echo "Insira o token JWT:"
read TOKEN
echo "Insira o ID do treino:"
read WORKOUT_ID

curl -X DELETE https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts/$WORKOUT_ID \
  -H "Authorization: Bearer $TOKEN" \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
