locals {
  eks_availability_zones = toset([
    "eu-north-1a",
    "eu-north-1b",
  ])
}

variable "project" {
  type        = string
  default     = "master-the-legacy"
  description = "The name of the project"
}
