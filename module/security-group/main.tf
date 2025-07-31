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

  ingress {
    from_port = var.Jenkins-Port
    to_port = var.Jenkins-Port
    protocol = "tcp"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Ingress rule to access Jenkins from anywhere"
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
    "kubernetes.io/cluster/Face-Rekognition-Cluster" = "owned"
    "eks-cluster-name" = "Face-Rekognition-EKS-Cluster"
  }
}


###################################################################################################################################################################
#                                                                Security Group  
###################################################################################################################################################################

#Security Group for EKS Cluster

resource "aws_security_group" "eks-cluster-sg" {
  name = "Face-Rekognition-EKS-Cluster-SG"
  description = "Security Group for Face-Rekognition-EKS-Cluster"
  vpc_id = var.vpc-id

  ingress {
    from_port = var.API-server
    to_port = var.API-server
    protocol = "tcp"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Ingress rule for API Server"
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
    cidr_blocks = [ var.anywhere-ip ]
  }

  tags = {
    Name = "Face-Rekognition-EKS-Cluster-SG"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
    "kubernetes.io/cluster/Face-Rekognition-Cluster" = "owned"
    "eks-cluster-name" = "Face-Rekognition-EKS-Cluster"

  }
}


###################################################################################################################################################################
#                                                                Security Group  
###################################################################################################################################################################

#Security Group for EKS Nodegroup

resource "aws_security_group" "nodegroup-sg" {
  name = "Face-Rekognition-EKS-NodeGroup-SG"
  description = "Security Group for Face Rekognition EKS NodeGroup"
  vpc_id = var.vpc-id

  ingress {
    from_port = var.API-server
    to_port = var.API-server
    protocol = "tcp"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Ingress rule for API Server"
  }

  ingress {
    from_port = var.Application-Port
    to_port = var.Application-Port
    protocol = "tcp"
    cidr_blocks = [var.anywhere-ip]
    description = "Ingress rule to allow application connection from anywhere"
  }

  ingress {
    from_port = "0"
    to_port = "65535"
    protocol = "tcp"
    self = true
    description = "Allow All Traffic from self"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.eks-cluster-sg.id ]
    description = "Allow All Traffic from EKS Cluster Security Group"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ var.anywhere-ip ]
  }

  tags = {
    Name = "Face-Rekognition-EKS-NodeGroup-SG"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
    "kubernetes.io/cluster/Face-Rekognition-Cluster" = "owned"
    "eks-cluster-name" = "Face-Rekognition-EKS-Cluster"
  }
}