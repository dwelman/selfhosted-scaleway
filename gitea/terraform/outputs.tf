output "mysql_endpoint" {
  description = "MySQL database endpoint"
  value       = scaleway_rdb_instance.mysql.endpoint_ip
}

output "mysql_port" {
  description = "MySQL database port"
  value       = scaleway_rdb_instance.mysql.endpoint_port
}

output "mysql_database_name" {
  description = "MySQL database name"
  value       = scaleway_rdb_database.main.name
}

output "mysql_admin_username" {
  description = "MySQL admin username"
  value       = scaleway_rdb_instance.mysql.user_name
}

output "mysql_app_username" {
  description = "MySQL application username"
  value       = scaleway_rdb_user.app_user.name
}

output "mysql_connection_string" {
  description = "MySQL connection string for applications"
  value       = "mysql://${scaleway_rdb_user.app_user.name}:${var.mysql_password}@${scaleway_rdb_instance.mysql.endpoint_ip}:${scaleway_rdb_instance.mysql.endpoint_port}/${scaleway_rdb_database.main.name}"
  sensitive   = true
}