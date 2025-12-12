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
  value       = "mysql://${scaleway_rdb_user.app_user.name}:${var.mysql_app_password}@${scaleway_rdb_instance.mysql.endpoint_ip}:${scaleway_rdb_instance.mysql.endpoint_port}/${scaleway_rdb_database.main.name}"
  sensitive   = true
}

# Gitea Container Outputs
output "gitea_url" {
  description = "Gitea public URL"
  value       = "https://${scaleway_container.gitea.domain_name}"
}

output "gitea_domain" {
  description = "Gitea container domain name"
  value       = scaleway_container.gitea.domain_name
}

output "gitea_container_id" {
  description = "Gitea container ID"
  value       = scaleway_container.gitea.id
}

output "gitea_namespace_id" {
  description = "Gitea container namespace ID"
  value       = scaleway_container_namespace.gitea.id
}