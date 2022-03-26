# resource "aws_instance" "demo" {
#   ami           = "ami-073998ba87e205747"
#   instance_type = "t2.micro"

#   network_interface {
#     network_interface_id = aws_network_interface.demo-ENI.id
#     device_index         = 0
#   }
#   key_name = aws_key_pair.deployer.id
#   tags = {
#     Name = "HelloWorld"
#   }
# }

# resource "aws_key_pair" "deployer" {
#   key_name   = "id_ed25519.pub"
#   public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAzSVTR1P7Iu9OjsfGAId52pefxUku6t9vPNhv1i9P0 ws0599@administrator-OptiPlex-3080"
# }

# resource "aws_security_group" "allow_tls" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "allow_tls"
#   }
# }

# resource "aws_security_group_rule" "example" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["13.213.52.236/32"]
#   security_group_id = aws_security_group.allow_tls.id
# }

# resource "aws_network_interface" "demo-ENI" {
#   subnet_id       = aws_subnet.subnet1.id
#   private_ips     = ["172.16.0.10"]
#   security_groups = [aws_security_group.allow_tls.id]
#   tags = {
#     Name = "demo-ENI"
#   }
# }


resource "aws_instance" "web" {

  ami           = "ami-0d058fe428540cd89"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id

  key_name               = aws_key_pair.dev.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "web-01"
  }
}

# tạo ssh keypair

resource "aws_key_pair" "dev" {
  key_name   = ""
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfPhxK6qT8JNWwMkYz4lKnK6/t3SvWt8Q/yy4GmE7bOxvEa0BodMLvyyxcx8PtjEev6bx8VZ7mJqE0PBrR+QhfqCw5cByZWoVa0Q567Wh3v8UkJgxHd/x3YBX/397RA7jGyYq+7dbF4ECESaXiX5AR0BrrYe0kVSym5tEud/v9PAAe24I9wZA7epaaVKgz/1w6IlSyh/AK2YU8adol5tTLcHLT/az2XyWzZ3xA3KPMAlsgZJI3ctBFdEGQT/ozOeakQIa8a6okWyES+uRtb9kezh+U1ID3BmnJEKMuM0pZtLJ5mt6zQhCXX3QcpmUSIRrDn4zB773a4hMgvOcDoO+Z2orSJXSkPvCF+9Jb11XizhftmojQHn274J/+n2gRbMmNVgeatJbs7WAFmWvMlpUFWkgvkP0Gl3jRd4tKz+WpIYhiOFuU/lUaXLkupeh6nY3/Kt17Q7hQvYJIzD+Cn5IMAyaV3U7aq4d4sAC6hfTLSMsMo54Sd4X0vc14RC5AL2c= admin123@Admin"
}

# tạo security group allow ssh

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from specify IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.136.123.97/32", "14.248.82.236/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# in ra public ip của ec2 instance
# output "ec2_instance_public_ips" {
#   value = aws_instance.web.*.public_ip
# }