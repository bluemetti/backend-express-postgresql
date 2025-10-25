#!/bin/bash

echo "🧪 EXECUTANDO TODOS OS TESTES DA API"
echo "====================================="
echo ""

# Array com todos os scripts de teste
scripts=(
  "01-register-success.sh"
  "02-register-duplicate-email.sh"
  "03-register-invalid-password.sh"
  "04-register-invalid-email.sh"
  "05-register-malformed-json.sh"
  "06-login-success.sh"
  "07-login-invalid-password.sh"
  "08-login-invalid-email.sh"
  "09-login-malformed-json.sh"
  "10-protected-with-valid-token.sh"
  "11-protected-without-token.sh"
  "12-protected-with-invalid-token.sh"
)

# Executar cada script
for script in "${scripts[@]}"; do
  echo "📋 Executando: $script"
  echo "----------------------------------------"
  
  if [ -f "$script" ]; then
    bash "$script"
  else
    echo "❌ Arquivo $script não encontrado!"
  fi
  
  echo ""
  echo "========================================="
  echo ""
  
  # Pequena pausa entre os testes
  sleep 1
done

echo "✅ Todos os testes foram executados!"
