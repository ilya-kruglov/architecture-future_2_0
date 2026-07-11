terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.215"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

# Провайдер использует переменные окружения:
#   YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID
provider "yandex" {
  # ничего не указываем – данные берутся из окружения
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "yandex_storage_bucket" "test" {
  bucket = "test-bucket-${random_string.suffix.result}"
  acl    = "public-read"
}
