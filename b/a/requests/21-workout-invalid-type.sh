#!/bin/bash

# [ERRO] Criar treino com tipo inválido
echo "=== [ERRO] CRIAR TREINO COM TIPO INVÁLIDO ==="
echo "Insira o token JWT:"
read TOKEN

curl -X POST https://expert-carnival-q7qx97v5grqqh96j6-3001.app.github.dev/workouts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Treino Tipo Inválido",
    "type": "natacao",
    "duration": 60,
    "exercises": [
      {
        "name": "Nado crawl",
        "distance": 2
      }
    ]
  }' \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
