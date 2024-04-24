resource "aws_iam_policy" "eks_users" {
  count       = var.create_test_users ? 1 : 0
  name        = "eks-users"
  path        = "/"
  description = "Allow users to list clusters and update their KUBECONFIG"


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster"
        ]
        Effect   = "Allow"
        Resource = module.eks.cluster_arn
      },
      {
        Action = [
          "eks:ListClusters"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:eks:${local.region}:${local.account_id}:cluster/*"
      },
    ]
  })
}

resource "aws_iam_user" "user_one" {
  count = var.create_test_users ? 1 : 0
  name  = "UserOne"
  path  = "/"
}

resource "aws_iam_access_key" "user_one" {
  count = var.create_test_users ? 1 : 0
  user  = aws_iam_user.user_one[count.index].name
}

resource "aws_iam_user_policy_attachment" "user_one" {
  count      = var.create_test_users ? 1 : 0
  user       = aws_iam_user.user_one[count.index].name
  policy_arn = aws_iam_policy.eks_users[count.index].arn
}

resource "aws_iam_user" "user_two" {
  count = var.create_test_users ? 1 : 0
  name  = "UserTwo"
  path  = "/"
}

resource "aws_iam_access_key" "user_two" {
  count = var.create_test_users ? 1 : 0
  user  = aws_iam_user.user_two[count.index].name
}

resource "aws_iam_user_policy_attachment" "user_two" {
  count      = var.create_test_users ? 1 : 0
  user       = aws_iam_user.user_two[count.index].name
  policy_arn = aws_iam_policy.eks_users[count.index].arn
}

resource "aws_iam_user" "user_three" {
  count = var.create_test_users ? 1 : 0
  name  = "UserThree"
  path  = "/"
}

resource "aws_iam_access_key" "user_three" {
  count = var.create_test_users ? 1 : 0
  user  = aws_iam_user.user_three[count.index].name
}

resource "aws_iam_user_policy_attachment" "user_three" {
  count      = var.create_test_users ? 1 : 0
  user       = aws_iam_user.user_three[count.index].name
  policy_arn = aws_iam_policy.eks_users[count.index].arn
}

# IRSA

resource "aws_iam_policy" "ec2_list_instances" {
  count       = var.setup_irsa ? 1 : 0
  name_prefix = "ec2-list-instances-"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeTags",
          "ec2:DescribeSnapshots"
        ]
        Resource = "*"
      },
    ]
  })
}

data "aws_iam_policy_document" "eks_assume_role" {
  count = var.setup_irsa ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        module.eks.oidc_provider_arn
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer}:sub"
      # Note the namespace and service account name embeded in here.
      values = ["system:serviceaccount:default:eks-ec2-list"]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_list_instances" {
  count              = var.setup_irsa ? 1 : 0
  name               = "eks-ec2-list-instances"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "ec2_list_instances" {
  count      = var.setup_irsa ? 1 : 0
  policy_arn = aws_iam_policy.ec2_list_instances[0].arn
  role       = aws_iam_role.ec2_list_instances[0].name
}

# Pod Identity

resource "aws_iam_policy" "eks_describe_cluster" {
  count       = var.setup_pod_identity ? 1 : 0
  name_prefix = "eks-describe-cluster-"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ]
        Resource = "*"
      },
    ]
  })
}

data "aws_iam_policy_document" "pod_identity_assume_role" {
  count = var.setup_pod_identity ? 1 : 0

  # Pod Identity
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "pod_identity_test_pod" {
  count = var.setup_pod_identity ? 1 : 0

  name        = "pod_identity_test-${module.eks.cluster_name}"
  path        = "/"
  description = "Pod Identyity Test IAM role"

  assume_role_policy    = data.aws_iam_policy_document.pod_identity_assume_role[0].json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "pod_identity_test_pod" {
  count = var.setup_pod_identity ? 1 : 0

  role       = aws_iam_role.pod_identity_test_pod[0].name
  policy_arn = aws_iam_policy.eks_describe_cluster[0].arn
}

resource "aws_eks_pod_identity_association" "pod_identity_test_pod" {
  count = var.setup_pod_identity ? 1 : 0

  cluster_name = module.eks.cluster_name
  # This needs to match the namespace where the pod will be running.
  namespace = "pod-id"
  # This needs to match the service account name that the pod will be using.
  service_account = "pod-identity"
  # This need to be the ARN for the IAM role that the service account should receive.
  role_arn = aws_iam_role.pod_identity_test_pod[0].arn
}

## All of the setup for the Cross-Account STS setup is contained, but commented out by default, in `second-account.tf`.
