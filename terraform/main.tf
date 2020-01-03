provider "aws" {
  region  = "ap-northeast-1"
  profile = "tabimemo"
}

module "app" {
  source = "./modules"
}
