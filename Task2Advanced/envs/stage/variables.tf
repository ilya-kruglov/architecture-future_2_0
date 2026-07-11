variable "minio_endpoint" {
  description = "URL MinIO (например, http://localhost:9000)"
  type        = string
}

variable "minio_bucket" {
  description = "Имя бакета для хранения состояния"
  type        = string
  default     = "tfstate"
}

variable "minio_access_key" {
  description = "Access Key для MinIO"
  type        = string
  sensitive   = true
}

variable "minio_secret_key" {
  description = "Secret Key для MinIO"
  type        = string
  sensitive   = true
}