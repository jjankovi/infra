resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  identifier           = "${var.project_name}-${var.enviroment}-db"
  db_name              = "${var.project_name}"
  username             = var.admin_username
  password             = var.admin_password
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true

  db_subnet_group_name = aws_db_subnet_group.subnet_group.name

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible = false
  multi_az            = var.high_availability
  storage_type        = "gp2"
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.project_name}-${var.enviroment}-db-subnet-group"
  subnet_ids = local.private_subnet_ids
}