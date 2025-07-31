variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "public-subnet-1-cidr" {
  default = "10.0.1.0/24"
}

variable "az1" {
  default = "us-east-1a"
}


variable "public-subnet-2-cidr" {
  default = "10.0.2.0/24"
}

variable "az2" {
  default = "us-east-1b"
}

variable "igw-route" {
  default = "0.0.0.0/0"
}

variable "private-subnet-1-cidr" {
  default = "10.0.3.0/24"
}

variable "private-subnet-2-cidr" {
  default = "10.0.4.0/24"
}