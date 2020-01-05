data "aws_ssm_parameter" "amazon_linux2_for_ecs" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_instance" "ecs_instance" {
  ami = data.aws_ssm_parameter.amazon_linux2_for_ecs.value
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ecs_instance.id]
  subnet_id = aws_subnet.public_a.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ecs_instance.name
  key_name = aws_key_pair.bastion.key_name

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-instance"
    Env = terraform.workspace
    Project = local.app_name
  }

  user_data = templatefile("bin/attach_ecs.tmpl", { app_name = local.app_name, env = terraform.workspace })
}

resource "aws_security_group" "ecs_instance" {
  name = "${local.app_name}-${terraform.workspace}-ecs-instance-sg"
  description = "ECS instance security group for ${local.app_name} ${terraform.workspace}"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "bastion" {
  key_name = "tabimemo-bastion"
  public_key = file("~/.ssh/tabimemo-bastion.pub")
}
