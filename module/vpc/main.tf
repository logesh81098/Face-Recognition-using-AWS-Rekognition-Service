###################################################################################################################################################################
#                                                                VPC 
###################################################################################################################################################################

#Deploying VPC to launch Jenkins Server

resource "aws_vpc" "face-rekognition-vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Face-Rekognition-VPC"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

###################################################################################################################################################################
#                                                                Subnets
###################################################################################################################################################################

#Deploying public subnet

resource "aws_subnet" "face-rekognition-public-subnet-1" {
  vpc_id = aws_vpc.face-rekognition-vpc.id
  cidr_block = var.public-subnet-1-cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "Face-Rekognition-Public-Subnet-1"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/Face-Rekognition-Cluster" = "shared"
  }
}


resource "aws_subnet" "face-rekognition-public-subnet-2" {
  vpc_id = aws_vpc.face-rekognition-vpc.id
  cidr_block = var.public-subnet-2-cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "Face-Rekognition-Public-Subnet-2"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/Face-Rekognition-Cluster" = "shared"
  }
}

#Deploying private subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.face-rekognition-vpc.id
  cidr_block = var.private-subnet-1-cidr
  availability_zone = var.az1
  map_public_ip_on_launch = false
  tags = {
    Name = "Face-Rekognition-Private-Subnet-1"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/Face-Rekognition-Cluster" = "shared"
  }
}


resource "aws_subnet" "private-subnet-2" {
  vpc_id = aws_vpc.face-rekognition-vpc.id
  cidr_block = var.private-subnet-2-cidr
  availability_zone = var.az2
  map_public_ip_on_launch = false
  tags = {
    Name = "Face-Rekognition-Private-Subnet-2"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/Face-Rekognition-Cluster" = "shared"
  }
}

###################################################################################################################################################################
#                                                                Gateway
###################################################################################################################################################################

#Internet Gateway

resource "aws_internet_gateway" "face-rekognition-igw" {
  vpc_id = aws_vpc.face-rekognition-vpc.id
  tags = {
    Name = "Face-Rekognition-IGW"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#NAT Gateway

resource "aws_eip" "elastic-ip" {
  tags = {
    Name    = "Face-Rekognition-NAT-EIP"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.elastic-ip.allocation_id
  subnet_id = aws_subnet.face-rekognition-public-subnet-1.id
  tags = {
    Name    = "Face-Rekognition-NAT-Gateway"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


###################################################################################################################################################################
#                                                                Route Table
###################################################################################################################################################################

#Route Table

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.face-rekognition-vpc.id
  route {
    gateway_id = aws_internet_gateway.face-rekognition-igw.id
    cidr_block = var.igw-route
  }
  tags = {
    Name = "Face-Rekognition-Public-RouteTable"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.face-rekognition-vpc.id
  route {
    gateway_id = aws_nat_gateway.nat-gateway.id
    cidr_block = var.igw-route
  }
  tags = {
    Name = "Face-Rekognition-Private-RouteTable"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


###################################################################################################################################################################
#                                                                Route Table Association
###################################################################################################################################################################

resource "aws_route_table_association" "public-subnet-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.face-rekognition-public-subnet-1.id
}

resource "aws_route_table_association" "public-subnet-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.face-rekognition-public-subnet-2.id
}


resource "aws_route_table_association" "private-subnet-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-subnet-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.private-subnet-2.id
}