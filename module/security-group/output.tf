output "application-server-sg" {
  value = aws_security_group.application-server-sg.id
}

output "nodegroup-sg" {
  value = aws_security_group.nodegroup-sg.id
}