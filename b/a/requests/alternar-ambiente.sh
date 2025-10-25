#!/bin/bash

# Script para alternar entre ambientes LOCAL e PRODUCTION
# Atualiza todos os scripts .sh da pasta requests

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Alternador de Ambientes"
echo ""
echo "Selecione o ambiente:"
echo "  1) LOCAL - MongoDB Docker (porta 3001)"
echo "  2) PRODUCTION - MongoDB Atlas (porta 3002)"
echo ""
read -p "Digite 1 ou 2: " choice

case $choice in
  1)
    OLD_URL="http://localhost:3002"
    NEW_URL="http://localhost:3001"
    ENV_NAME="LOCAL (MongoDB Docker)"
    ;;
  2)
    OLD_URL="http://localhost:3001"
    NEW_URL="http://localhost:3002"
    ENV_NAME="PRODUCTION (MongoDB Atlas)"
    ;;
  *)
    echo "❌ Opção inválida!"
    exit 1
    ;;
esac

echo ""
echo "🔧 Alterando para ambiente: $ENV_NAME"
echo "   URL: $NEW_URL"
echo ""

# Atualizar todos os scripts .sh
cd "$SCRIPT_DIR"
for file in *.sh; do
  if [ "$file" != "alternar-ambiente.sh" ] && [ "$file" != "popular-ambientes.sh" ]; then
    sed -i "s|$OLD_URL|$NEW_URL|g" "$file"
  fi
done

echo "✅ Todos os scripts foram atualizados!"
echo ""
echo "📋 Agora você pode executar:"
echo "   ./01-register-success.sh"
echo "   ./06-login-success.sh"
echo "   ./13-workout-create-success.sh"
echo ""
echo "🔐 Lembre-se:"
echo "   • Cada ambiente tem seus próprios usuários e tokens"
echo "   • Faça login novamente após trocar de ambiente"
echo ""
