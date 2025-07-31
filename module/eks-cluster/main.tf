###################################################################################################################################################################
#                                                                EKS Cluster
###################################################################################################################################################################

#EKS Cluster to deploy Face Rekognition Application

resource "aws_eks_cluster" "face-rekognition-cluster" {
  name = "Face-Rekognition-Cluster"
  role_arn = var.cluster-role-arn
  vpc_config {
    security_group_ids = [ var.cluster-sg, var.application-sg ]
    subnet_ids = [ var.private-subnet-1, var.private-subnet-2 ]
  }
  tags = {
    Name = "Face-Rekognition-Cluster"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


###################################################################################################################################################################
#                                                                EKS Node Group
###################################################################################################################################################################

#EKS Node Group to deploy Face Rekognition Application

resource "aws_eks_node_group" "face-rekognition-node-group" {
  cluster_name = aws_eks_cluster.face-rekognition-cluster.name
  node_group_name = "Face-Rekognition-NodeGroup"
  node_role_arn = var.nodegroup-role-arn
  subnet_ids = [ var.private-subnet-1, var.private-subnet-2 ]
  scaling_config {
    max_size = 2
    min_size = 1 
    desired_size = 1
  }
  instance_types = [ var.instance-type ]
  launch_template {
    id = var.launch-template-id
    version = "$Latest"
  }
  tags = {
    Name = "Face-Rekogntion-NodeGroup"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }

}