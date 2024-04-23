variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
  default     = "aws-auth-test"
}

variable "dev_role_id" {
  type        = string
  description = "AWS IAM username for the primary user/owner"
  default     = "anonymous"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = "1.29"
}

variable "vpc_cidr" {
  type        = string
  description = "AWS VPC CIDR"
  default     = "10.42.0.0/16"
}

variable "create_test_users" {
  type        = bool
  description = "Should we create the test IAM users and keys?"
  default     = false
}

variable "setup_irsa" {
  type        = bool
  description = "Should we setup the IRSA components?"
  default     = false
}

variable "setup_pod_identity" {
  type        = bool
  description = "Should we setup the Pod Identity components?"
  default     = false
}

variable "setup_cross_account_sts" {
  type        = bool
  description = "Should we setup the cross account STS components?"
  default     = false
}
