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
}

# Ресурс для управления публичным доступом
resource "yandex_storage_bucket_grant" "public_read" {
  bucket = yandex_storage_bucket.test.bucket

  grant {
    id          = "gid:allUsers"
    type        = "group"
    permissions = ["READ"] # Предоставляем право на чтение всем
  }
}