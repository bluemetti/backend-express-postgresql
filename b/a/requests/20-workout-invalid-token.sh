#!/bin/bash

# [ERRO] Criar treino com token inválido
echo "=== [ERRO] CRIAR TREINO COM TOKEN INVÁLIDO ==="

curl -X POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer token_totalmente_invalido_xyz" \
  -d '{
    "name": "Treino Token Inválido",
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
