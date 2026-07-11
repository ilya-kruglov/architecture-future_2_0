# Задание 2: CI/CD и удалённое состояние

## Описание
В этом задании реализован полный цикл управления инфраструктурой с использованием:
- **Terraform** с удалённым состоянием в **MinIO** (S3-совместимое хранилище).
- **GitHub Actions** для автоматического планирования (`plan`) и ручного применения (`apply`) с подтверждением.
- Поддержка трёх окружений: `dev`, `stage`, `prod`.
- Аутентификация в **Yandex Cloud** через переменные окружения (`YC_TOKEN`, `YC_CLOUD_ID`, `YC_FOLDER_ID`).

## Структура каталогов
```text
Task2Advanced/
├── envs/
│ ├── dev/
│ │ ├── backend.tf # Настройка S3 backend (MinIO)
│ │ ├── main.tf # Тестовый ресурс (бакет)
│ │ ├── variables.tf # Переменные для MinIO
│ │ └── terraform.tfvars.example # Шаблон переменных
│ ├── stage/ (аналогично)
│ └── prod/ (аналогично)
├── docker-compose.yml # MinIO + создание бакета
└── README.md
```

Корневая директория репозитория (`architecture-future_2_0`) также содержит:
`.github/workflows/terraform.yml` – CI/CD пайплайн

## Локальная проверка

### 1. Установите переменные окружения для Yandex Cloud
```bash
export YC_TOKEN="<ваш OAuth-токен>"
export YC_CLOUD_ID="<ID облака>"
export YC_FOLDER_ID="<ID каталога>"
```

### 2. (Опционально) Задайте свои учётные данные MinIO, иначе будут использованы `minioadmin`/`minioadmin`
```bash
export MINIO_ROOT_USER="myuser"
export MINIO_ROOT_PASSWORD="mypassword"
```

### 3. Запустите MinIO
```bash
cd Task2Advanced
docker-compose up -d
```

### 4. Перейдите в нужное окружение (например, dev)
```bash
cd envs/dev
cp terraform.tfvars.example terraform.tfvars
# При необходимости отредактируйте terraform.tfvars
```

### 5. Выполните Terraform
```bash
terraform init
terraform plan
terraform apply
```
После применения будет создан бакет с случайным суффиксом. Состояние сохранится в MinIO (бакет `tfstate`).

## GitHub Actions

### Настройка секретов
В репозитории (`Settings` → `Secrets and variables` → `Actions`) **обязательно** добавьте следующие секреты для Yandex Cloud:
- `YC_TOKEN`
- `YC_CLOUD_ID`
- `YC_FOLDER_ID`

Для MinIO **рекомендуется** добавить секреты (если не заданы, будут использованы значения по умолчанию `minioadmin`):
- `MINIO_ACCESS_KEY` (соответствует `MINIO_ROOT_USER`)
- `MINIO_SECRET_KEY` (соответствует `MINIO_ROOT_PASSWORD`)

### Workflow
Файл `.github/workflows/terraform.yml` находится в корне репозитория и будет автоматически обнаружен GitHub.

**Триггеры:**
- Push в `main` → запускается `plan`.
- Pull Request в `main` → также `plan`.
- Ручной запуск (`workflow_dispatch`) с выбором окружения и действия (`plan` или `apply`).

**Этапы:**
1. Установка учётных данных MinIO из секретов (или дефолтных).
2. Запуск MinIO как сервиса в Docker.
3. Настройка переменных окружения для Yandex Cloud.
4. `terraform init` (использует MinIO как backend).
5. `terraform plan` (с сохранением артефакта).
6. Для `apply` – загрузка артефакта и применение.

### Безопасность
- Ключи доступа к Yandex Cloud и MinIO передаются через **секреты GitHub**, не хранятся в коде.
- Для `apply` используется GitHub Environment, что позволяет добавить ручное подтверждение.
- Файлы `terraform.tfvars` не коммитятся (исключены в `.gitignore`).
- В production **обязательно** переопределите учётные данные MinIO через секреты (**не используйте значения по умолчанию**).