terraform {
  required_version = ">= 1.0"
  
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
}

# Configure the Scaleway Provider
provider "scaleway" {
  access_key      = var.access_key
  secret_key      = var.secret_key
  organization_id = var.organization_id
  project_id      = var.project_id
  zone            = var.zone
  region          = var.region
}

# MySQL RDB Instance
resource "scaleway_rdb_instance" "mysql" {
  name           = "${var.project_name}-mysql"
  node_type      = var.mysql_node_type
  engine         = "MySQL-8"
  is_ha_cluster  = false
  disable_backup = false
  project_id     = var.project_id
  
  user_name     = var.mysql_username
  password      = var.mysql_password
  
  backup_schedule_frequency = 24 # Daily backups
  backup_schedule_retention = 7  # Keep backups for 7 days
  backup_same_region        = true
  
  volume_type       = "sbs_5k"
  volume_size_in_gb = 5
  
  tags = [
    "environment:${var.project_name}",
    "service:mysql"
  ]
}

# Create initial database
resource "scaleway_rdb_database" "main" {
  instance_id = scaleway_rdb_instance.mysql.id
  name        = var.mysql_database_name
}

# Create application user (separate from admin)
resource "scaleway_rdb_user" "app_user" {
  instance_id = scaleway_rdb_instance.mysql.id
  name        = var.mysql_app_username
  password    = var.mysql_app_password
  is_admin    = false
}

# Grant privileges to application user for the database
resource "scaleway_rdb_privilege" "app_user_privileges" {
  instance_id   = scaleway_rdb_instance.mysql.id
  user_name     = scaleway_rdb_user.app_user.name
  database_name = scaleway_rdb_database.main.name
  permission    = "all"
}

# Container Namespace
resource "scaleway_container_namespace" "gitea" {
  name        = "${var.project_name}-gitea"
  description = "Namespace for Gitea containers"
  project_id  = var.project_id
  
  tags = [
    "environment:${var.project_name}",
    "service:gitea"
  ]
}

# Gitea Container
resource "scaleway_container" "gitea" {
  name           = "${var.project_name}-gitea"
  namespace_id   = scaleway_container_namespace.gitea.id
  registry_image = "docker.gitea.com/gitea:1.25.2-rootless"
  port           = 3000
  cpu_limit      = 560
  memory_limit   = 1024
  min_scale      = 1
  max_scale      = 3
  timeout        = 300
  privacy        = "public"
  protocol       = "http1"
  
  # Deploy the container with initial configuration
  deploy         = true
  
  environment_variables = {
    USER_UID                    = "1000"
    USER_GID                    = "1000"
    GITEA__database__DB_TYPE    = "mysql"
    GITEA__database__HOST       = "${scaleway_rdb_instance.mysql.endpoint_ip}:${scaleway_rdb_instance.mysql.endpoint_port}"
    GITEA__database__NAME       = scaleway_rdb_database.main.name
    GITEA__database__USER       = scaleway_rdb_user.app_user.name
    GITEA__database__PASSWD     = var.mysql_app_password
    GITEA__server__HTTP_PORT    = "3000"
    GITEA__security__SECRET_KEY = var.gitea_secret_key
  }

  depends_on = [
    scaleway_rdb_instance.mysql,
    scaleway_rdb_database.main,
    scaleway_rdb_user.app_user
  ]
}