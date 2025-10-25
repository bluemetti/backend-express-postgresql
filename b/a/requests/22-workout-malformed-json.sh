#!/bin/bash

# [ERRO] Criar treino com JSON malformado
echo "=== [ERRO] CRIAR TREINO COM JSON MALFORMADO ==="
echo "Insira o token JWT:"
read TOKEN

curl -X POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Treino JSON Malformado",
    "type": "strength"
    "duration": 60,
    "exercises": [
      {
        "name": "Agachamento"
      }
    ]
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
