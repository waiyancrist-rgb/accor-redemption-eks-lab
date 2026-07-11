# 1. Generate a secure random password for the database
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# 2. Create a Security Group that only allows traffic from your EKS nodes
resource "aws_security_group" "db_sg" {
  name        = "${var.name}-db-sg"
  description = "Allow EKS nodes to access PostgreSQL"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description     = "PostgreSQL from EKS Worker Nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.eks.outputs.node_security_group_id]
  }

  tags = merge(var.tags, { Name = "${var.name}-db-sg" })
}

# 3. Define the Subnet Group (placing the DB in your private database subnets)
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = data.terraform_remote_state.network.outputs.database_subnet_ids
  tags       = var.tags
}

# 4. Create the actual RDS Database instance
resource "aws_db_instance" "this" {
  identifier             = "${var.name}-postgres"
  engine                 = "postgres"
  engine_version         = "15.18"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  
  db_name                = "redemptiondb"
  username               = "dbadmin"
  password               = random_password.db_password.result
  
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  # Lab settings to prevent deletion protection headaches
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = var.tags
}

# 5. Store the credentials securely in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "${var.name}-db-credentials"
  recovery_window_in_days = 0 # Allows instant recreation during testing / terraform destroy cycles
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "db_secret_val" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    host     = aws_db_instance.this.address  # FQDN of the DB without port
    port     = 5432
    dbname   = aws_db_instance.this.db_name
    username = aws_db_instance.this.username
    password = random_password.db_password.result
  })
}