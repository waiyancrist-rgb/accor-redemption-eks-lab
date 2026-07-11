output "db_endpoint" {
  description = "The connection endpoint for the RDS Postgres instance (host:port)"
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "The FQDN of the RDS Postgres instance"
  value       = aws_db_instance.this.address
}

output "db_name" {
  description = "The name of the database"
  value       = aws_db_instance.this.db_name
}

output "db_username" {
  description = "The master username"
  value       = aws_db_instance.this.username
}

output "db_secret_arn" {
  description = "The ARN of the AWS Secrets Manager secret containing DB credentials"
  value       = aws_secretsmanager_secret.db_secret.arn
}