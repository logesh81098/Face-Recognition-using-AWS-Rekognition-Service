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


###################################################################################################################################################################
#                                                                IAM Role
###################################################################################################################################################################

#Deploying IAM Role for Application server

resource "aws_iam_role" "application-server-role" {
  name = "Face-Rekognition-Application-Server-Role"
  description = "IAM Role for Application server"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            }
        }
    ]
}  
EOF
    tags = {
      Name = "Face-Rekognition-Application-Server-Role"
      Project = "Recognizing-faces-using-AWS-Rekognition-service"
    }
}


###################################################################################################################################################################
#                                                                IAM Policy
###################################################################################################################################################################

#Deploying IAM Policy for Application Server

resource "aws_iam_policy" "application-server-policy" {
  name = "Face-Rekognition-Application-Server-Policy"
  description = "IAM Policy for Application Server"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "FullAccessDynamoDB",
            "Effect": "Allow",
            "Action": [
            "dynamodb:*"
            ],
            "Resource": "arn:aws:dynamodb:*:*:*"
        },
        {
            "Sid": "RekognitionIndexFace",
            "Effect": "Allow",
            "Action": [
            "rekognition:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3PutSourceImage",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:HeadObject"
            ],
            "Resource": [
                "arn:aws:s3:::face-rekognition-source-bucket/*",
                "arn:aws:s3:::face-rekognition-source-bucket"
            ]
        }
    ]
}
EOF
    tags = {
      Name = "Face-Rekognition-Application-Server-Policy"
      Project = "Recognizing-faces-using-AWS-Rekognition-service"
    }
}

###################################################################################################################################################################
#                                                      Attaching IAM Role and Policy
###################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "application-server" {
  role = aws_iam_role.application-server-role.id
  policy_arn = aws_iam_policy.application-server-policy.arn
}

###################################################################################################################################################################
#                                                         Instance Profile
###################################################################################################################################################################

resource "aws_iam_instance_profile" "application-server-instance-profile" {
  name = "Face-Rekognition-Application-Server-Instance-Profile"
  role = aws_iam_role.application-server-role.id
}


###################################################################################################################################################################
#                                                                IAM Role
###################################################################################################################################################################

#Deploying IAM Role for EKS Cluster

resource "aws_iam_role" "cluster-role" {
  name = "Face-Rekognition-Cluster-Role"
  description = "IAM Role for Face-Rekognition Cluster"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "eks.amazonaws.com"
            }
        }
    ]
}
EOF
    tags = {
      Name = "Face-Rekognition-Cluster-Role"
      Project = "Recognizing-faces-using-AWS-Rekognition-service"
    }
}


###################################################################################################################################################################
#                                                      Attaching IAM Role and Policy
###################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "application-policy" {
  role = aws_iam_role.cluster-role.id
  policy_arn = aws_iam_policy.application-server-policy.arn
}


resource "aws_iam_role_policy_attachment" "compute-policy" {
  role = aws_iam_role.cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
}


resource "aws_iam_role_policy_attachment" "storage-policy" {
  role = aws_iam_role.cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
}


resource "aws_iam_role_policy_attachment" "cni-policy" {
  role = aws_iam_role.cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "loadbalancing-policy" {
  role = aws_iam_role.cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
}


resource "aws_iam_role_policy_attachment" "network-policy" {
  role = aws_iam_role.cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster-policy" {
  role = aws_iam_role.cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

###################################################################################################################################################################
#                                                                IAM Role
###################################################################################################################################################################

#Deploying IAM Role for EKS NodeGroup

resource "aws_iam_role" "nodegroup_role" {
  name = "Face-Rekognition-NodeGroup-role"
  description = "IAM Role for Face-Rekognition NodeGroup"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal":{
                "Service": "ec2.amazonaws.com"
            }
        }
    ]
}  
EOF
    tags = {
      Name = "Face-Rekognition-NodeGroup-role"
      Project = "Recognizing-faces-using-AWS-Rekognition-service"
    }
}


###################################################################################################################################################################
#                                                      Attaching IAM Role and Policy
###################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "container-registery-policy" {
  role = aws_iam_role.nodegroup_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_role_policy_attachment" "workernode-policy" {
  role = aws_iam_role.nodegroup_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "nodegroup-cni-policy" {
  role = aws_iam_role.nodegroup_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "nodegroup-application-policy" {
  role = aws_iam_role.nodegroup_role.id
  policy_arn = aws_iam_policy.application-server-policy.arn
}