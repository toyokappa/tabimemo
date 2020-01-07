locals {
  app_name = "tabimemo"
  aws_account_id = "160320342740"
  domain = ["tabimemo.xyz", "www.tabimemo.xyz"]
  alb_certificate_arn = "arn:aws:acm:ap-northeast-1:160320342740:certificate/c06a0699-857f-4f18-91e6-ea4d8f99d154"
  cf_certificate_arn = "arn:aws:acm:us-east-1:160320342740:certificate/e683a2da-d344-4d60-ba3e-7b0f725e8c78"
  db_username = "tabimemo_user"
  db_password = random_id.db_password.b64
}

resource "random_id" "db_password" {
  byte_length = 8
}
