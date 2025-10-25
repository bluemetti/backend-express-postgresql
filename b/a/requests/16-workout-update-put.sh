#!/bin/bash

# Atualizar treino (PUT - completo)
echo "=== ATUALIZAR TREINO (PUT) ==="
echo "Insira o token JWT:"
read TOKEN
echo "Insira o ID do treino:"
read WORKOUT_ID

curl -X PUT https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts/$WORKOUT_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Treino de Pernas Atualizado",
    "type": "strength",
    "duration": 75,
    "calories": 500,
    "exercises": [
      {
        "name": "Agachamento",
        "sets": 5,
        "reps": 10,
        "weight": 90
      },
      {
        "name": "Leg Press",
        "sets": 4,
        "reps": 12,
        "weight": 170
      }
    ],
    "date": "2025-10-24T10:00:00Z",
    "notes": "Treino intenso atualizado"
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
