module "s3" {
  source = "./module/s3"
}

module "iam" {
  source = "./module/iam"
}

module "lambda-function" {
  source = "./module/lambda-function"
  collectionid-role = module.iam.collectionid-role-arn
}

module "dynamodb-table" {
  source = "./module/dynamodb-table"
}