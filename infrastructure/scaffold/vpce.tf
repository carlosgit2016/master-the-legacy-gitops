locals {
  vpc_endpoint_names = toset([
    "ssm",
    "eks",
    "ec2messages",
    "ssmmessages",
    "ec2",
    "ecr.api",
    "ecr.dkr",
    "s3",
    "sts",
  ])
}

# VPC Endpoints
# https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/what-are-vpc-endpoints.html
resource "aws_vpc_endpoint" "vpce" {
  for_each = local.vpc_endpoint_names
  # AWS services that integrate with AWS Private Link
  # https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html
  # Check /var/log/cloud-init-output.log this file log in case the node fail to join the cluster
  service_name      = "com.amazonaws.eu-north-1.${each.value}"
  vpc_endpoint_type = "Interface" # An interface endpoint is a collection of one or more elastic network interfaces with a private IP address that serves as an entry point for traffic destined to a supported service.
  vpc_id            = data.aws_vpc.legacy-vpc.id

  subnet_ids         = data.aws_subnets.eks_subnets.ids
  security_group_ids = [data.aws_security_group.eks-cluster-sg.id]

  private_dns_enabled = true

  tags = {
    Name = "vpce-${each.value}"
  }
}