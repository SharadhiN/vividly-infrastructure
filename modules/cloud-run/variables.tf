variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-south1"
}

variable "service_name" {
  type = string
}

variable "image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "vpc_connector_id" {
  type    = string
  default = ""
}

variable "service_account_email" {
  type = string
}

variable "min_instances" {
  type    = number
  default = 1
}

variable "max_instances" {
  type    = number
  default = 10
}

variable "cpu" {
  type    = string
  default = "1"
}

variable "memory" {
  type    = string
  default = "512Mi"
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "secrets" {
  type    = map(string)
  default = {}
}

variable "vpc_egress" {
  type        = string
  description = "VPC egress setting. Use PRIVATE_RANGES_ONLY for services that need both private VPC (DB/Redis) and public internet (external APIs). Use ALL_TRAFFIC only if all outbound must go through VPC."
  default     = "PRIVATE_RANGES_ONLY"

  validation {
    condition     = contains(["ALL_TRAFFIC", "PRIVATE_RANGES_ONLY"], var.vpc_egress)
    error_message = "vpc_egress must be either ALL_TRAFFIC or PRIVATE_RANGES_ONLY."
  }
}
variable "vpc_network" {
  type        = string
  description = "VPC network name for Direct VPC egress"
}

variable "vpc_subnet" {
  type        = string
  description = "Subnet name for Direct VPC egress"
}
