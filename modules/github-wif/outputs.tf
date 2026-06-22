output "wif_provider" {
  description = "The Workload Identity Provider resource name"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "deploy_sa_email" {
  description = "The deployer service account email"
  value       = google_service_account.deployer.email
}
