module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                   = local.name
  cluster_version                = var.k8s_version
  cluster_endpoint_public_access = true
  authentication_mode            = "API_AND_CONFIG_MAP"

  # IPV6
  cluster_ip_family          = "ipv6"
  create_cni_ipv6_iam_policy = true

  enable_cluster_creator_admin_permissions = true

  # Enable EFA support by adding necessary security group rules
  # to the shared node security group
  enable_efa_support = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    # Default node group - as provided by AWS EKS
    default_node_group = {
      # By default, the module creates a launch template to ensure tags are propagated to instances, etc.,
      # so we need to disable it to use the default template provided by the AWS EKS managed node group service
      use_custom_launch_template = false

      min_size     = 1
      max_size     = 6
      desired_size = 1

      disk_size = 50

      # Remote access cannot be specified with a launch template
      remote_access = {
        ec2_ssh_key               = module.key_pair.key_pair_name
        source_security_group_ids = [aws_security_group.remote_access.id]
      }
    }
  }

  # Since we are expecting the user to run Terraform with their user credentials
  # and not via CI/CD we don't need this entry, since it will already exist.
  #
  #access_entries = {
  #  # One access entry with a policy associated
  #  admin = {
  #    kubernetes_groups = []
  #    principal_arn     = "arn:aws:iam::${local.account_id}:user/${var.dev_role_id}"
  #    policy_associations = {
  #      owner = {
  #        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  #        access_scope = {
  #          type = "cluster"
  #        }
  #      }
  #    }
  #  }
  #}
}

module "aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = module.eks.eks_managed_node_groups.default_node_group.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  # This could be disabled, so let's use try() to handle that.
  aws_auth_users = try([
    {
      userarn  = aws_iam_user.user_one[0].arn
      username = aws_iam_user.user_one[0].name
      groups   = ["system:masters"]
    },
    {
      userarn  = aws_iam_user.user_two[0].arn
      username = aws_iam_user.user_two[0].name
      groups   = ["eks-default"]
    }
  ], [{}])

  #aws_auth_accounts = [
  #  "777777777777"
  #]
}

# We don't create these via the EKS module, because we want more control
# over when they are created.
resource "aws_eks_access_entry" "user_three" {
  count             = var.create_test_users && var.create_access_entries ? 1 : 0
  cluster_name      = module.eks.cluster_name
  kubernetes_groups = []
  principal_arn     = aws_iam_user.user_three[0].arn
  type              = "STANDARD"
  user_name         = aws_iam_user.user_three[0].name
}

resource "aws_eks_access_policy_association" "user_three" {
  count = var.create_test_users && var.create_access_entries ? 1 : 0

  access_scope {
    namespaces = ["default", "kube-node-lease", "kube-public", "kube-system"]
    type       = "namespace"
  }

  cluster_name = module.eks.cluster_name

  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  principal_arn = aws_iam_user.user_three[0].arn
  depends_on    = [aws_eks_access_entry.user_three]
}
