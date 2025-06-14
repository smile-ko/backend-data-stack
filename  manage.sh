#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to start all services
start_all() {
    print_message "Starting all services..."
    docker-compose -f docker-compose-postgres.yaml up -d
    docker-compose -f docker-compose-kafka.yaml up -d
    docker-compose -f docker-compose-debezium.yaml up -d
    docker-compose -f docker-compose-elasticsearch.yaml up -d
    docker-compose -f docker-compose-cassandra.yaml up -d
    docker-compose -f docker-compose-redis.yaml up -d
    print_message "All services started!"
}

# Function to stop all services
stop_all() {
    print_message "Stopping all services..."
    docker-compose -f docker-compose-postgres.yaml down
    docker-compose -f docker-compose-kafka.yaml down
    docker-compose -f docker-compose-debezium.yaml down
    docker-compose -f docker-compose-elasticsearch.yaml down
    docker-compose -f docker-compose-cassandra.yaml down
    docker-compose -f docker-compose-redis.yaml down
    print_message "All services stopped!"
}

# Function to restart all services
restart_all() {
    stop_all
    start_all
}

# Function to check service status
check_status() {
    print_message "Checking service status..."
    docker ps
}

# Function to generate Elasticsearch token
generate_es_token() {
    print_message "Generating Elasticsearch service token for Kibana..."
    docker exec -it elasticsearch bin/elasticsearch-service-tokens create elastic/kibana kibana-token
    print_message "Token generated! Please update kibana.yml with the new token."
}

# Function to show logs
show_logs() {
    if [ -z "$1" ]; then
        print_error "Please specify a service name"
        echo "Usage: ./manage.sh logs <service_name>"
        echo "Available services: postgres, kafka, zookeeper, debezium, elasticsearch, kibana, cassandra, redis"
        exit 1
    fi

    case $1 in
        postgres)
            docker-compose -f docker-compose-postgres.yaml logs -f
            ;;
        kafka)
            docker-compose -f docker-compose-kafka.yaml logs -f kafka
            ;;
        zookeeper)
            docker-compose -f docker-compose-kafka.yaml logs -f zookeeper
            ;;
        debezium)
            docker-compose -f docker-compose-debezium.yaml logs -f
            ;;
        elasticsearch)
            docker-compose -f docker-compose-elasticsearch.yaml logs -f elasticsearch
            ;;
        kibana)
            docker-compose -f docker-compose-elasticsearch.yaml logs -f kibana
            ;;
        cassandra)
            docker-compose -f docker-compose-cassandra.yaml logs -f
            ;;
        redis)
            docker-compose -f docker-compose-redis.yaml logs -f
            ;;
        *)
            print_error "Unknown service: $1"
            ;;
    esac
}

# Function to show help
show_help() {
    echo "Usage: ./manage.sh <command> [service_name]"
    echo ""
    echo "Commands:"
    echo "  start       Start all services"
    echo "  stop        Stop all services"
    echo "  restart     Restart all services"
    echo "  status      Check status of all services"
    echo "  logs        Show logs for a specific service"
    echo "  token       Generate Elasticsearch token for Kibana"
    echo "  help        Show this help message"
    echo ""
    echo "Services:"
    echo "  postgres, kafka, zookeeper, debezium, elasticsearch, kibana, cassandra, redis"
}

# Main script logic
case "$1" in
    start)
        start_all
        ;;
    stop)
        stop_all
        ;;
    restart)
        restart_all
        ;;
    status)
        check_status
        ;;
    logs)
        show_logs "$2"
        ;;
    token)
        generate_es_token
        ;;
    help|*)
        show_help
        ;;
esac
