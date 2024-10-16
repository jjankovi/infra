variable "enviroment" {
  type        = string
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
  default = "db.t3.micro"
  description = "Class of RDS instance"
}

variable "db_parameter_group" {
  type        = string
  default = "postgres16"
  description = "The DB parameter group family name. The value depends on DB engine used. See [DBParameterGroupFamily](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBParameterGroup.html#API_CreateDBParameterGroup_RequestParameters) for instructions on how to retrieve applicable value."
}


variable "subnet_ids" {
  description = "List of subnet IDs for the DB. DB instance will be created in the VPC associated with the DB subnet group provisioned using the subnet IDs. Specify one of `subnet_ids`, `db_subnet_group_name` or `availability_zone`"
  default     = []
  type        = list(string)
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Allow automated minor version upgrade (e.g. from Postgres 9.5.3 to Postgres 9.5.4)"
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = false
  description = "Allow major version upgrade"
}

variable "backup_retention_period" {
  type        = number
  default     = 0
  description = "Backup retention period in days. Must be > 0 to enable backups"
}

variable "backup_window" {
  type        = string
  default     = "22:00-03:00"
  description = "When AWS can perform DB snapshots, can't overlap with maintenance window"
}

variable "db_parameter" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "A list of DB parameters to apply. Note that parameters may differ from a DB family to another"
}

variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "The ARN of the existing KMS key to encrypt storage"
}

variable "parameter_group_name" {
  type        = string
  default     = "default.postgres16"
  description = "Name of the DB parameter group to associate"
}

variable "performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether Performance Insights are enabled."
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = []
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
}