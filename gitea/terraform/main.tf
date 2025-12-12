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
  name        = "${var.project_name}_user"
  password    = var.mysql_password # In production, use a separate password
  is_admin    = false
}