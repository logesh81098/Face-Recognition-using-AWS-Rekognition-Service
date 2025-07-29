module "s3" {
  source = "./module/s3"
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