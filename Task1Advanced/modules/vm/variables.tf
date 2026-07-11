variable "instance_name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "zone" {
  description = "Зона доступности Yandex Cloud"
  type        = string
  default     = "ru-central1-a"
}

variable "cores" {
  description = "Количество ядер CPU"
  type        = number
  default     = 2
}

variable "ram" {
  description = "Объём RAM в ГБ"
  type        = number
  default     = 4
}

variable "image_id" {
  description = "ID образа ОС (например, Ubuntu 22.04 LTS)"
  type        = string
  default     = "fd87va5cc00ga9l6r3v8"
}

variable "subnet_id" {
  description = "ID подсети, в которой будет размещена ВМ"
  type        = string
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для доступа к ВМ (содержимое файла .pub)"
  type        = string
  sensitive   = true
}

variable "disk_size" {
  description = "Размер подключаемого диска в ГБ"
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "Тип диска (network-hdd, network-ssd, network-ssd-nonreplicated)"
  type        = string
  default     = "network-hdd"
}

variable "boot_disk_size" {
  description = "Размер загрузочного диска в ГБ"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "Тип загрузочного диска"
  type        = string
  default     = "network-hdd"
}

variable "enable_nat" {
  description = "Включить публичный IP-адрес (NAT) для ВМ"
  type        = bool
  default     = true
}