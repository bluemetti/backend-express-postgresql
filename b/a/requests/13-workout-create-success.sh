#!/bin/bash

# Criar treino bem-sucedido
# IMPORTANTE: Execute primeiro 06-login-success.sh e copie o token JWT

echo "=== CRIAR TREINO BEM-SUCEDIDO ==="
echo "Insira o token JWT:"
read TOKEN

curl -X POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Treino de Pernas",
    "type": "strength",
    "duration": 60,
    "calories": 400,
    "exercises": [
      {
        "name": "Agachamento",
        "sets": 4,
        "reps": 12,
        "weight": 80
      },
      {
        "name": "Leg Press",
        "sets": 3,
        "reps": 15,
        "weight": 150
      }
    ],
    "date": "2025-10-24T10:00:00Z",
    "notes": "Treino intenso de pernas"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
