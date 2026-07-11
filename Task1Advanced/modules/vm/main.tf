terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.78"
    }
  }
}

resource "yandex_compute_disk" "extra_disk" {
  name     = "${var.instance_name}-extra-disk"
  zone     = var.zone
  size     = var.disk_size
  type     = var.disk_type
}

resource "yandex_compute_instance" "vm" {
  name        = var.instance_name
  zone        = var.zone
  platform_id = "standard-v2"

  resources {
    cores  = var.cores
    memory = var.ram
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.boot_disk_size
      type     = var.boot_disk_type
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.extra_disk.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.enable_nat
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}