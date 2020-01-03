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

resource "aws_subnet" "public_c" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-public-c"
    Env = terraform.workspace
    Project = local.app_name
  }
}

resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-private-a"
    Env = terraform.workspace
    Project = local.app_name
  }
}

resource "aws_subnet" "private_c" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "${local.app_name}-${terraform.workspace}-private-c"
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

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${local.app_name}-${terraform.workspace}-rt-pub"
    Env = terraform.workspace
    Project = local.app_name
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
  policy = templatefile("policies/s3_vpc_endpoint_policy.tmpl", { app_name = local.app_name, env = terraform.workspace })
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id = aws_route_table.public.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
