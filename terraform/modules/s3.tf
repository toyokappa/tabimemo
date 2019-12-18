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
}
