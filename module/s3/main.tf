###################################################################################################################################################################
#                                                                S3 Bucket
###################################################################################################################################################################

#Deploying S3 bucket to store source images

resource "aws_s3_bucket" "source-bucket" {
  bucket = "face-rekognition-source-bucket"
  tags = {
    Name = "face-rekognition-source-bucket"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

###################################################################################################################################################################
#                                                        S3 to trigger lambda function
###################################################################################################################################################################

#S3 bucket to trigger Lambda function

resource "aws_s3_bucket_notification" "s3-to-trigger-lambda" {
  bucket = aws_s3_bucket.source-bucket.bucket
  lambda_function {
    lambda_function_arn = var.facerprints-lambda-function
    events = [ "s3:ObjectCreated:*" ]
  }
}