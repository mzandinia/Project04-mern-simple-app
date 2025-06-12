# VPC and Subnets
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = var.create_public_subnets ? length(var.public_subnet_cidrs) : 0
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-${count.index}"
    Environment = var.environment
  }
}

# Internet Gateway - create if public subnets are enabled OR if create_igw_without_public_subnets is true
resource "aws_internet_gateway" "igw" {
  count  = var.create_public_subnets || var.create_igw_without_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# NAT Gateway for private subnets - only create if public subnets are enabled
resource "aws_eip" "nat" {
  count  = var.create_public_subnets ? 1 : 0
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "${var.project_name}-nat"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route tables - public route table only if public subnets are enabled
resource "aws_route_table" "public" {
  count  = var.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

# Route table for private subnets with IGW route (only if create_igw_without_public_subnets is true)
resource "aws_route_table" "private_with_igw" {
  count  = var.create_private_subnets && var.create_igw_without_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name        = "${var.project_name}-private-with-igw-rt"
    Environment = var.environment
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count             = var.create_private_subnets ? length(var.private_subnet_cidrs) : 0
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.project_name}-private-subnet-${count.index}"
    Environment = var.environment
  }
}

# Private route table only if private subnets are enabled
resource "aws_route_table" "private" {
  count  = var.create_private_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id

  # Add IGW route if create_igw_without_public_subnets is true
  dynamic "route" {
    for_each = var.create_igw_without_public_subnets ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw[0].id
    }
  }

  # Add NAT gateway route if it's created
  dynamic "route" {
    for_each = var.create_nat_gateway && !var.create_igw_without_public_subnets ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[0].id
    }
  }

  tags = {
    Name        = "${var.project_name}-private-rt"
    Environment = var.environment
  }
}

# Route table associations - only for public subnets if enabled
resource "aws_route_table_association" "public" {
  count          = var.create_public_subnets ? length(var.public_subnet_cidrs) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Route table associations for private subnets with IGW
resource "aws_route_table_association" "private_with_igw" {
  count          = var.create_private_subnets && var.create_igw_without_public_subnets ? length(var.private_subnet_cidrs) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_with_igw[0].id
}

# Route table associations - only for private subnets if enabled and not using IGW
resource "aws_route_table_association" "private" {
  count          = var.create_private_subnets && !var.create_igw_without_public_subnets ? length(var.private_subnet_cidrs) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}

# Get available AZs
data "aws_availability_zones" "available" {}
