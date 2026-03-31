# Hadoop & Spark Docker Setup

A complete Docker Compose setup for Apache Hadoop 3.2.1 and Apache Spark 3.5.3.

## Components

- **Hadoop NameNode**: Master node for HDFS file system (Port 9870)
- **Hadoop DataNode**: Slave node for HDFS (Data storage)
- **Spark Master**: Spark cluster manager (Port 8080)
- **Spark Worker**: Spark compute node

## Quick Start

### 1. Start the cluster

```bash
./start.sh
```

Or manually:

```bash
docker compose up --build -d
```

### 2. Verify everything is working

```bash
./verify.sh
```

### 3. Access the UIs

- **Hadoop NameNode**: http://localhost:9870
- **Spark Master**: http://localhost:8080

## Common Commands

### View logs

```bash
docker compose logs -f
docker compose logs -f spark-master
docker compose logs -f namenode
```

### Stop the cluster

```bash
docker compose down
```

### HDFS Operations

```bash
# List HDFS root
docker exec namenode hdfs dfs -ls /

# Create a directory
docker exec namenode hdfs dfs -mkdir /test

# Upload a file
docker exec namenode hdfs dfs -put /path/to/file /test/
```

### Spark Submit

```bash
docker exec spark-master spark-submit \
  --master spark://spark-master:7077 \
  --class org.apache.spark.examples.SparkPi \
  /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 100
```

## Network

All containers communicate over a Docker bridge network named `hadoop_spark_network`.

## Health Checks

- NameNode health check: HTTP request to port 9870
- Spark Master health check: HTTP request to port 8080
- DataNode waits for NameNode to be healthy
- Spark Worker depends on Spark Master

## Troubleshooting

### Services won't start

Check logs:

```bash
docker compose logs namenode
docker compose logs datanode
docker compose logs spark-master
```

### NameNode in SafeMode

This is normal on first startup. Wait a few moments:

```bash
docker exec namenode hdfs dfsadmin -safemode leave
```

### Container keeps restarting

Check disk space and ensure ports 9870, 9000, 8080, 8081 are not in use

## Port Mappings

| Service      | Port | Purpose      |
| ------------ | ---- | ------------ |
| NameNode     | 9870 | Web UI       |
| HDFS         | 9000 | RPC          |
| Spark Master | 8080 | Web UI       |
| Spark Master | 7077 | Cluster Port |
| Spark Worker | 8081 | Web UI       |
# hadoop-spark-docker
