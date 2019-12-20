resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.app_name}-${terraform.workspace}-vpc"
    Env = terraform.workspace
    Project = local.app_name
  }
}

resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-public-a"
    Env = terraform.workspace
    Project = local.app_name
  }
}

resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-private-a"
    Env = terraform.workspace
    Project = local.app_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-igw"
    Env = terraform.workspace
    Project = local.app_name
  }
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${local.app_name}-${terraform.workspace}-rt-pub-a"
    Env = terraform.workspace
    Project = local.app_name
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

resource "aws_route" "public_a" {
  route_table_id = aws_route_table.public_a.id
  gateway_id = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazon.ap-northeast-1.s3"
  policy = templatefile("policies/s3_vpc_endpoint_policy.tmpl", { app_name = local.app_name, env = terraform.workspace })
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id = aws_route_table.public_a.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
