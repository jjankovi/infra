variable "enviroment" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "high_availability" {
  description = "If RDS is in HA mode"
  type        = bool
}

variable "admin_username" {
  description = "Admin username for RDS"
  type        = string
}

variable "admin_password" {
  description = "Admin password for RDS"
  type        = string
}