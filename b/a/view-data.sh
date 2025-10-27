#!/bin/bash

# Script para visualizar dados do PostgreSQL local

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 VISUALIZADOR DE DADOS - PostgreSQL Local"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Função para executar query
run_query() {
    docker-compose exec -T postgres psql -U postgres -d jwt_auth_db -c "$1" 2>/dev/null
}

# Menu
if [ "$1" == "" ]; then
    echo "Uso: ./view-data.sh [opção]"
    echo ""
    echo "Opções:"
    echo "  users      - Ver todos os usuários"
    echo "  workouts   - Ver todos os workouts"
    echo "  exercises  - Ver exercises detalhados (JSONB)"
    echo "  stats      - Ver estatísticas"
    echo "  all        - Ver tudo"
    echo ""
    echo "Exemplo: ./view-data.sh users"
    exit 0
fi

case "$1" in
    users)
        echo "👥 USUÁRIOS:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        run_query "SELECT id, name, email, created_at FROM users ORDER BY created_at DESC;"
        ;;
    
    workouts)
        echo "💪 WORKOUTS:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        run_query "SELECT id, name, type, duration, calories, date, notes FROM workouts ORDER BY date DESC;"
        ;;
    
    exercises)
        echo "🏋️ EXERCISES (JSONB):"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        run_query "SELECT name, jsonb_pretty(exercises) as exercises FROM workouts;"
        ;;
    
    stats)
        echo "📊 ESTATÍSTICAS:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        run_query "SELECT COUNT(*) as total_workouts, SUM(duration) as total_minutes, AVG(duration) as avg_duration, SUM(calories) as total_calories FROM workouts;"
        echo ""
        echo "Por tipo:"
        run_query "SELECT type, COUNT(*) as count FROM workouts GROUP BY type;"
        ;;
    
    all)
        echo "👥 USUÁRIOS:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        run_query "SELECT id, name, email, created_at FROM users ORDER BY created_at DESC;"
        echo ""
        echo "💪 WORKOUTS:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        run_query "SELECT id, name, type, duration, calories, date FROM workouts ORDER BY date DESC;"
        echo ""
        echo "📊 ESTATÍSTICAS:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        run_query "SELECT COUNT(*) as total_workouts, SUM(duration) as total_minutes, AVG(duration) as avg_duration, SUM(calories) as total_calories FROM workouts;"
        ;;
    
    *)
        echo "❌ Opção inválida: $1"
        echo "Use: ./view-data.sh users|workouts|exercises|stats|all"
        exit 1
        ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
