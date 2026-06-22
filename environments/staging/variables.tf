variable "project_id" {
  description = "GCP Project ID"
  default     = "vividly-dev-1"
}
variable "region" {
  description = "GCP Region"
  default     = "asia-south1"
}
variable "env" {
  description = "Environment name — used in all resource names"
  default     = "staging"
}

variable "backend_image_tag" {
  description = "Initial backend image tag — CI/CD owns it after first create"
  type        = string
  default     = "latest"
}
variable "frontend_image_tag" {
  description = "Initial frontend image tag — CI/CD owns it after first create"
  type        = string
  default     = "latest"
}