# Remove the /* at the top of this file and the */ at the end of the file to enable this code.
# You must have the second AWS account profile configured in ~/.aws/config and ~/.aws/credentials.

/*

provider "aws" {
  profile = "aws-auth-account-two"
  alias   = "number_two"
  default_tags {
    tags = {
      cluster     = local.name
      environment = "development"
      owner       = var.dev_role_id
      terraform   = "true"
    }
  }
}

data "aws_caller_identity" "remote" {
  provider = aws.number_two
  count    = var.setup_cross_account_sts ? 1 : 0
}

# Cross-Account STS w/ IRSA

## Remote Account (Cross-Account STS)

data "aws_iam_policy_document" "remote_account_trust_policy" {
  provider = aws.number_two
  count    = var.setup_cross_account_sts ? 1 : 0
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "remote_account_access" {
  provider           = aws.number_two
  count              = var.setup_cross_account_sts ? 1 : 0
  name               = "remote-account-access"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.remote_account_trust_policy[0].json
}

resource "aws_iam_policy" "remote_account_access" {
  provider    = aws.number_two
  count       = var.setup_cross_account_sts ? 1 : 0
  name        = "remote-account-access-account"
  path        = "/"
  description = "Access "

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "remote_account_access" {
  provider   = aws.number_two
  count      = var.setup_cross_account_sts ? 1 : 0
  role       = aws_iam_role.remote_account_access[0].id
  policy_arn = aws_iam_policy.remote_account_access[0].arn
}

## Local Account (Cross-Account STS)

# Create the IAM role that will be assumed by the service account
resource "aws_iam_role" "local_account_access_serviceaccount" {
  count              = var.setup_cross_account_sts ? 1 : 0
  name               = "local-account-access"
  assume_role_policy = data.aws_iam_policy_document.local_account_access_assume_role[0].json
}

data "aws_iam_policy_document" "local_account_access_assume_role" {
  count = var.setup_cross_account_sts ? 1 : 0
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
      values   = ["system:serviceaccount:cross-account-sts:local-access"]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "local_account_access" {
  count = var.setup_cross_account_sts ? 1 : 0
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [aws_iam_role.remote_account_access[0].arn]
  }
}

resource "aws_iam_policy" "local_account_access" {
  count  = var.setup_cross_account_sts ? 1 : 0
  name   = "local-account-access-policy"
  policy = data.aws_iam_policy_document.local_account_access[0].json
}

resource "aws_iam_role_policy_attachment" "local_account_access" {
  count      = var.setup_cross_account_sts ? 1 : 0
  role       = aws_iam_role.local_account_access_serviceaccount[0].name
  policy_arn = aws_iam_policy.local_account_access[0].arn
}

### Outputs

output "sts_local_account_role_arn" {
  description = "The STS role ARN in the local account."
  value       = aws_iam_role.local_account_access_serviceaccount[*].arn
}

output "sts_remote_account_role_arn" {
  description = "The STS role ARN in the remote account."
  value       = aws_iam_role.remote_account_access[*].arn
}

*/
