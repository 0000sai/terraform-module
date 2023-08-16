
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
