provider "aws" {
  region = "ap-northeast-1"
  profile = "wakatter"
}

module "app" {
  source = "./modules"
}
