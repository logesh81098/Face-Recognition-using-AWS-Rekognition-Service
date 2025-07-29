###################################################################################################################################################################
#                                                                IAM Role
###################################################################################################################################################################

#Deploying IAM Role for Lambda Function to create Rekognition CollectionID

resource "aws_iam_role" "collectionid-role" {
  name = "Rekognition-CollectionID-Role"
  description = "IAM Role used by Lambda Function to create Rekognition CollectionID"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            }
        }
    ]
}
EOF  
    tags = {
      Name = "Rekognition-CollectionID-Role"
      Project = "Recognizing-faces-using-AWS-Rekognition-service"
    }
}


###################################################################################################################################################################
#                                                                IAM Policy
###################################################################################################################################################################

#IAM policy for Lambda Function to create Rekognition CollectionID

resource "aws_iam_policy" "collectionid-policy" {
  name = "Rekognition-CollectionID-Policy"
  description = "IAM policy for Lambda Function to create Rekognition CollectionID"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogGroup",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "RekognitionCollectionID",
            "Effect": "Allow",
            "Action": [
                "rekognition:CreateCollection",
                "rekognition:DeleteCollection",
                "rekognition:ListCollections"
            ],
            "Resource": "*"
        }
    ]
}  
EOF
    tags = {
      Name = "Rekognition-CollectionID-Policy"
      Project = "Recognizing-faces-using-AWS-Rekognition-service"
    }
}

###################################################################################################################################################################
#                                                      Attaching IAM Role and Policy
###################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "rekognition-collection-id" {
  role = aws_iam_role.collectionid-role.id
  policy_arn = aws_iam_policy.collectionid-policy.arn
}


###################################################################################################################################################################
#                                                                IAM Role
###################################################################################################################################################################

#Deploying IAM Role for Lambda Function to generate faceprints of stored images

resource "aws_iam_role" "rekognition-faceprints-role" {
  name = "Rekognition-Faceprints-Role"
  description = "IAM Role for Lambda Function to generate faceprints of stored images"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            }
        }
    ]
}  
EOF
    tags = {
      Name = "Rekognition-Faceprints-Role"
      Project = "Recognizing-faces-using-AWS-Rekognition-service"
    }
}


###################################################################################################################################################################
#                                                                IAM Policy
###################################################################################################################################################################

#Deploying IAM Policy for Lambda Function to generate faceprints of stored images

resource "aws_iam_policy" "rekognition-faceprints-policy" {
  name = "Rekognition-Faceprints-Policy"
  description = "IAM Policy for Lambda Function to generate faceprints of stored images"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogGroup",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "GetObjectfromS3",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:HeadObject"
            ],
            "Resource": "arn:aws:s3:::face-rekognition-source-bucket/*"
        },
        {
            "Sid": "IndexFace",
            "Effect": "Allow",
            "Action": [
                "rekognition:IndexFaces"
            ],
            "Resource": "arn:aws:rekognition:*:*:collection/*"
        },
        {
            "Sid": "PutItemsinDynamoDBTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem"
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/Faceprints-Table"
        }
    ]
}
EOF
    tags = {
      Name = "Rekognition-Faceprints-Policy"
      Project = "Recognizing-faces-using-AWS-Rekognition-service"
    }
}

###################################################################################################################################################################
#                                                      Attaching IAM Role and Policy
###################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "rekognition-faceprints" {
  role = aws_iam_role.rekognition-faceprints-role.id
  policy_arn = aws_iam_policy.rekognition-faceprints-policy.arn
}