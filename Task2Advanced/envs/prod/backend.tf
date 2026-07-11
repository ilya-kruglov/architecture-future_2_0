terraform {
  backend "s3" {
    endpoint   = var.minio_endpoint
    bucket     = var.minio_bucket
    key        = "envs/prod/terraform.tfstate"
    region     = "us-east-1"
    access_key = var.minio_access_key
    secret_key = var.minio_secret_key
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
