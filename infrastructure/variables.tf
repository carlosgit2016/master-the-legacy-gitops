locals {
  eks_availability_zones = toset([
    "us-east-1a",
    "us-east-1b",
  ])
}

variable "project" {
  type        = string
  default     = "master-the-legacy"
  description = "The name of the project"
}
