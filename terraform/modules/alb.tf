resource "aws_lb" "alb" {
  name = "${local.app_name}-${terraform.workspace}-alb"
  internal = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]
  subnets = [aws_subnet.public_a.id]

  enable_deletion_protection = true

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-alb"
    Env = terraform.workspace
    Project = local.app_name
  }
}

resource "aws_security_group" "alb" {
  name = "${local.app_name}-${terraform.workspace}-alb-sg"
  description = "ALB security group for ${local.app_name} ${terraform.workspace}"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 443
    to_port = 443
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

resource "aws_lb_target_group" "alb" {
  name = "${local.app_name}-${terraform.workspace}-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = ""

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}
