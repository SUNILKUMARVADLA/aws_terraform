resource "aws_s3_bucket" "tf_bucket" {
  bucket = var.bucket_name
  acl = "public-read"
    policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
EOF
  cors_rule {
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

locals {
  s3_origin_id = var.bucket_name
}
