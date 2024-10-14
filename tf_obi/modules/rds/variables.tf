variable "enviroment" {
  description = "Environment"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "The IDs of the security groups from which to allow `ingress` traffic to the DB instance"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "The whitelisted CIDRs which to allow `ingress` traffic to the DB instance"
}

variable "database_name" {
  type        = string
  default     = null
  description = "The name of the database to create when the DB instance is created"
}

variable "database_user" {
  type        = string
  default     = null
  description = "Username for the primary DB user."
}

variable "database_password" {
  type        = string
  default     = null
  description = "Password for the primary DB user."
}

variable "database_port" {
  type        = number
  default = 5432
  description = "Database port (_e.g._ `3306` for `MySQL`). Used in the DB Security Group to allow access to the DB instance from the provided `security_group_ids`"
}

variable "schemas" {
  type = list(object({
    schema_name    = string
    user_name      = string
    user_password  = string
  }))
  default     = []
  description = "A list of DB schemas with owner user"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Set to true if multi AZ deployment must be supported"
}

variable "storage_type" {
  type        = string
  default     = "gp2"
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
}

variable "storage_encrypted" {
  type        = bool
  default     = true
  description = "(Optional) Specifies whether the DB instance is encrypted. The default is false if not specified"
}

variable "iops" {
  type        = number
  default     = null
  description = "The amount of provisioned IOPS, only valid for certain values of storage_type."
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "The allocated storage in GBs. Required unless a `snapshot_identifier` or `replicate_source_db` is provided."
}

variable "max_allocated_storage" {
  type        = number
  description = "The upper limit to which RDS can automatically scale the storage in GBs"
  default     = 0
}

variable "engine" {
  type        = string
  default     = "postgres"
  description = "Database engine type (mysql, postgres, oracle-*, sqlserver-*)"
}

variable "engine_version" {
  type        = string
  default = "16.3"
  description = "Database engine version, depends on engine type."
}

variable "instance_class" {
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