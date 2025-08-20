# Инструкция по запуску Open WebUI (LINUX)
**[Open WebUI](https://docs.openwebui.com/)**: Веб-интерфейс для запуска и управления большими языковыми моделями.  
**[Ollama](https://ollama.com/)**: Инструмент для простого запуска LLM локально.  
**[LiteLLM](https://docs.litellm.ai/docs/tutorials/openweb_ui)**: Универсальный прокси для работы с различными LLM API.  

- Open WebUI - `http://localhost:3002`
- Ollama - `http://localhost:11434`
- LiteLLM - `http://localhost:8003`

## Структура проекта
```
📁 web-ai/
├──📁 litellm/ 
|   └── 📝 config.yaml      # Конфигурационный файл LiteLLM внутри директории
├── 📝 .env                 # Переменные с ключами и url (создать самому)
├── 📝 .gitignore
├── 📝 config.yaml.tpl      # Шаблон конфигурационного файла для LiteLLM.
├── 📝 docker-compose.yml
├── 📝 Dockerfile.litellm   # Dockerfile для сборки образа LiteLLM
├── 📝 entrypoint.sh        # Скрипт для запуска контейнеров
├── 📝 README.md
├── 📝 requirements.txt     # Файл, содержащий список зависимостей Python для проекта
└── 📝 test.py              # Скрипт для тестирования функциональности проекта.
```

# ВАРИНАТ 1 - docker compose
## Запуск сборки
```bash
docker-compose up -d --build
# or
docker compose up -d --build
```
## Погасить сборку
```bash
docker-compose down
# or
docker compose down
```

# ВАРИНАТ 2 - ручной/docker
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
docker system df
```
- Результат запроса (без Ollama)
```bash
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          1         1         4.803GB   0B (0%)
Containers      1         1         41.88MB   0B (0%)
Local Volumes   1         1         1.998GB   0B (0%)
Build Cache     0         0         0B        0B
```
- Результат запроса (C Ollama)
```bash
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          3         3         7.569GB   0B (0%)
Containers      3         3         42.61MB   0B (0%)
Local Volumes   2         2         3.139GB   0B (0%)
Build Cache     35        0         1.516GB   1.516GB
```

## API должен быть совместим с OpenAI
Пример запроса к `/chat/completions` (как у OpenAI):
```bash
POST /v1/chat/completions
Headers:
  "Content-Type": "application/json"
  "Authorization": "Bearer your-api-key"

Body:
{
  "model": "gpt-3.5-turbo",  // или другая модель (например, "llama3-70b")
  "messages": [
    {"role": "system", "content": "Ты полезный ассистент."},
    {"role": "user", "content": "Привет! Как дела?"}
  ],
  "temperature": 0.7,
  "max_tokens": 100
}
```

Пример успешного ответа:
```bash
{
  "id": "chatcmpl-123",
  "object": "chat.completion",
  "created": 1677652288,
  "model": "gpt-3.5-turbo",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Привет! У меня всё отлично, спасибо! Как ваши дела?"
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 15,
    "completion_tokens": 20,
    "total_tokens": 35
  }
}
```

### Технологический стек
- **Python**: 3.10.12
- **Docker**: 28.3.3, build 980b856

#### Дополнительная информация
ARENA в Open WebUI (ранее известном как Ollama WebUI) — это интерактивная платформа для тестирования, сравнения и совместной работы с различными языковыми моделями (LLM).
