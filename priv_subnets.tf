
resource "aws_subnet" "subnet03" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.priv_subnet1_cidr
  availability_zone = var.availability_zone_3

  tags = {
    Name = var.priv_subnet1_name
  }
}

resource "aws_subnet" "subnet04" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.priv_subnet2_cidr
  availability_zone = var.availability_zone_4

  tags = {
    Name = var.priv_subnet2_name
  }
}
