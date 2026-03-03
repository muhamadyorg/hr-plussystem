#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/hrplus-deploy.log"
ENV_FILE="$PROJECT_DIR/.env"

echo "[$(date)] HR-Plus System deployment started" | tee -a "$LOG_FILE"
cd "$PROJECT_DIR"

if [ ! -f "$ENV_FILE" ]; then
    cp .env.example .env
    echo "[INFO] .env fayli yaratildi. Iltimos .env faylini tahrirlang va qayta ishga tushiring." | tee -a "$LOG_FILE"
    exit 1
fi

source "$ENV_FILE" 2>/dev/null || true

PORTS=(17463 23891 34572 41239 52847 44821 38456 29173 56392 47215 8182 8183 8184 8185)
FREE_PORT=""
for port in "${PORTS[@]}"; do
    if ! ss -tlnp 2>/dev/null | grep -q ":$port " && ! netstat -tlnp 2>/dev/null | grep -q ":$port "; then
        if ! docker ps --format "{{.Ports}}" 2>/dev/null | grep -q ":$port->"; then
            FREE_PORT=$port
            break
        fi
    fi
done

if [ -z "$FREE_PORT" ]; then
    echo "[ERROR] Boш port topilmadi!" | tee -a "$LOG_FILE"
    exit 1
fi

if grep -q "^APP_PORT=" "$ENV_FILE" 2>/dev/null; then
    sed -i "s/^APP_PORT=.*/APP_PORT=$FREE_PORT/" "$ENV_FILE"
else
    echo "APP_PORT=$FREE_PORT" >> "$ENV_FILE"
fi

echo "[INFO] Port: $FREE_PORT" | tee -a "$LOG_FILE"

docker compose -f docker-compose.yml --project-name hr-plussystem pull postgres nginx 2>/dev/null || true
docker compose -f docker-compose.yml --project-name hr-plussystem build app
docker compose -f docker-compose.yml --project-name hr-plussystem up -d

echo "" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo " HR-Plus System ishga tushdi!" | tee -a "$LOG_FILE"
echo " URL: http://$(curl -s ifconfig.me 2>/dev/null || echo 'SERVER_IP'):$FREE_PORT" | tee -a "$LOG_FILE"
echo " Log: $LOG_FILE" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
