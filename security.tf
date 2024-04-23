module "ebs_kms_key" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.2"

  description = "Customer managed key to encrypt EKS managed node group volumes"

  # Policy
  key_administrators = [
    "arn:aws:iam::${local.account_id}:user/${var.dev_role_id}", "arn:aws:iam::${local.account_id}:role/Admin"
  ]

  key_service_roles_for_autoscaling = [
    # required for the ASG to manage encrypted volumes for nodes
    "arn:aws:iam::${local.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    # required for the cluster / persistentvolume-controller to create encrypted PVCs
    module.eks.cluster_iam_role_arn,
  ]

  # Aliases
  aliases = ["eks/${local.name}/ebs"]
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name_prefix    = local.name
  create_private_key = true
}

resource "aws_security_group" "remote_access" {
  name_prefix = "${local.name}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "${local.name}-remote" }
}
