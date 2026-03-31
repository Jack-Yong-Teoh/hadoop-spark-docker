#!/bin/bash

set -e

echo "🚀 Starting Hadoop & Spark cluster..."
echo ""

# Clean up any existing containers from previous runs
echo "🧹 Cleaning up existing containers..."
docker compose down 2>/dev/null || true
echo ""

# Build and start services
docker compose up --build -d

echo "⏳ Waiting for services to be healthy (this may take 30-60 seconds)..."
echo ""

# Counter for wait time
counter=0
max_attempts=60

while [ $counter -lt $max_attempts ]; do
    if docker exec namenode curl -sf http://localhost:9870 > /dev/null 2>&1; then
        echo "✓ NameNode is healthy"
        break
    fi
    counter=$((counter + 1))
    echo "  Attempt $counter/$max_attempts..."
    sleep 1
done

if [ $counter -eq $max_attempts ]; then
    echo ""
    echo "⚠️  Services may still be starting. Check status:"
    docker compose logs --tail 20
else
    echo ""
    sleep 5  # Give services a bit more time to fully initialize
fi

echo ""
echo "=========================================="
echo "✓ Hadoop & Spark Cluster Started!"
echo "=========================================="
echo ""
echo "🌐 Access Points:"
echo "  • Hadoop NameNode UI: http://localhost:9870"
echo "  • Spark Master UI:    http://localhost:8080"
echo "  • HDFS NameNode:      hdfs://localhost:9000"
echo "  • Spark Master:       spark://spark-master:7077"
echo ""
echo "📝 Quick Commands:"
echo "  • View logs:     docker compose logs -f"
echo "  • Stop cluster:  docker compose down"
echo "  • Verify setup:  ./verify.sh"
echo "  • HDFS CLI:      docker exec namenode hdfs dfs -ls /"
echo ""
