# Editing aws iam auth configmap to include flower01 user
data "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

resource "kubernetes_config_map" "aws_auth_patch" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = jsonencode(concat(yamldecode(data.kubernetes_config_map.aws_auth.data["mapRoles"]), [
      {
        groups   = ["system:masters"],
        rolearn  = "arn:aws:iam::169740125934:role/AWSReservedSSO_admin-role_eeabd812461662aa", # When you access AWS by using federation, you are indirectly assuming a role.
        username = "flower01",
      }
    ]))
    mapUsers = jsonencode([
      {
        groups   = ["system:masters"],
        userarn  = "arn:aws:iam::169740125934:root",
        username = "root",
      }
    ])
  }
}