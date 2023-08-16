
resource "aws_route_table" "priv-route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-01.id
  }

  tags = {
    Name = var.priv_route_table_name
  }
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.subnet03.id
  route_table_id = aws_route_table.priv-route.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.subnet04.id
  route_table_id = aws_route_table.priv-route.id
}
