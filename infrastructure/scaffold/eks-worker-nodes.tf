# Two node groups, one per subnet (The two existing subnets are in different AZs)
# If the nodes are in private subnets without NAT or internet gateway, it need to reach EKS API somehow https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
resource "aws_eks_node_group" "node-group-0" {
  cluster_name    = resource.aws_eks_cluster.eks.name
  node_group_name = "${terraform.workspace}-master-node-group-0"
  node_role_arn   = aws_iam_role.legacy_eks-worker_role.arn
  subnet_ids      = [data.aws_subnets.eks_subnets.ids[1]]
  capacity_type   = "SPOT"
  instance_types  = ["t3.micro"]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 1
  }
  # lifecycle {
  #   ignore_changes = [scaling_config[0].desired_size]
  # }
  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}

resource "aws_eks_node_group" "node-group-1" {
  cluster_name    = resource.aws_eks_cluster.eks.name
  node_group_name = "${terraform.workspace}-master-node-group-1"
  node_role_arn   = aws_iam_role.legacy_eks-worker_role.arn
  subnet_ids      = [data.aws_subnets.eks_subnets.ids[0]]
  capacity_type   = "SPOT"
  instance_types  = ["t3.micro"]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 1
  }
  # lifecycle {
  #   ignore_changes = [scaling_config[0].desired_size]
  # }
  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}