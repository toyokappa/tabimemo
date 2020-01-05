resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${local.app_name}-${terraform.workspace}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name
}

resource "aws_iam_role" "ecs_instance" {
  name = "${local.app_name}-${terraform.workspace}-esc-instance-assume-role"
  assume_role_policy = file("policies/ec2_assume_role_policy.json")
}

resource "aws_iam_role_policy" "ecs_instance" {
  name = "${local.app_name}-${terraform.workspace}-ecs-instance-role-policy"
  role = aws_iam_role.ecs_instance.id
  policy = file("policies/ec2_ecs_control_policy.json")
}
