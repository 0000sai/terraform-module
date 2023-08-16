
resource "aws_route_table" "pub-route" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.pub_route_table_name
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet01.id
  route_table_id = aws_route_table.pub-route.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet02.id
  route_table_id = aws_route_table.pub-route.id
}

resource "aws_route" "route-pub01" {
  route_table_id         = aws_route_table.pub-route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}
