# ------------------------
# internet gatewayの設定
# ------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_batch.id
  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_route" "public_route_table_igw_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# ------------------------
# route tableの設定
# ------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_batch.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}


# ------------------------
# vpc(batch)の設定
# ------------------------
resource "aws_vpc" "vpc_batch" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name        = "${var.project}-${var.environment}-vpc-batch"
    Project     = var.project
    Environment = var.environment
  }
}

# ------------------------
# subnets(batch)の設定
# ------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc_batch.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.project}-${var.environment}-public-subnet-1a"
    Project     = var.project
    Environment = var.environment
    Type        = "public"
  }
}
