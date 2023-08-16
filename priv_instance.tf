
#resource "aws_instance" "ec2-02" {
#  ami                    = var.priv_instance_ami
#  instance_type          = var.priv_instance_type
#  key_name               = var.priv_instance_key_name
#  subnet_id              = aws_subnet.subnet03.id
#  vpc_security_group_ids = [aws_security_group.priv-sg.id]

#  tags = {
#    Name = var.priv_instance_name
#  }
#}
