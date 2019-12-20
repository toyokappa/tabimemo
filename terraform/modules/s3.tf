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

  policy = templatefile(
    "policies/s3_cloudfront_policy.tmpl",
    {
      origin_access_identity_id = aws_cloudfront_origin_access_identity.assets.id,
      app_name = local.app_name,
      env = terraform.workspace,
      name = "assets"
    }
  )
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

  policy = templatefile(
    "policies/s3_cloudfront_policy.tmpl",
    {
      origin_access_identity_id = aws_cloudfront_origin_access_identity.resources.id,
      app_name = local.app_name,
      env = terraform.workspace,
      name = "resources"
    }
  )
}
