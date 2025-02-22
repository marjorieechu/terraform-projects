resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group"
  description = "DB subnet group for RDS MariaDB instance"
  subnet_ids  = ["subnet-096d45c28d9fb4c14", "subnet-05f285a35173783b0", "subnet-0cf0e3c5a513134bd"]
  tags = {
    Name = "MyDBSubnetGroup"
  }
}

resource "aws_db_parameter_group" "custom_mariadb_parameter_group" {
  name        = "custom-mariadb-11-4"
  family      = "mariadb11.4"
  description = "Custom parameter group for MariaDB 11.4"
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS MariaDB instance"
  vpc_id      = "vpc-068852590ea4b093b"

  ingress {
    description = "Allow MariaDB access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_db_instance" "connect_backend" {
  identifier                 = "connect-backend"
  engine                     = "mariadb"
  engine_version             = "11.4.4"
  instance_class             = "db.t4g.micro"
  allocated_storage          = 20
  storage_type               = "gp2"
  multi_az                   = false
  publicly_accessible        = true
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  db_name                    = "initial_db_name"
  username                   = "rds_admin_user"
  password                   = "secure_password"
  parameter_group_name       = aws_db_parameter_group.custom_mariadb_parameter_group.name
  backup_retention_period    = 7
  backup_window              = "10:30-11:00"
  maintenance_window         = "Tue:04:49-Tue:05:19"
  auto_minor_version_upgrade = true
  deletion_protection        = false
  skip_final_snapshot        = true
  storage_encrypted          = true
}