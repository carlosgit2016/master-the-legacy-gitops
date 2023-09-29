module "oidc_provider" {
  source = "github.com/philips-labs/terraform-aws-github-oidc?ref=v0.7.1//modules/provider"
}

module "gh_oidc" {
  source = "github.com/philips-labs/terraform-aws-github-oidc?ref=v0.7.1"

  openid_connect_provider_arn = module.oidc_provider.openid_connect_provider.arn
  repo                        = "carlosgit2016/gitops"
  role_name                   = "gh-oidc"

  # optional
  # override default conditions
  default_conditions = ["allow_all"] # This allow the org/project completely
  role_policy_arns = [
    data.aws_iam_policy.adm.arn
  ]
  # add extra conditions, will be merged with the default_conditions
  conditions = [{
    test     = "StringLike"
    variable = "token.actions.githubusercontent.com:sub"
    values = [
      "repo:carlosgit2016/votingapp-results:*",
    ]
  }]
}