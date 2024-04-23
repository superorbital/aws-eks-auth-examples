data "aws_caller_identity" "current" {}
data "aws_caller_identity" "remote" {
  provider = aws.number_two
  count    = var.setup_cross_account_sts ? 1 : 0
}
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
