# Data Stack Setup Guide

This repository contains a complete data stack setup using Docker Compose, including PostgreSQL, Kafka, Debezium, Elasticsearch, Kibana, Cassandra, and Redis.

## Prerequisites

- Docker
- Docker Compose

## Services Overview

- **PostgreSQL**: Database server running on port 5432
- **Kafka**: Message broker with Zookeeper
  - Kafka UI: http://localhost:8081
  - Kafka port: 29092
- **Debezium**: CDC (Change Data Capture) connector
  - Debezium UI: http://localhost:8083
- **Elasticsearch**: Search and analytics engine
  - Port: 9200
  - Default credentials: elastic/elastic
- **Kibana**: Data visualization platform
  - Port: 5601
- **Cassandra**: NoSQL database
  - Port: 9042
- **Redis**: In-memory data store
  - Port: 6379
  - Password: redis

## Getting Started

1. Clone this repository:

```bash
git clone <repository-url>
cd <repository-name>
```

2. Start all services:

```bash
docker-compose -f docker-compose-postgres.yaml up -d
docker-compose -f docker-compose-kafka.yaml up -d
docker-compose -f docker-compose-debezium.yaml up -d
docker-compose -f docker-compose-elasticsearch.yaml up -d
docker-compose -f docker-compose-cassandra.yaml up -d
docker-compose -f docker-compose-redis.yaml up -d
```

3. Generate Elasticsearch service token for Kibana:

```bash
docker exec -it elasticsearch bin/elasticsearch-service-tokens create elastic/kibana kibana-token
```

Copy the generated token and update it in the `kibana.yml` file under `elasticsearch.serviceAccountToken`.

4. Verify services are running:

```bash
docker ps
```

## Service Access

### PostgreSQL

- Host: localhost
- Port: 5432
- Username: postgres
- Password: postgres
- Database: postgres

### Kafka

- Bootstrap servers: localhost:29092
- UI: http://localhost:8081

### Debezium

- UI: http://localhost:8083
- Example connector configuration available in `debezium-connector.http`

### Elasticsearch

- URL: http://localhost:9200
- Username: elastic
- Password: elastic

### Kibana

- URL: http://localhost:5601

### Cassandra

- Host: localhost
- Port: 9042
- Username: cassandra
- Password: cassandra

### Redis

- Host: localhost
- Port: 6379
- Password: redis

## Stopping Services

To stop all services:

```bash
docker-compose -f docker-compose-postgres.yaml down
docker-compose -f docker-compose-kafka.yaml down
docker-compose -f docker-compose-debezium.yaml down
docker-compose -f docker-compose-elasticsearch.yaml down
docker-compose -f docker-compose-cassandra.yaml down
docker-compose -f docker-compose-redis.yaml down
```

## Data Persistence

All services use Docker volumes for data persistence:

- PostgreSQL data: `postgres_data`
- Kafka data: `kafka_data`
- Zookeeper data: `zookeeper_data`
- Debezium data: `debezium_data`
- Elasticsearch data: `elasticsearch_data`
- Cassandra data: `cassandra_data`
- Redis data: `data_redis`

## Notes

- Make sure all required ports are available on your system
- The services are configured for development purposes
- For production use, please review and adjust security settings
- Some services may take a few minutes to start up completely
