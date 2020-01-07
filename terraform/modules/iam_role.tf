# EC2インスタンス用ロール
resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${local.app_name}-${terraform.workspace}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name
}

resource "aws_iam_role" "ecs_instance" {
  name = "${local.app_name}-${terraform.workspace}-ecs-instance-role"
  assume_role_policy = file("policies/ec2_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role = aws_iam_role.ecs_instance.id
}

# ECS Execution用ロール
resource "aws_iam_role" "ecs_execution" {
  name = "${local.app_name}-${terraform.workspace}-ecs-execution-role"
  assume_role_policy = file("policies/ecs_tasks_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
  role       = aws_iam_role.ecs_execution.id
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_execution.id
}

resource "aws_iam_role_policy" "ssm_get_policy" {
  name = "${local.app_name}-${terraform.workspace}-ssm-get-policy"
  role = aws_iam_role.ecs_execution.name
  policy = templatefile("policies/ssm_get_policy.tmpl", { aws_account_id = local.aws_account_id })
}

# ECS Task用ロール

resource "aws_iam_role" "ecs_task_role" {
  name = "${local.app_name}-${terraform.workspace}-ecs-task-role"
  assume_role_policy = file("policies/ecs_tasks_assume_role_policy.json")
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "${local.app_name}-${terraform.workspace}-ecs-task-policy"
  role = aws_iam_role.ecs_task_role.name
  policy = file("policies/ecs_task_policy.json")
}
