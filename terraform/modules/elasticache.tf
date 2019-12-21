resource "aws_elasticache_cluster" "redis" {
  cluster_id = "${local.app_name}-${terraform.workspace}-redis"
  engine = "redis"
  engine_version = "5.0.3"
  node_type = "cache.t2.micro"
  num_cache_nodes = 1
  parameter_group_name = "default.redis5.0"
  subnet_group_name = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.redis.id]
}

resource "aws_elasticache_subnet_group" "redis" {
  name = "${local.app_name}-${terraform.workspace}-redis-subnet-group"
  subnet_ids = [aws_subnet.private_a.id]
}

resource "aws_security_group" "redis" {
  name = "${local.app_name}-${terraform.workspace}-redis-sg"
  description = "Redis security group for ${local.app_name} ${terraform.workspace}"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_groups = [aws_security_group.ecs_instance.id]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
