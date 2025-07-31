variable "cluster-role-arn" {
  default = {}
}

variable "cluster-sg" {
  default = {}
}

variable "application-sg" {
  default = {}
}

variable "private-subnet-1" {
  default = {}
}

variable "private-subnet-2" {
  default = {}
}

variable "nodegroup-role-arn" {
  default = {}
}

variable "instance-type" {
  default = "t3.medium"
}

variable "launch-template-id" {
  default = {}
}