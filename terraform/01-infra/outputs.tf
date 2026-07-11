output "ecr_repository_url" { value = aws_ecr_repository.redemption.repository_url }
output "kms_key_arn" { value = aws_kms_key.platform.arn }