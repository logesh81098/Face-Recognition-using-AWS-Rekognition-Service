variable "vpc-id" {
  default = {}
}

variable "anywhere-ip" {
  default = "0.0.0.0/0"
}

variable "SSH-Port" {
  default = "22"
}

variable "HTTP-Port" {
  default = "80"
}


variable "Application-Port" {
  default = "81"
}

variable "HTTPS-Port" {
  default = "443"
}