terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Reads the DB password from Secret Manager at plan/apply time.
# No password in any .tfvars, env var, or hardcoded value.
data "google_secret_manager_secret_version" "db_password" {
  secret  = "tailtales-db-password"
  project = var.project_id
}

locals {
  registry       = "asia-south1-docker.pkg.dev/${var.project_id}/tailtales"
  backend_image  = "${local.registry}/api:${var.backend_image_tag}"
  frontend_image = "${local.registry}/frontend:${var.frontend_image_tag}"
}

module "vpc" {
  source     = "../../modules/vpc"
  project_id = var.project_id
  region     = var.region
  env        = var.env
}

module "cloud_sql" {
  source              = "../../modules/cloud-sql"
  project_id          = var.project_id
  region              = var.region
  env                 = var.env
  vpc_id              = module.vpc.vpc_id
  sql_connection      = module.vpc.sql_connection
  db_password         = data.google_secret_manager_secret_version.db_password.secret_data
  db_tier             = "db-f1-micro"
  backup_enabled      = false
  deletion_protection = false
}

module "redis" {
  source     = "../../modules/redis"
  project_id = var.project_id
  region     = var.region
  env        = var.env
  vpc_name   = module.vpc.vpc_name
}

module "backend" {
  source                = "../../modules/cloud-run"
  project_id            = var.project_id
  region                = var.region
  service_name          = "tailtales-api-${var.env}"
  image                 = local.backend_image
  container_port        = 3000
  vpc_network           = module.vpc.vpc_name
  vpc_subnet            = module.vpc.subnet_name
  vpc_egress            = "PRIVATE_RANGES_ONLY" # Private IPs (DB/Redis) via VPC; internet (MessageCentral, SMTP) via direct egress
  service_account_email = "194298394361-compute@developer.gserviceaccount.com"
  min_instances         = 0
  max_instances         = 5
  cpu                   = "1"
  memory                = "1Gi"

  env_vars = {
    NODE_ENV  = "production"
    DB_PORT   = "5432"
    DB_SSL    = "require"
    LOG_LEVEL = "info"
  }

  secrets = {
    # Database
    DB_HOST     = "tailtales-db-host"
    DB_NAME     = "tailtales-db-name"
    DB_USER     = "tailtales-db-user"
    DB_PASSWORD = "tailtales-db-password"

    # Auth & Cache
    JWT_SECRET  = "tailtales-jwt-secret"
    REDIS_URL   = "tailtales-redis-url"
    CORS_ORIGIN = "tailtales-cors-origin"

    # SMS — MessageCentral
    SMS_PROVIDER               = "tailtales-sms-provider"
    MESSAGECENTRAL_CUSTOMER_ID = "tailtales-mc-customer-id"
    MESSAGECENTRAL_PASSWORD    = "tailtales-mc-password"
    MESSAGECENTRAL_EMAIL       = "tailtales-mc-email"
    MESSAGECENTRAL_COUNTRY     = "tailtales-mc-country"

    # Email — Resend SMTP
    SMTP_HOST   = "tailtales-smtp-host"
    SMTP_PORT   = "tailtales-smtp-port"
    SMTP_SECURE = "tailtales-smtp-secure"
    SMTP_USER   = "tailtales-smtp-user"
    SMTP_PASS   = "tailtales-smtp-pass"
    SMTP_FROM   = "tailtales-smtp-from"
  }
}

module "github_wif" {
  source       = "../../modules/github-wif"
  project_id   = var.project_id
  github_owner = "SharadhiN"
  github_repo  = "tailTalesBackend"
}

module "frontend" {
  source                = "../../modules/cloud-run"
  project_id            = var.project_id
  region                = var.region
  service_name          = "tailtales-frontend-${var.env}"
  image                 = local.frontend_image
  container_port        = 8080
  vpc_network           = module.vpc.vpc_name
  vpc_subnet            = module.vpc.subnet_name
  vpc_egress            = "ALL_TRAFFIC" # Frontend proxies to backend only; all traffic via VPC is fine
  service_account_email = "194298394361-compute@developer.gserviceaccount.com"
  min_instances         = 0
  max_instances         = 5
  cpu                   = "1"
  memory                = "512Mi"
  env_vars              = {}
  secrets               = {}
}