resource "aws_db_instance" "default" {
  identifier           = "${var.database_name}-${var.enviroment}-db"
  db_name              = var.database_name
  username             = var.database_user
  password             = var.database_password
  port = var.database_port
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted = var.storage_encrypted
  kms_key_id = var.kms_key_arn
  manage_master_user_password   = var.database_password != null ? null : false

  vpc_security_group_ids = compact(
    concat(
      [join("", aws_security_group.default[*].id)]
    )
  )

  parameter_group_name = var.parameter_group_name
  db_subnet_group_name = aws_db_subnet_group.default.name

  multi_az            = var.multi_az
  storage_type        = var.storage_type
  iops = var.iops
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  performance_insights_enabled          = var.performance_insights_enabled

  publicly_accessible = false
  skip_final_snapshot  = true

  depends_on = [
    aws_db_subnet_group.default,
    aws_security_group.default,
    aws_db_parameter_group.default
  ]
}

resource "aws_db_parameter_group" "default" {
  count = length(var.parameter_group_name) == 0 ? 1 : 0

  name_prefix = "${var.database_name}"
  family      = var.db_parameter_group

  dynamic "parameter" {
    for_each = var.db_parameter
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.database_name}-${var.enviroment}-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "default" {
  name        = "${var.database_name}-${var.enviroment}-rds-sg"
  description = "RDS base security group"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count = length(var.security_group_ids)

  description              = "Allow inbound traffic from existing Security Groups"
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  source_security_group_id = var.security_group_ids[count.index]
  security_group_id        = join("", aws_security_group.default[*].id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = var.database_port
  to_port           = var.database_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default[*].id)
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default[*].id)
}