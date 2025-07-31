output "application-server-sg" {
  value = aws_security_group.application-server-sg.id
}

output "nodegroup-sg" {
  value = aws_security_group.nodegroup-sg.id
}

output "cluster-sg" {
  value = aws_security_group.eks-cluster-sg.id
}