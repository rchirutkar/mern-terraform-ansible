resource "aws_security_group" "web" {

  name = "${var.project_name}-${var.environment}-web-sg"

  description = "Web Server Security Group"

  vpc_id = var.vpc_id

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [var.allowed_ssh_cidr]

  }

  ingress {

    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

#  ingress {
#
#    description = "React Frontend"
#
#    from_port = 3000
#    to_port   = 3000
#    protocol  = "tcp"
#
#    cidr_blocks = ["0.0.0.0/0"]
#
#  }
#
#  ingress {
#
#    description = "Backend API"
#
#    from_port = 5000
#    to_port   = 5000
#    protocol  = "tcp"
#
#    cidr_blocks = ["0.0.0.0/0"]
#
# }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "${var.project_name}-${var.environment}-web-sg"

  }

}

resource "aws_security_group" "mongodb" {

  name = "${var.project_name}-${var.environment}-mongodb-sg"

  description = "MongoDB Private Security Group"

  vpc_id = var.vpc_id

  ingress {

    description = "MongoDB from Web EC2"

    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"

    security_groups = [aws_security_group.web.id]

  }

# allowed SSH from your laptop IP, not from the Web EC2 (bastion).
#  ingress {
#
#    description = "SSH from Laptop"
#
#    from_port = 22
#    to_port   = 22
#    protocol  = "tcp"
#
#    cidr_blocks = [var.allowed_ssh_cidr]
#
#  }

# allowed SSH from the Web EC2 (bastion), not from your laptop IP.
  ingress {
    description = "SSH from Web EC2 (Bastion)"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [aws_security_group.web.id]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "${var.project_name}-${var.environment}-mongodb-sg"

  }

}