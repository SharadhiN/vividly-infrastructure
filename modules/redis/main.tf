resource "google_redis_instance" "cache" {
  name               = "tailtales-redis-${var.env}"
  project            = var.project_id
  region             = var.region
  tier               = "BASIC"
  memory_size_gb     = 1
  redis_version      = "REDIS_7_0"
  authorized_network = var.vpc_name
}