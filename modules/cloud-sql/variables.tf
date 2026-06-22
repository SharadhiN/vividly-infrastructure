variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-south1"
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "sql_connection" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_tier" {
  type    = string
  default = "db-f1-micro"
}

variable "backup_enabled" {
  type    = bool
  default = false
}

variable "deletion_protection" {
  type    = bool
  default = false
}