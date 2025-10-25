#!/bin/bash

# [ERRO] Criar treino sem token
echo "=== [ERRO] CRIAR TREINO SEM TOKEN ==="

curl -X POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Treino Sem Token",
    "type": "strength",
    "duration": 60,
    "exercises": [
      {
        "name": "Agachamento",
        "sets": 4,
        "reps": 12
      }
    ]
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
