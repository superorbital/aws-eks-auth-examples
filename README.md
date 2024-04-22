<!-- markdownlint-disable MD033 -->
# README

This will spin up an EKS cluster in AWS that can be used to explore authentication and authorization options.

**NOTE:** This is for example only. There are no guarantees that this is secure, so use this with appropriate caution.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.44 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.44 |
| <a name="provider_aws.number_two"></a> [aws.number\_two](#provider\_aws.number\_two) | ~> 5.44 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_auth"></a> [aws\_auth](#module\_aws\_auth) | terraform-aws-modules/eks/aws//modules/aws-auth | ~> 20.0 |
| <a name="module_ebs_kms_key"></a> [ebs\_kms\_key](#module\_ebs\_kms\_key) | terraform-aws-modules/kms/aws | ~> 2.2 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 20.0 |
| <a name="module_key_pair"></a> [key\_pair](#module\_key\_pair) | terraform-aws-modules/key-pair/aws | ~> 2.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.7 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_access_entry.user_three](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.user_three](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_pod_identity_association.pod_identity_test_pod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_access_key.user_one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.user_three](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.user_two](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.ec2_list_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_describe_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.local_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.remote_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ec2_list_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.local_account_access_serviceaccount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.pod_identity_test_pod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.remote_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_list_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.local_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.pod_identity_test_pod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.remote_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.user_one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.user_three](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.user_two](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.user_one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.user_three](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.user_two](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_security_group.remote_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.remote](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.eks_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.local_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.local_account_access_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.pod_identity_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.remote_account_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Kubernetes cluster name | `string` | `"aws-auth-test"` | no |
| <a name="input_create_test_users"></a> [create\_test\_users](#input\_create\_test\_users) | Should we create the test IAM users and keys? | `bool` | `true` | no |
| <a name="input_dev_role_id"></a> [dev\_role\_id](#input\_dev\_role\_id) | AWS IAM username for the primary user/owner | `string` | `"anonymous"` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Kubernetes cluster version | `string` | `"1.29"` | no |
| <a name="input_setup_cross_account_sts"></a> [setup\_cross\_account\_sts](#input\_setup\_cross\_account\_sts) | Should we setup the cross account STS components? | `bool` | `true` | no |
| <a name="input_setup_irsa"></a> [setup\_irsa](#input\_setup\_irsa) | Should we setup the IRSA components? | `bool` | `true` | no |
| <a name="input_setup_pod_identity"></a> [setup\_pod\_identity](#input\_setup\_pod\_identity) | Should we setup the Pod Identity components? | `bool` | `true` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | AWS VPC CIDR | `string` | `"10.42.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_keys_user_one"></a> [aws\_iam\_keys\_user\_one](#output\_aws\_iam\_keys\_user\_one) | UserOne's AWS access and secret key. |
| <a name="output_aws_iam_keys_user_three"></a> [aws\_iam\_keys\_user\_three](#output\_aws\_iam\_keys\_user\_three) | UserThree's AWS access and secret key. |
| <a name="output_aws_iam_keys_user_two"></a> [aws\_iam\_keys\_user\_two](#output\_aws\_iam\_keys\_user\_two) | UserTwo's AWS access and secret key. |
| <a name="output_ec2_irsa_role_arn"></a> [ec2\_irsa\_role\_arn](#output\_ec2\_irsa\_role\_arn) | The role ARN that needs to be added to Kubernetes Service Account annotations for IRSA. |
| <a name="output_sts_local_account_role_arn"></a> [sts\_local\_account\_role\_arn](#output\_sts\_local\_account\_role\_arn) | The STS role ARN in the local account. |
| <a name="output_sts_remote_account_role_arn"></a> [sts\_remote\_account\_role\_arn](#output\_sts\_remote\_account\_role\_arn) | The STS role ARN in the remote account. |
<!-- END_TF_DOCS -->
