resource "aws_ecr_repository" "rails" {
  name = "${local.app_name}-rails"
}

resource "aws_ecr_lifecycle_policy" "rails" {
  repository = aws_ecr_repository.rails.name
  policy = file("policies/ecr_lifecycle_policy.json")
}

resource "aws_ecr_repository" "nginx" {
  name = "${local.app_name}-nginx"
}

resource "aws_ecr_lifecycle_policy" "nginx" {
  repository = aws_ecr_repository.nginx.name
  policy = file("policies/ecr_lifecycle_policy.json")
}
