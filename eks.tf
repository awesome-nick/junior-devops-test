resource "aws_eks_cluster" "aws_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnets
    endpoint_private_access = "false"
    endpoint_public_access = "true"
  }

  tags = {
    Name = var.cluster_name
  }
}

data "aws_eks_cluster_auth" "aws_eks" {
  name = var.cluster_name
}

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids = var.subnets

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

    labels = {
        Name  = var.node_group_name
    }

  disk_size = var.disk_size
  instance_types = var.instance_types
  
  # name & path of key file to access the ec2 instances
  # remote_access {
  #   ec2_ssh_key = "terraform"
  # }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}