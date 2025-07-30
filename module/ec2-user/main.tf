###################################################################################################################################################################
#                                                               EC2 Instance
###################################################################################################################################################################

#Deploying application server

resource "aws_instance" "application-server" {
  ami = var.ami-id
  instance_type = var.instance-type
  subnet_id = var.public-subnet
  key_name = var.keypair
  vpc_security_group_ids = [ var.security-group ]
  iam_instance_profile = var.iam-instance-profile
  ebs_block_device {
    volume_size = var.root-volume-size
    volume_type = var.root-volume-type
    device_name = "/dev/xvda"
  }
  tags = {
    Name = "Face Rekognition Application Server"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}