#!/bin/bash

echo "=========================================="
echo "Verifying Hadoop & Spark Setup"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_service() {
    local name=$1
    local url=$2
    local port=$3

    echo -n "Checking $name... "

    if curl -sf --max-time 5 "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ RUNNING${NC}"
        return 0
    else
        echo -e "${RED}✗ NOT RESPONDING${NC}"
        return 1
    fi
}

check_container() {
    local name=$1

    echo -n "Container $name... "
    if docker ps | grep -q "$name"; then
        echo -e "${GREEN}✓ RUNNING${NC}"
        return 0
    else
        if docker ps -a | grep -q "$name"; then
            echo -e "${RED}✗ STOPPED${NC}"
        else
            echo -e "${RED}✗ NOT FOUND${NC}"
        fi
        return 1
    fi
}

echo "📦 Container Status:"
echo "---"
check_container "namenode"
check_container "datanode"
check_container "spark-master"
check_container "spark-worker"
echo ""

echo "🌐 Service Health:"
echo "---"
check_service "Hadoop NameNode UI" "http://localhost:9870" 9870
check_service "Hadoop HDFS" "http://localhost:9000" 9000
check_service "Spark Master UI" "http://localhost:8080" 8080
echo ""

echo "📊 Log Sample (last 5 lines from each container):"
echo "---"
echo "NameNode logs:"
docker logs --tail 5 namenode 2>/dev/null | head -5
echo ""
echo "Spark Master logs:"
docker logs --tail 5 spark-master 2>/dev/null | head -5
echo ""

echo "=========================================="
echo "✓ Verification Complete!"
echo "=========================================="
echo ""
echo "Access UIs:"
echo "  • Hadoop NameNode: http://localhost:9870"
echo "  • Spark Master:    http://localhost:8080"
