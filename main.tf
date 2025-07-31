module "s3" {
  source = "./module/s3"
  facerprints-lambda-function = module.lambda-function.faceprints-lambda-function-arn
}

module "iam" {
  source = "./module/iam"
}

module "lambda-function" {
  source = "./module/lambda-function"
  collectionid-role = module.iam.collectionid-role-arn
  faceprints-role = module.iam.faceprints-role-arn
  source-bucket-arn = module.s3.source-bucket-arn
}

module "dynamodb-table" {
  source = "./module/dynamodb-table"
}

module "vpc" {
  source = "./module/vpc"
}

module "security-group" {
  source = "./module/security-group"
  vpc-id = module.vpc.vpc-id
}

module "keypair" {
  source = "./module/key-pair"
}

module "ec2-instance" {
  source = "./module/ec2-user"
  keypair = module.keypair.keypair-name
  security-group = module.security-group.application-server-sg
  public-subnet = module.vpc.public-subnet-1-id
  iam-instance-profile = module.iam.application-server-instance-profile
}

module "launch-template" {
  source = "./module/launch-template"
  application-sg = module.security-group.application-server-sg
  nodegroup-sg = module.security-group.nodegroup-sg
  keyname = module.keypair.keypair-name
}

module "eks-cluster" {
  source = "./module/eks-cluster"
  cluster-role-arn = module.iam.eks-cluster-role-arn
  application-sg = module.security-group.application-server-sg
  cluster-sg = module.security-group.cluster-sg
  launch-template-id = module.launch-template.launch-template-id
  private-subnet-1 = module.vpc.private-subnet-1
  private-subnet-2 = module.vpc.private-subnet-2
  nodegroup-role-arn = module.iam.nodegroup-role-arn
}