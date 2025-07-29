###################################################################################################################################################################
#                                                                Archive files
###################################################################################################################################################################

#Converting file formate from .py to .zip

data "archive_file" "collectionid" {
  type = "zip"
  source_dir = "module/lambda-function"
  output_path = "module/lambda-function/rekognition-collection-id.zip"
}

###################################################################################################################################################################
#                                                                Lambda Function
###################################################################################################################################################################

#Deploying Lambda Function to create Rekognition CollectionID

resource "aws_lambda_function" "rekognition-collection-id" {
  function_name = "Rekognition-CollectionID"
  description = "Lambda Function to create Rekognition CollectionID"
  filename = "module/lambda-function/rekognition-collection-id.zip"
  role = var.collectionid-role
  handler = "rekognition-collection-id.lambda_handler"
  runtime = var.runtime
  timeout = 20
  tags = {
    Name = "Rekognition-CollectionID"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

###################################################################################################################################################################
#                                                           Invoke Lambda Function
###################################################################################################################################################################

#Invoke Lambda function

resource "aws_lambda_invocation" "collectionid-invoke" {
  function_name = aws_lambda_function.rekognition-collection-id.function_name
  input = jsonencode({
    "collection_id" = "face-rekognition-collection"
  })
}


###################################################################################################################################################################
#                                                                Archive files
###################################################################################################################################################################

#Converting file formate from .py to .zip

data "archive_file" "faceprints-lambda" {
  type = "zip"
  source_dir = "module/lambda-function"
  output_path = "module/lambda-function/rekognition-faceprints.zip"
}


###################################################################################################################################################################
#                                                                Lambda Function
###################################################################################################################################################################

#Deploying Lambda Function to generate faceprints from source images

resource "aws_lambda_function" "rekognition-faceprints" {
  function_name = "Rekognition-Faceprints"
  description = "Lambda Function to generate faceprints"
  filename = "module/lambda-function/rekognition-faceprints.zip"
  role = var.faceprints-role
  handler = "rekognition-faceprints.lambda_handler"
  runtime = var.runtime
  timeout = 20
  tags = {
    Name = "Rekognition-Faceprints"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

######################################################################################################################################################################
#                                                      Resource Based Policy for Lambda function
######################################################################################################################################################################

resource "aws_lambda_permission" "resource-based-policy" {
  statement_id = "Resource-Based-Policy-for-S3-to-trigger-Lambda-Function"
  function_name = aws_lambda_function.rekognition-faceprints.function_name
  principal = "s3.amazonaws.com"
  action = "lambda:InvokeFunction"
  source_arn = var.source-bucket-arn
}