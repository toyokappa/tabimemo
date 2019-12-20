resource "aws_ecr_repository" "rails" {
  name = "${local.app_name}-rails"
}

resource "aws_ecr_lifecycle_policy" "rails" {
  repository = aws_ecr_repository.rails.name
  policy = file("policies/ecr_lifecycle_policy.json")
}
