
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
  vpc_id   = aws_vpc.vpc.id

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
