#!/bin/bash

# 🚀 Скрипт быстрого старта оптимизации разработки
# Автоматизирует первые шаги для ускорения в 10х

set -e

echo "=================================="
echo "🚀 10x Development Acceleration"
echo "=================================="
echo ""

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для проверки команды
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Функция для успешного сообщения
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Функция для предупреждения
warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Функция для ошибки
error() {
    echo -e "${RED}✗ $1${NC}"
}

echo "Шаг 1: Анализ текущего состояния репозитория"
echo "============================================="
echo ""

# Проверяем, находимся ли мы в git репозитории
if [ -d .git ]; then
    success "Git репозиторий найден"
    
    # Анализ git метрик
    echo ""
    echo "📊 Анализ Git метрик за последний месяц:"
    echo ""
    
    COMMITS_LAST_MONTH=$(git log --all --since="1 month ago" --oneline | wc -l)
    echo "Коммитов за месяц: $COMMITS_LAST_MONTH"
    
    CONTRIBUTORS=$(git shortlog -sn --since="1 month ago" | wc -l)
    echo "Активных контрибьюторов: $CONTRIBUTORS"
    
    if [ $COMMITS_LAST_MONTH -gt 0 ] && [ $CONTRIBUTORS -gt 0 ]; then
        COMMITS_PER_PERSON=$((COMMITS_LAST_MONTH / CONTRIBUTORS))
        echo "Среднее коммитов/человек: $COMMITS_PER_PERSON"
    fi
    
    echo ""
    echo "Топ контрибьюторы:"
    git shortlog -sn --since="1 month ago" | head -5
    
else
    warning "Не найден git репозиторий. Запустите скрипт в корне проекта."
fi

echo ""
echo ""
echo "Шаг 2: Проверка установленных инструментов"
echo "==========================================="
echo ""

# Проверка Node.js
if command_exists node; then
    success "Node.js $(node --version) установлен"
else
    warning "Node.js не установлен"
fi

# Проверка Python
if command_exists python3; then
    success "Python $(python3 --version | cut -d ' ' -f 2) установлен"
else
    warning "Python не установлен"
fi

# Проверка Docker
if command_exists docker; then
    success "Docker $(docker --version | cut -d ' ' -f 3 | tr -d ',') установлен"
else
    warning "Docker не установлен - рекомендуется для dev environment"
fi

# Проверка Docker Compose
if command_exists docker-compose || docker compose version >/dev/null 2>&1; then
    success "Docker Compose установлен"
else
    warning "Docker Compose не установлен"
fi

# Проверка pre-commit
if command_exists pre-commit; then
    success "pre-commit установлен"
else
    warning "pre-commit не установлен (будет установлен позже)"
fi

echo ""
echo ""
echo "Шаг 3: Автоматическая настройка оптимизаций"
echo "============================================"
echo ""

read -p "Хотите автоматически настроить базовые оптимизации? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    
    # 3.1 Pre-commit hooks
    echo ""
    echo "📝 Настройка pre-commit hooks..."
    
    if ! command_exists pre-commit; then
        if command_exists pip3; then
            pip3 install pre-commit
            success "pre-commit установлен"
        else
            warning "Не удалось установить pre-commit (нужен pip3)"
        fi
    fi
    
    # Создаём базовый .pre-commit-config.yaml если его нет
    if [ ! -f .pre-commit-config.yaml ]; then
        cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-json
      - id: check-merge-conflict
      - id: detect-private-key

  # JavaScript/TypeScript
  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v8.56.0
    hooks:
      - id: eslint
        files: \.(js|jsx|ts|tsx)$
        args: ['--fix']

  # Python
  - repo: https://github.com/psf/black
    rev: 23.12.1
    hooks:
      - id: black
        language_version: python3

  - repo: https://github.com/pycqa/flake8
    rev: 7.0.0
    hooks:
      - id: flake8
EOF
        success "Создан .pre-commit-config.yaml"
        
        if command_exists pre-commit; then
            pre-commit install
            success "Pre-commit hooks установлены"
        fi
    else
        warning ".pre-commit-config.yaml уже существует"
    fi
    
    # 3.2 GitHub Actions базовый workflow
    echo ""
    echo "🔄 Настройка GitHub Actions CI/CD..."
    
    if [ -d .git ] && [ ! -d .github/workflows ]; then
        mkdir -p .github/workflows
        
        cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, master, develop ]
  pull_request:
    branches: [ main, master, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linter
      run: npm run lint
    
    - name: Run tests
      run: npm test
    
    - name: Build
      run: npm run build
EOF
        success "Создан .github/workflows/ci.yml"
    else
        if [ -d .github/workflows ]; then
            warning "GitHub Actions уже настроен"
        else
            warning "Не git репозиторий или GitHub Actions не нужен"
        fi
    fi
    
    # 3.3 Docker Compose для локальной разработки
    echo ""
    echo "🐳 Создание базового docker-compose.yml..."
    
    if [ ! -f docker-compose.yml ]; then
        cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # База данных (PostgreSQL)
  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
      POSTGRES_DB: devdb
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  # Redis для кэширования
  redis:
    image: redis:7-alpine
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  # Mailhog для тестирования email
  mailhog:
    image: mailhog/mailhog:latest
    restart: unless-stopped
    ports:
      - "1025:1025"  # SMTP
      - "8025:8025"  # Web UI

volumes:
  postgres_data:
  redis_data:
EOF
        success "Создан docker-compose.yml"
        echo "   Запустите: docker-compose up -d"
    else
        warning "docker-compose.yml уже существует"
    fi
    
    # 3.4 .env.example
    echo ""
    echo "🔐 Создание .env.example..."
    
    if [ ! -f .env.example ]; then
        cat > .env.example << 'EOF'
# Database
DATABASE_URL=postgresql://devuser:devpass@localhost:5432/devdb

# Redis
REDIS_URL=redis://localhost:6379

# API Keys (заменить на реальные)
API_SECRET_KEY=your-secret-key-here

# Email (локальная разработка с Mailhog)
SMTP_HOST=localhost
SMTP_PORT=1025

# App
NODE_ENV=development
PORT=3000
EOF
        success "Создан .env.example"
        
        if [ ! -f .env ]; then
            cp .env.example .env
            success "Создан .env из .env.example"
        fi
    else
        warning ".env.example уже существует"
    fi
    
    # 3.5 .editorconfig для единого форматирования
    echo ""
    echo "⚙️  Создание .editorconfig..."
    
    if [ ! -f .editorconfig ]; then
        cat > .editorconfig << 'EOF'
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[*.py]
indent_size = 4

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
EOF
        success "Создан .editorconfig"
    else
        warning ".editorconfig уже существует"
    fi
    
    echo ""
    success "Автоматическая настройка завершена!"
    
fi

echo ""
echo ""
echo "Шаг 4: Рекомендации для команды"
echo "================================"
echo ""

echo "📋 Немедленные действия:"
echo ""
echo "1. Включите AI-ассистенты:"
echo "   - GitHub Copilot: https://github.com/features/copilot"
echo "   - Cursor: https://cursor.sh"
echo ""
echo "2. Настройте CI/CD:"
echo "   - Если создан .github/workflows/ci.yml - закоммитьте его"
echo "   - Добавьте правила защиты веток (требовать проверки CI)"
echo ""
echo "3. Запустите dev окружение:"
echo "   $ docker-compose up -d"
echo "   $ cp .env.example .env  # если ещё не скопирован"
echo ""
echo "4. Установите pre-commit hooks:"
echo "   $ pre-commit install"
echo ""
echo "5. Проведите командный созвон (30 мин):"
echo "   - Обсудите plan в 10x-acceleration-plan.md"
echo "   - Заполните assessment-checklist.md"
echo "   - Выберите 3-5 приоритетных оптимизаций"
echo ""

echo ""
echo "📚 Документация создана:"
echo ""
echo "   📄 10x-acceleration-plan.md - детальный план"
echo "   ✅ assessment-checklist.md - чек-лист оценки"
echo "   🚀 quick-start-script.sh - этот скрипт"
echo ""

echo ""
echo "🎯 Следующие шаги:"
echo ""
echo "1. Прочитайте 10x-acceleration-plan.md (15 минут)"
echo "2. Заполните assessment-checklist.md (30 минут)"
echo "3. Выберите 5 quick wins и внедрите их на этой неделе"
echo "4. Измерьте baseline метрики (lead time, deploy frequency)"
echo "5. Запланируйте weekly ретро для отслеживания прогресса"
echo ""

echo ""
echo "=================================="
echo "✨ Удачи в ускорении разработки!"
echo "=================================="
echo ""

