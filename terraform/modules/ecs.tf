resource "aws_ecs_cluster" "main" {
  name = "${local.app_name}-${terraform.workspace}-cluster"
}

resource "aws_ecs_service" "rails" {
  name = "${local.app_name}-${terraform.workspace}-rails"
  cluster = aws_ecs_cluster.main.id
  task_definition = "${local.app_name}-${terraform.workspace}-rails:1"
  desired_count = 0

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition
    ]
  }
}
