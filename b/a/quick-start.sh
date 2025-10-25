#!/bin/bash

# 🚀 Script de Inicialização Rápida - JWT Auth Backend
# Execute este script para começar rapidamente

set -e  # Parar em caso de erro

echo "🔐 JWT Authentication Backend - Setup Rápido"
echo "=============================================="
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar se está no diretório correto
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Erro: Execute este script no diretório do projeto (pasta 'a')${NC}"
    exit 1
fi

echo "📍 Passo 1: Verificando pré-requisitos..."

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker não está instalado!${NC}"
    echo "📥 Instale o Docker: https://docs.docker.com/get-docker/"
    exit 1
else
    echo -e "${GREEN}✅ Docker instalado${NC}"
fi

# Verificar Docker Compose
if ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose não está instalado!${NC}"
    echo "📥 Instale o Docker Compose"
    exit 1
else
    echo -e "${GREEN}✅ Docker Compose instalado${NC}"
fi

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠️  Node.js não está instalado (necessário apenas para desenvolvimento local)${NC}"
else
    echo -e "${GREEN}✅ Node.js instalado: $(node --version)${NC}"
fi

echo ""
echo "📍 Passo 2: Configurando arquivo .env..."

# Criar .env se não existir
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${GREEN}✅ Arquivo .env criado${NC}"
    
    # Gerar JWT_SECRET se Node.js estiver disponível
    if command -v node &> /dev/null; then
        JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
        
        # Substituir JWT_SECRET no .env
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s|JWT_SECRET=.*|JWT_SECRET=$JWT_SECRET|g" .env
        else
            # Linux
            sed -i "s|JWT_SECRET=.*|JWT_SECRET=$JWT_SECRET|g" .env
        fi
        
        echo -e "${GREEN}✅ JWT_SECRET gerado automaticamente${NC}"
    else
        echo -e "${YELLOW}⚠️  Configure manualmente o JWT_SECRET no arquivo .env${NC}"
    fi
    
    echo -e "${YELLOW}⚠️  IMPORTANTE: Edite o arquivo .env e configure as variáveis restantes${NC}"
else
    echo -e "${GREEN}✅ Arquivo .env já existe${NC}"
fi

echo ""
echo "📍 Passo 3: Escolha o modo de execução:"
echo ""
echo "1) 🐳 Docker (Recomendado - tudo incluído)"
echo "2) 💻 Local (Requer MongoDB instalado)"
echo "3) ❌ Cancelar"
echo ""
read -p "Escolha uma opção (1-3): " choice

case $choice in
    1)
        echo ""
        echo "🐳 Iniciando com Docker..."
        echo ""
        
        # Verificar se MONGODB_URI está correto para Docker
        if grep -q "MONGODB_URI=mongodb://localhost" .env; then
            echo -e "${YELLOW}⚠️  Ajustando MONGODB_URI para Docker...${NC}"
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' 's|MONGODB_URI=mongodb://localhost|MONGODB_URI=mongodb://mongodb|g' .env
            else
                sed -i 's|MONGODB_URI=mongodb://localhost|MONGODB_URI=mongodb://mongodb|g' .env
            fi
        fi
        
        echo "📦 Construindo e iniciando containers..."
        docker-compose up -d --build
        
        echo ""
        echo -e "${GREEN}✅ Aplicação iniciada com sucesso!${NC}"
        echo ""
        echo "🌐 Acessos:"
        echo "   - API: http://localhost:3001"
        echo "   - Health: http://localhost:3001/health"
        echo "   - Mongo Express: http://localhost:8081 (admin/admin123)"
        echo ""
        echo "📊 Ver logs:"
        echo "   docker-compose logs -f app"
        echo ""
        echo "🛑 Parar:"
        echo "   docker-compose down"
        ;;
        
    2)
        echo ""
        echo "💻 Iniciando modo local..."
        echo ""
        
        # Verificar se MONGODB_URI está correto para local
        if grep -q "MONGODB_URI=mongodb://mongodb" .env; then
            echo -e "${YELLOW}⚠️  Ajustando MONGODB_URI para localhost...${NC}"
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' 's|MONGODB_URI=mongodb://mongodb|MONGODB_URI=mongodb://localhost|g' .env
            else
                sed -i 's|MONGODB_URI=mongodb://mongodb|MONGODB_URI=mongodb://localhost|g' .env
            fi
        fi
        
        # Instalar dependências
        if [ ! -d "node_modules" ]; then
            echo "📦 Instalando dependências..."
            npm install
        fi
        
        # Verificar MongoDB
        echo "🔍 Verificando MongoDB..."
        if ! pgrep -x mongod > /dev/null; then
            echo -e "${RED}❌ MongoDB não está rodando!${NC}"
            echo "Inicie o MongoDB:"
            echo "  - Linux: sudo systemctl start mongod"
            echo "  - macOS: brew services start mongodb-community"
            exit 1
        fi
        
        echo -e "${GREEN}✅ MongoDB está rodando${NC}"
        echo ""
        echo "🚀 Iniciando aplicação..."
        npm run dev
        ;;
        
    3)
        echo "❌ Cancelado"
        exit 0
        ;;
        
    *)
        echo -e "${RED}❌ Opção inválida${NC}"
        exit 1
        ;;
esac
