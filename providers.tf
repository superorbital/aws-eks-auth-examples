provider "aws" {
  profile = "aws-auth-account-one"
  default_tags {
    tags = {
      cluster     = local.name
      environment = "development"
      owner       = var.dev_role_id
      terraform   = "true"
    }
  }
}

# There is another AWS provider defined, but commented out by default, in `second-account.tf`

# We need this to configure the aws-auth Config Map
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
