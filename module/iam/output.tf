output "collectionid-role-arn" {
  value = aws_iam_role.collectionid-role.arn
}

output "faceprints-role-arn" {
  value = aws_iam_role.rekognition-faceprints-role.arn
}

output "application-server-instance-profile" {
  value = aws_iam_instance_profile.application-server-instance-profile.name
}