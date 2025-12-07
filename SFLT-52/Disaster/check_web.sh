#!/bin/bash

PORT=80
WEB_ROOT="/var/www/html"
INDEX_FILE="$WEB_ROOT/index.nginx-debian.html"

if ! nc -z localhost $PORT 2>/dev/null; then
    echo "Порт $PORT не доступен"
    exit 1
fi

if [ ! -f "$INDEX_FILE" ]; then
    echo "index.html не найден в $WEB_ROOT"
    exit 1
fi

echo "Проверка веб-сервера пройдена"
exit 0