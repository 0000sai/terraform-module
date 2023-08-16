
resource "aws_subnet" "subnet01" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_1

  tags = {
    Name = var.pub_subnet1_name
  }
}

resource "aws_subnet" "subnet02" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_2

  tags = {
    Name = var.pub_subnet2_name
  }
}
