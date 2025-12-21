resource "aws_vpc" "media" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "media-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)

  vpc_id                  = aws_vpc.media.id
  cidr_block              = each.value
  map_public_ip_on_launch = true

  tags = {
    Name = "media-public-${replace(each.value, "/", "-")}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.media.id
  tags = {
    Name = "media-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.media.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "media-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
