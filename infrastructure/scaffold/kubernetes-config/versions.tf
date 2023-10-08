terraform {
  required_version = ">= 1.5.3, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }
  }

  backend "s3" {
    bucket = "master-the-legacy-tf-state"
    key    = "tf-states/infrastructure/scaffold/kubernetes-config/terraform.tfstate"
    region = "us-east-1"
  }

}

# Getting cluster info and auth
data "aws_eks_cluster" "example" {
  name = "${terraform.workspace}-master-cluster"
}

data "aws_eks_cluster_auth" "example" {
  name = "${terraform.workspace}-master-cluster"
}

provider "aws" {
  region = "eu-north-1"
  default_tags {
    tags = {
      project = "master-the-legacy"
      owners  = "cflor"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}