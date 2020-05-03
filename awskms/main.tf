provider "aws" {
  region = var.region
  profile = var.profile
  version = "~> 2.15.0"
}

resource "aws_kms_key" "db_key" {
    description = "key to encrypt rds password"
  tags = {
    Name = "my-rds-kms-key"
  }
}

resource "aws_kms_alias" "rds-kms-alias" {
  target_key_id = aws_kms_key.db_key.id
  name = "alias/rds-kms-key"
}