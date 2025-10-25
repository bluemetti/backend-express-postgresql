#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=================================================="
echo "  🚀 INICIANDO TODOS OS SERVIÇOS"
echo "=================================================="
echo ""

echo -e "${BLUE}� Iniciando MongoDB, Mongo Express, API Local e API Atlas...${NC}"
docker-compose up -d

echo ""
echo -e "${GREEN}✅ Todos os serviços foram iniciados!${NC}"
echo ""
echo "=================================================="
echo "  📊 SERVIÇOS DISPONÍVEIS"
echo "=================================================="
echo ""
echo -e "${YELLOW}🐳 API LOCAL (MongoDB Docker):${NC}"
echo "  • API: http://localhost:3001"
echo "  • Health: http://localhost:3001/health"
echo "  • GitHub: https://organic-space-meme-7v9xrv7jjvp9cxpj9-3001.app.github.dev"
echo ""
echo -e "${YELLOW}☁️  API ATLAS (MongoDB Cloud):${NC}"
echo "  • API: http://localhost:3002"
echo "  • Health: http://localhost:3002/health"
echo "  • GitHub: https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev"
echo ""
echo -e "${YELLOW}📦 BANCO DE DADOS:${NC}"
echo "  • MongoDB Local: mongodb://localhost:27017"
echo "  • Mongo Express: http://localhost:8081 (admin/admin123)"
echo "  • Mongo Express GitHub: https://organic-space-meme-7v9xrv7jjvp9cxpj9-8081.app.github.dev"
echo ""
echo "=================================================="
