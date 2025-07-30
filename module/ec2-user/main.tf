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
  user_data = <<-EOF
  #!bin/bash
  sudo su
  set -eux
  dnf update -y
  dnf upgrade -y
  dnf install git -y
  git --version
  dnf install docker -y
  systemctl enable docker
  systemctl start docker
  sleep 10
  systemctl status docker
  usermod -aG docker ec2-user
  dnf install -y python3 python3-pip 
  pip install boto3
  cd /
  git clone https://github.com/logesh81098/Face-Recognition-using-AWS-Rekognition-Service.git
  cd Face-Recognition-using-AWS-Rekognition-Service/
  EOF

}