data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_instance" "ecs_instance" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ecs_instance.id]
  subnet_id = aws_subnet.public_a.id
  associate_public_ip_address = true

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-instance"
    Env = terraform.workspace
    Project = local.app_name
  }
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
    cidr_blocks = ["52.199.220.222/32"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
