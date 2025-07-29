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