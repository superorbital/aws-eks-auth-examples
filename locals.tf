locals {
  account_id      = data.aws_caller_identity.current.account_id
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  eks_oidc_issuer = trimprefix(module.eks.cluster_oidc_issuer_url, "https://")
  name            = "aws-eks-auth-test"
  region          = data.aws_region.current.name

  auth_cm_users = var.create_test_users ? [{
    userarn  = aws_iam_user.user_one[0].arn
    username = aws_iam_user.user_one[0].name
    groups   = ["system:masters"]
    },
    {
      userarn  = aws_iam_user.user_two[0].arn
      username = aws_iam_user.user_two[0].name
      groups   = ["eks-default"]
    }
  ] : null
}
