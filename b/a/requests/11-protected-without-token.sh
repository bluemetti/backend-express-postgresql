#!/bin/bash

# Tentativa de acesso à rota protegida sem token
echo "=== ACESSO À ROTA PROTEGIDA SEM TOKEN ==="
curl -X GET http://localhost:3000/protected \
  -w "\n\nStatus Code: %{http_code}\n" \
  -s | jq .
