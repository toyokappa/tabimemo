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

resource "aws_iam_role_policy" "ssm_get_policy" {
  name = "${local.app_name}-${terraform.workspace}-ssm-get-policy"
  role = aws_iam_role.ecs_instance.name
  policy = templatefile("policies/ssm_get_policy.tmpl", { aws_account_id = local.aws_account_id })
}

resource "aws_iam_role" "ecs_task" {
  name = "${local.app_name}-${terraform.workspace}-ecs-task-role"
  assume_role_policy = file("policies/ecs_assume_role_policy.json")
}

resource "aws_iam_role_policy" "ecs_task" {
  name = "${local.app_name}-${terraform.workspace}-ecs-task-policy"
  role = aws_iam_role.ecs_task.name
  policy = file("policies/ecs_task_policy.json")
}
