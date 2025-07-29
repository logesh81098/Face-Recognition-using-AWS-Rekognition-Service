terraform {
  backend "s3" {
    bucket = "terraform-backend-files-logesh"
    key = "Face-recognition-using-AWS-Rekognition-Service"
    region = "us-east-1"
  }
}