# Scaleway Authentication Variables
variable "access_key" {
  description = "Scaleway access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Scaleway secret key"
  type        = string
  sensitive   = true
}

variable "organization_id" {
  description = "Scaleway organization ID"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "Scaleway project ID"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "The Scaleway zone where resources will be created"
  type        = string
  default     = "nl-ams-1"
}

variable "region" {
  description = "The Scaleway region where resources will be created"
  type        = string
  default     = "nl-ams"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "selfhosted"
}

variable "mysql_node_type" {
  description = "The node type for the MySQL database"
  type        = string
  default     = "DB-DEV-S"
  validation {
    condition = contains([
      "DB-DEV-S",
      "DB-GP-XS", 
      "DB-GP-S",
      "DB-GP-M",
      "DB-GP-L",
      "DB-GP-XL"
    ], var.mysql_node_type)
    error_message = "MySQL node type must be a valid Scaleway RDB instance type."
  }
}

variable "mysql_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0.35"
}

variable "mysql_username" {
  description = "MySQL admin username"
  type        = string
  default     = "admin"
}

variable "mysql_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
}

variable "mysql_database_name" {
  description = "Initial database name to create"
  type        = string
  default     = "selfhosted"
}

variable "backup_schedule_hour" {
  description = "Hour for daily backups (0-23)"
  type        = number
  default     = 3
  validation {
    condition     = var.backup_schedule_hour >= 0 && var.backup_schedule_hour <= 23
    error_message = "Backup schedule hour must be between 0 and 23."
  }
}

variable "backup_schedule_minute" {
  description = "Minute for daily backups (0-59)"
  type        = number
  default     = 0
  validation {
    condition     = var.backup_schedule_minute >= 0 && var.backup_schedule_minute <= 59
    error_message = "Backup schedule minute must be between 0 and 59."
  }
}