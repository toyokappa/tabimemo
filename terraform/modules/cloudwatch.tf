resource "aws_cloudwatch_log_group" "rails_log" {
  name              = "${local.app_name}-${terraform.workspace}-rails-lg"
  retention_in_days = "365"
}

resource "aws_cloudwatch_log_group" "sidekiq_log" {
  name              = "${local.app_name}-${terraform.workspace}-sidekiq-lg"
  retention_in_days = "365"
}

resource "aws_cloudwatch_log_group" "nginx_log" {
  name              = "${local.app_name}-${terraform.workspace}-nginx-lg"
  retention_in_days = "365"
}
