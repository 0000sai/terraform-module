resource "aws_eip" "eip-01" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-01" {
  subnet_id     = aws_subnet.subnet01.id
  allocation_id = aws_eip.eip-01.id

  tags = {
    Name = "Terra-Nat"
  }
}
