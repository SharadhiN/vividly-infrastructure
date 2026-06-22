resource "google_sql_database_instance" "main" {
  name             = "tailtales-db-${var.env}"
  project          = var.project_id
  database_version = "POSTGRES_15"
  region           = var.region
  depends_on       = [var.sql_connection]

  settings {
    tier = var.db_tier

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }

    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = "02:00"
      point_in_time_recovery_enabled = var.backup_enabled
    }

    maintenance_window {
      day          = 2
      hour         = 3
      update_track = "stable"
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_sql_database" "app_db" {
  name     = "tailtales"
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

resource "google_sql_user" "app_user" {
  name     = "tailtales_user"
  instance = google_sql_database_instance.main.name
  password = var.db_password
  project  = var.project_id
}