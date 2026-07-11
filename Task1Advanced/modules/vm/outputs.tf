output "instance_id" {
  description = "ID созданной ВМ"
  value       = yandex_compute_instance.vm.id
}

output "instance_name" {
  description = "Имя ВМ"
  value       = yandex_compute_instance.vm.name
}

output "internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "external_ip" {
  description = "Публичный IP-адрес ВМ (если nat = true)"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "extra_disk_id" {
  description = "ID дополнительного диска"
  value       = yandex_compute_disk.extra_disk.id
}

output "extra_disk_size" {
  description = "Размер дополнительного диска"
  value       = yandex_compute_disk.extra_disk.size
}