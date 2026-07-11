# Модуль Terraform для создания ВМ в Yandex Cloud

Данный модуль предназначен для развёртывания виртуальных машин в облаке Yandex Cloud с возможностью тонкой настройки вычислительных ресурсов, дисков и сетевых параметров. Он разработан для использования в трёх окружениях: `dev`, `stage` и `prod`, что позволяет управлять инфраструктурой с разными конфигурациями через единый переиспользуемый модуль.

## Структура проекта

```
Task1Advanced/
├── modules/
│ └── vm/ # Переиспользуемый модуль ВМ
│ ├── main.tf # Ресурсы: инстанс, дополнительный диск
│ ├── variables.tf # Входные параметры модуля
│ └── outputs.tf # Выходные значения
├── envs/
│ ├── dev/
│ │ ├── main.tf # Конфигурация окружения dev
│ │ └── terraform.tfvars # Значения переменных для dev
│ ├── stage/
│ │ ├── main.tf
│ │ └── terraform.tfvars
│ └── prod/
│ ├── main.tf
│ └── terraform.tfvars
└── README.md
```

## Возможности модуля

- Создание ВМ с заданным количеством ядер CPU и объёмом RAM.
- Подключение дополнительного диска (настраиваемый тип и размер).
- Управление загрузочным диском (тип, размер, образ ОС).
- Выбор зоны доступности и подсети.
- Возможность включить/отключить публичный IP (NAT).
- Передача публичного SSH-ключа для доступа.
- Все параметры вынесены в переменные – никаких захардкоженных значений окружений.

## Параметры модуля

| Имя | Тип | Описание | Обязательный |
|-----|-----|----------|--------------|
| `instance_name` | `string` | Имя виртуальной машины | да |
| `zone` | `string` | Зона доступности (по умолчанию `ru-central1-a`) | нет |
| `cores` | `number` | Количество ядер CPU (по умолчанию 2) | нет |
| `ram` | `number` | Объём RAM в ГБ (по умолчанию 4) | нет |
| `image_id` | `string` | ID образа ОС (по умолчанию Ubuntu 22.04 LTS) | нет |
| `subnet_id` | `string` | ID подсети, в которой будет размещена ВМ | да |
| `ssh_public_key` | `string` | Публичный SSH-ключ (содержимое файла .pub) | да |
| `disk_size` | `number` | Размер дополнительного диска в ГБ (по умолчанию 20) | нет |
| `disk_type` | `string` | Тип дополнительного диска (`network-hdd`, `network-ssd` и др.) | нет |
| `boot_disk_size` | `number` | Размер загрузочного диска в ГБ (по умолчанию 10) | нет |
| `boot_disk_type` | `string` | Тип загрузочного диска (по умолчанию `network-hdd`) | нет |
| `enable_nat` | `bool` | Включает публичный IP-адрес (NAT) (по умолчанию `true`) | нет |

## Выходные значения

| Имя | Описание |
|-----|----------|
| `instance_id` | ID созданной ВМ |
| `instance_name` | Имя ВМ |
| `internal_ip` | Внутренний IP-адрес |
| `external_ip` | Публичный IP-адрес (если включён NAT) |
| `extra_disk_id` | ID дополнительного диска |
| `extra_disk_size` | Размер дополнительного диска |

## Установка и настройка

### 1. Установка Terraform

Для Ubuntu / Debian:
```bash
sudo snap install terraform --classic
```

Проверьте версию:
```bash
terraform version
```
Рекомендуется версия ≥ 1.0.

### 2. Установка провайдера Yandex Cloud вручную (при ограниченном доступе к реестру)

Из-за географических ограничений доступ к `registry.terraform.io` может быть недоступен. В этом случае рекомендуется установить провайдер вручную через локальный `mirror`.

Шаги:
1. Скачайте бинарный файл провайдера версии **0.215.0** (используется в проекте) с официального GitHub-репозитория:
    ```bash
    wget https://github.com/yandex-cloud/terraform-provider-yandex/releases/download/v0.215.0/terraform-provider-yandex_0.215.0_linux_amd64.zip
    ```
    Если `wget` не работает, скачайте архив вручную через браузер и передайте на сервер.
2. Распакуйте архив в директорию плагинов `Terraform`:
    ```bash
    mkdir -p ~/.terraform.d/plugins/registry.terraform.io/yandex-cloud/yandex/0.215.0/linux_amd64
    unzip terraform-provider-yandex_0.215.0_linux_amd64.zip -d ~/.terraform.d/plugins/registry.terraform.io/yandex-cloud/yandex/0.215.0/linux_amd64/
    ```
3. Настройте `architecture-future_2_0/terraform.rc` для использования локального mirror:
    ```hcl
    provider_installation {
      filesystem_mirror {
        path    = "~/.terraform.d/plugins"
        include = ["yandex-cloud/yandex"]
      }
      direct {
        exclude = ["yandex-cloud/yandex"]
      }
    }
    ```
    Это заставит `Terraform` загружать провайдер из локального каталога, не обращаясь к заблокированному реестру.
4. Убедитесь, что файл `terraform-provider-yandex_v0.215.0` находится по указанному пути и имеет права на исполнение:
    ```bash
    ll .terraform.d/plugins/registry.terraform.io/yandex-cloud/yandex/0.215.0/linux_amd64/
    total 122732
    drwxrwxr-x 2 xxx xxx      4096 июл 11 15:11 ./
    drwxrwxr-x 3 xxx xxx      4096 июл 11 15:11 ../
    -rw-r--r-- 1 xxx xxx    138153 июл  9 10:37 CHANGELOG.md
    -rw-r--r-- 1 xxx xxx     16725 июл  9 10:37 LICENSE
    -rw-r--r-- 1 xxx xxx      8845 июл  9 10:37 README.md
    -rwxr-xr-x 1 xxx xxx 125489336 июл  9 10:32 terraform-provider-yandex_v0.215.0*
    ```

### 3. Настройка учётных данных Yandex Cloud

Для работы с провайдером необходимо указать:
- `cloud_id` – ID вашего облака.
- `folder_id` – ID каталога, в котором будут создаваться ресурсы.
- `token` – OAuth-токен (или сервисный аккаунт с авторизованным ключом).
Эти параметры задаются в файле `terraform.tfvars` для каждого окружения (dev/stage/prod). 
Пример содержимого:
    ```hcl
    cloud_id       = "ваш-cloud-id"
    folder_id      = "ваш-folder-id"
    token          = "ваш-oauth-token"
    subnet_id      = "идентификатор-подсети"
    ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
    ```
    **Важно:** не коммитьте реальные значения в репозиторий. Используйте `.gitignore` для исключения `*.tfvars` (в проекте уже настроен).

## Использование

### Инициализация
Перейдите в каталог нужного окружения, например, `envs/dev`:
```bash
cd Task1Advanced/envs/dev
```
Выполните инициализацию `Terraform`:
```bash
terraform init
```
При успешной инициализации будет создан файл `.terraform.lock.hcl` с информацией о версиях провайдера.

### Проверка синтаксиса
Проверьте корректность конфигурации без подключения к облаку:
```bash
terraform validate
```
Ошибок быть не должно.
```bash
Success! The configuration is valid.
```

### План изменений
Просмотрите, какие ресурсы будут созданы:
```bash
cd /Task1Advanced/envs/dev
terraform plan -var-file=terraform.tfvars
```
Если вы не указываете реальные учётные данные, команда выдаст ошибку аутентификации – это нормально.

### Применение
Для развёртывания инфраструктуры выполните:
```bash
terraform apply -var-file=terraform.tfvars
```
Terraform покажет план и запросит подтверждение. После подтверждения ресурсы будут созданы. По окончании будут выведены выходные значения модуля (IP-адреса, ID дисков и т.д.).

### Уничтожение
Для удаления всех ресурсов, созданных в текущем окружении:
```bash
terraform destroy -var-file=terraform.tfvars
```

### Проверка во всех трёх окружениях
Выполните инициализацию и валидацию для каждого окружения, чтобы убедиться, что конфигурации корректны:
```bash
cd Task1Advanced/envs/dev
terraform init && terraform validate

cd ../stage
terraform init && terraform validate

cd ../prod
terraform init && terraform validate
```
Все три команды должны завершиться без ошибок. Это гарантирует, что модуль переиспользуем, а параметры окружений не конфликтуют.

### Рекомендации по использованию в CI/CD
- Храните `terraform.tfvars` в защищённом хранилище секретов (например, HashiCorp Vault, GitLab CI variables, GitHub Secrets).
- В пайплайнах используйте `terraform plan -var-file=...` для проверки и `terraform apply -auto-approve -var-file=...` для автоматического развёртывания.
- Для stage и prod рекомендуется использовать отдельные сервисные аккаунты с минимальными привилегиями.
- Не забывайте включать в репозиторий файл `.terraform.lock.hcl`, чтобы гарантировать одинаковые версии провайдеров.

### Заключение
Модуль полностью готов к использованию для трёх сред, не содержит захардкоженных значений и легко расширяется. Ручная установка провайдера обеспечивает работу даже в условиях ограниченного доступа к интернет-реестру (для РФ сейчас особенно актуально).