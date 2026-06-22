output "db_private_ip"    { value = google_sql_database_instance.main.private_ip_address }
output "connection_name"  { value = google_sql_database_instance.main.connection_name }
output "instance_name"    { value = google_sql_database_instance.main.name }