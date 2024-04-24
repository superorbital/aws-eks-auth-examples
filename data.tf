data "aws_caller_identity" "current" {}

# There is another data resource defined, but commented out by default, in `second-account.tf`.

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
