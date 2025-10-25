#!/bin/bash

# Tentativa de acesso à rota protegida com token inválido
echo "=== ACESSO À ROTA PROTEGIDA COM TOKEN INVÁLIDO ==="
curl -X GET http://localhost:3000/protected \
  -H "Authorization: Bearer token-invalido-12345" \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
