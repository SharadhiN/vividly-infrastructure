# ── OUTPUTS ───────────────────────────────────────────────────────────────────
# Printed after terraform apply
# Save these values — you need them to create secrets

output "backend_url" {
  description = "Backend API URL"
  value       = module.backend.service_url
}

output "frontend_url" {
  description = "Frontend URL — open this in browser"
  value       = module.frontend.service_url
}

output "db_private_ip" {
  description = "Use this as DB_HOST when creating the tailtales-db-host secret"
  value       = module.cloud_sql.db_private_ip
}

output "db_connection_name" {
  description = "Use this with Cloud SQL Auth Proxy"
  value       = module.cloud_sql.connection_name
}

output "redis_host" {
  description = "Use this to build REDIS_URL — redis://[this]:6379"
  value       = module.redis.redis_host
}

output "wif_provider" {
  description = "GitHub Actions Variable: WIF_PROVIDER_STAGING"
  value       = module.github_wif.wif_provider
}

output "deploy_sa_email" {
  description = "GitHub Actions Variable: DEPLOY_SA_STAGING"
  value       = module.github_wif.deploy_sa_email
}