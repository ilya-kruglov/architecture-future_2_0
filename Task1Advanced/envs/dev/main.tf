terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.78"
    }
  }
}

variable "cloud_id" {
  description = "ID облака Yandex Cloud"
  type        = string
}

variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}

variable "token" {
  description = "OAuth-токен для доступа к Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "ID подсети для ВМ"
  type        = string
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ"
  type        = string
  sensitive   = true
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  token     = var.token
}

module "vm" {
  source = "../../modules/vm"

  instance_name   = "dev-vm"
  zone            = "ru-central1-a"
  cores           = 2
  ram             = 4
  subnet_id       = var.subnet_id
  ssh_public_key  = var.ssh_public_key
  disk_size       = 20
  disk_type       = "network-hdd"
  boot_disk_size  = 10
  boot_disk_type  = "network-hdd"
}