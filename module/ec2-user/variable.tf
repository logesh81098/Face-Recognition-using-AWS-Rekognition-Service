variable "instance-type" {
  default = "t3.medium"
}

variable "ami-id" {
  default = "ami-0953476d60561c955"
}

variable "public-subnet" {
  default = {}
}

variable "security-group" {
  default = {}
}

variable "keypair" {
  default = {}
}

variable "iam-instance-profile" {
  default = {}
}

variable "root-volume-size" {
  default = "12"
}

variable "root-volume-type" {
  default = "gp3"
}