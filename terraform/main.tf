provider "aws" {
  region  = "ap-northeast-1"
  profile = "tabimemo"
}

# resource "aws_s3_bucket" "tfstate" {
#   bucket = "tabimemo-terraform-state"
#   versioning {
#     enabled = true
#   }
# }

terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket = "tabimemo-terraform-state"
    region = "ap-northeast-1"
    key = "terraform.tfstate"
    encrypt = true
    profile = "tabimemo"
  }
}

module "app" {
  source = "./modules"
}

