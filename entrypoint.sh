#!/bin/sh
set -e

# Явно экспортируем переменные, чтобы envsubst их видел
export HYDRA_API_KEY
export HYDRA_API_BASE

echo "=== Переменные окружения ==="
echo "HYDRA_API_KEY: $HYDRA_API_KEY"
echo "HYDRA_API_BASE: $HYDRA_API_BASE"
echo "============================"

echo "Подставляем переменные в config.yaml..."
envsubst < /app/config.yaml.tpl > /app/config.yaml

echo "=== Сгенерированный config.yaml ==="
cat /app/config.yaml
echo "=================================="

echo "Запускаем litellm..."
exec litellm --config /app/config.yaml --port 8003