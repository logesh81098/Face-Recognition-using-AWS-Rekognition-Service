###################################################################################################################################################################
#                                                                Security Group  
###################################################################################################################################################################

#Creating Security Group for Face Rekognition application server

resource "aws_security_group" "application-server-sg" {
  name = "Face-Rekognition-Application-Server-SG"
  description = "Security group for face rekognition application server"
  vpc_id = var.vpc-id

  ingress {
    from_port = var.SSH-Port
    to_port = var.SSH-Port
    protocol = "tcp"
    cidr_blocks = [var.anywhere-ip]
    description = "Ingress rule to allow SSH connection from anywhere"
  }

  ingress {
    from_port = var.HTTP-Port
    to_port = var.HTTP-Port
    protocol = "tcp"
    cidr_blocks = [var.anywhere-ip]
    description = "Ingress rule to allow HTTP connection from anywhere"
  }

  ingress {
    from_port = var.HTTPS-Port
    to_port = var.HTTPS-Port
    protocol = "tcp"
    cidr_blocks = [var.anywhere-ip]
    description = "Ingress rule to allow HTTP connection from anywhere"
  }

  ingress {
    from_port = var.Application-Port
    to_port = var.Application-Port
    protocol = "tcp"
    cidr_blocks = [var.anywhere-ip]
    description = "Ingress rule to allow application connection from anywhere"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.anywhere-ip]
  }

  tags = {
    Name = "Face-Rekognition-Application-Server-SG"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}