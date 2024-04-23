locals {
  account_id      = data.aws_caller_identity.current.account_id
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  eks_oidc_issuer = trimprefix(module.eks.cluster_oidc_issuer_url, "https://")
  name            = "aws-eks-auth-test"
  region          = data.aws_region.current.name
}
