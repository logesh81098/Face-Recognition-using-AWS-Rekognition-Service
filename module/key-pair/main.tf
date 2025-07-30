###################################################################################################################################################################
#                                                                Keypair  
###################################################################################################################################################################

#Keypair for application server

resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "face-rekognition-keypair" {
  key_name = "Face-rekognition-keypair"
  public_key = tls_private_key.keypair.public_key_openssh
}

resource "local_file" "face-rekognition-private-key" {
  filename = "face-rekognition-private-key"
  content = tls_private_key.keypair.private_key_openssh
}