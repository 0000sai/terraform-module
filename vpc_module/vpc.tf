
# vpc

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.vpc_instance_tenancy

  tags = {
    Name = var.vpc_name
  }
}


# public subnets

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


# private subnet

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


# internet gateway

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Terra-IG"
  }
}


# nat gateway

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


# public route table

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


# private route table

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


# public instance

resource "aws_instance" "ec2-01" {
  ami                    = var.pub_instance_ami
  instance_type          = var.pub_instance_type
  key_name               = var.pub_instance_key_name
  subnet_id              = aws_subnet.subnet01.id
  vpc_security_group_ids = [aws_security_group.pub1-sg.id]

  tags = {
    Name = var.pub_instance_name
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y apache2
	      sudo systemctl status apache2	
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo chown -R $USER:$USER /var/www/html		
              echo "welcome to aditya's web-server!" > /var/www/html/index.html
              EOF
}


# security group

resource "aws_security_group" "pub1-sg" {
  name        = "pub1-sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# load balancer

resource "aws_lb" "my_lb" {
  name               = "terra-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet01.id, aws_subnet.subnet02.id] 

  enable_deletion_protection = false

  enable_http2 = true
  enable_cross_zone_load_balancing = true

  security_groups = [aws_security_group.lb-sg.id] 
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200,302"
  }
}

resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    type             = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "Hello from the load balancer!"
    }
  }
}

