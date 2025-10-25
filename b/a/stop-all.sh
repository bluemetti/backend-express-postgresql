#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=================================================="
echo "  🛑 PARANDO TODOS OS SERVIÇOS"
echo "=================================================="
echo ""

echo -e "${YELLOW}⏸️  Parando todos os containers...${NC}"
docker-compose down

echo ""
echo -e "${GREEN}✅ Todos os serviços foram parados!${NC}"
echo ""
