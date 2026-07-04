output "vpc_id"        { value = google_compute_network.vpc.id }
output "vpc_name"      { value = google_compute_network.vpc.name }
output "sql_connection"{ value = google_service_networking_connection.sql_connection.id }
output "subnet_name"  { value = google_compute_subnetwork.app.name }
