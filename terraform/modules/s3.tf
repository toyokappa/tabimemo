resource "aws_s3_bucket" "assets" {
  bucket = "${local.app_name}-${terraform.workspace}-assets"
  region = "ap-northeast-1"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-assets-bucket"
    Env = terraform.workspace
    Project = local.app_name
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.assets.id}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${local.app_name}-${terraform.workspace}-assets/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "resources" {
  bucket = "${local.app_name}-${terraform.workspace}-resources"
  region = "ap-northeast-1"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-resources-bucket"
    Env = terraform.workspace
    Project = local.app_name
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.resources.id}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${local.app_name}-${terraform.workspace}-resources/*"
    }
  ]
}
EOF
}
