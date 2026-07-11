resource "aws_ecr_repository" "redemption" {
  name                 = "redemption-api"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

resource "aws_kms_key" "platform" {
  description             = "KMS key for Redemption platform"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "platform" {
  name          = "alias/redemption-platform"
  target_key_id = aws_kms_key.platform.key_id
}