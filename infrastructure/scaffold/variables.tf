locals {
  vpc_endpoint_names = toset([
    "ssm",
    "eks",
    "ec2messages",
    "ssmmessages",
    "ec2",
  ])
}

variable "project" {
  type        = string
  default     = "master-the-legacy"
  description = "The name of the project"
}

variable "legacy-vpc-id" {
  default = "vpc-07f21b0f96ab6ddf8"
}