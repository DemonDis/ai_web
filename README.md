# Инструкция по запуску Open WebUI
Open WebUI: Веб-интерфейс для запуска и управления большими языковыми моделями.
Ollama: Инструмент для простого запуска LLM локально.
LiteLLM: Универсальный прокси для работы с различными LLM API.

- Open WebUI - http://localhost:3002
- Ollama - http://localhost:11434
- LiteLLM - http://localhost:8003

## Настройка окружения и запуск
Создание виртуального окружения Python
```bash
python3 -m venv .venv
```

## Активация виртуального окружения
```bash
. .venv/bin/activate
# Команда для выхода из окружения
deactivate
```

## Установка зависимостей проекта
```bash
pip3 install -r requirements.txt
```

## Установка LiteLLM с поддержкой прокси
```bash
pip install 'litellm[proxy]'
```

## Запуск LiteLLM прокси
```bash
litellm --config config.yaml --port 8003
```

## Скачивание образа Open WebUI
```bash
docker pull ghcr.io/open-webui/open-webui:main
```

## Запуск Open WebUI в Docker
Необходимо подождать, запуск занимает время
```bash
docker run -d \
  --add-host=host.docker.internal:host-gateway \
  -p 3002:8080 \
  -e OPENAI_API_BASE_URL="http://host.docker.internal:8003" \
  -e OPENAI_API_KEY="any" \
  -e OLLAMA_BASE_URL=http://none \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
  ```

## Скачивание образа Ollama
```bash
docker pull ollama/ollama
```

## Запуск Ollama в Docker
```bash
docker run -d \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --name ollama \
  ollama/ollama
```

## Вход в контейнер Ollama
Позволяет выполнять команды внутри контейнера Ollama
```bash
docker exec -it ollama bash
```

## Запуск языковой модели через Ollama
Загружает и запускает модель **deepseek-r1:1.5b**
```bash
ollama run deepseek-r1:1.5b
```

## Проверка доступности LiteLLM
Отправляет запрос к API LiteLLM для получения списка моделей
```bash
curl http://localhost:8003/models
# внутри контейнера
curl http://host.docker.internal:8003/models
```

## Проверка работы модели (пример)
```bash
curl URL_МОДЕЛИ \
  -H "Authorization: Bearer ВАШ_КЛЮЧ"
```

## Информация о дисковом пространстве
```bash
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          4         2         13.65GB   6.653GB (48%)
Containers      2         2         41.89MB   0B (0%)
Local Volumes   2         2         7.223GB   0B (0%)
Build Cache     0         0         0B        0B
```

  ### Технологический стек
- **Python**: 3.10.12
- **Docker**: 28.3.3, build 980b856
