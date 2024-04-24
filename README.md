<!-- markdownlint-disable MD033 -->
# README

This will spin up an EKS cluster in AWS that can be used to explore authentication and authorization options.

**NOTE:** This is for example only. Spinning this up **will** cost you money and there are no guarantees that this is secure, so use this with appropriate caution.

## Usage

You will need at least one, but preferably two AWS accounts that you have full access to, and you will also need to have the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). the [Terraform CLI](https://developer.hashicorp.com/terraform/install), and most likely [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) installed.

To do most of the examples, you only need a single account and profile, but if you are going to try and do them all then you will need 2 AWS accounts and two profiles, very similar to these:

- `~/.aws/config`

```ini
[profile aws-auth-account-one]
region=us-west-2
output=yaml-stream

[profile aws-auth-account-two]
region=us-west-2
output=yaml-stream
```

- `~/.aws/credentials`

```ini
[aws-auth-account-one]
aws_access_key_id=REDACTED_ACCESS_KEY
aws_secret_access_key=REDACTED_SECRET_ACCESS_KEY

[aws-auth-account-two]
aws_access_key_id=REDACTED_ACCESS_KEY
aws_secret_access_key=REDACTED_SECRET_ACCESS_KEY
```

> If you have two AWS accounts to work with, then you should uncomment all the Terraform code in `second-account.tf`. However, if you have only one account then go ahead and leave it commented out, so that everything else will continue to work as expected.

You will also need to know the username for your IAM user in account one (_e.g. ajohnson_), so that you can pass this information to Terraform.

**NOTE**: There are other ways to configure these credentials, but this is the easiest way to explain and document. If you are familiar enough with all of this, feel free to tweak things to your liking.

Once these profiles are in place and configured with valid credentials then you should be able to spin up the infrastructure with:

```sh
terraform init
terraform plan -var dev_role_id=$(aws --profile aws-auth-account-one iam get-user --output text --query 'User.UserName')
terraform apply -var dev_role_id=$(aws --profile aws-auth-account-one iam get-user --output text --query 'User.UserName')
```

**NOTE**: It can easily take 15-20 minutes for the whole environment to spin up or down.

When you are done you should tear down the infrastructure with:

```sh
terraform destroy
```

## Contributing

### Pre-Commit Hooks

- See: [pre-commit](https://pre-commit.com/)
  - [pre-commit/pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks)
  - [antonbabenko/pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform)

#### Install

##### Local Install (macOS)

- **IMPORTANT**: All developers committing any code to this repo, should have these pre-commit hooks installed locally. Github actions may also run these at some point, but it is generally faster and easier to run them locally, in most cases.

```sh
brew install pre-commit terraform-docs tfenv tflint tfsec checkov terrascan infracost tfupdate minamijoyo/hcledit/hcledit jq shellcheck shfmt git-secrets

mkdir -p ${HOME}/.git-template/hooks
git config --global init.templateDir ${HOME}/.git-template
```

- Close and reopen your terminal
- Make sure that you run these commands from the root of this git repo!

```sh
cd aws-eks-auth-examples
pre-commit init-templatedir -t pre-commit ${HOME}/.git-template
pre-commit install
```

- Test it

```sh
pre-commit run -a
git diff
```

#### Checks

See:

- [.pre-commit-config.yaml](./.pre-commit-config.yaml)

##### Configuring Hooks

- [.pre-commit-config.yaml](./.pre-commit-config.yaml)
- [.tflint.hcl](./.tflint.hcl)
- [.terraform-docs.yml](./.terraform-docs.yml)

---

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

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Kubernetes cluster name | `string` | no |
| <a name="input_create_access_entries"></a> [create\_access\_entries](#input\_create\_access\_entries) | Should we create the access entries? | `bool` | no |
| <a name="input_create_test_users"></a> [create\_test\_users](#input\_create\_test\_users) | Should we create the test IAM users and keys? | `bool` | no |
| <a name="input_dev_role_id"></a> [dev\_role\_id](#input\_dev\_role\_id) | AWS IAM username for the primary user/owner | `string` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Kubernetes cluster version | `string` | no |
| <a name="input_setup_cross_account_sts"></a> [setup\_cross\_account\_sts](#input\_setup\_cross\_account\_sts) | Should we setup the cross account STS components? | `bool` | no |
| <a name="input_setup_irsa"></a> [setup\_irsa](#input\_setup\_irsa) | Should we setup the IRSA components? | `bool` | no |
| <a name="input_setup_pod_identity"></a> [setup\_pod\_identity](#input\_setup\_pod\_identity) | Should we setup the Pod Identity components? | `bool` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | AWS VPC CIDR | `string` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_keys_user_one"></a> [aws\_iam\_keys\_user\_one](#output\_aws\_iam\_keys\_user\_one) | UserOne's AWS access and secret key. |
| <a name="output_aws_iam_keys_user_three"></a> [aws\_iam\_keys\_user\_three](#output\_aws\_iam\_keys\_user\_three) | UserThree's AWS access and secret key. |
| <a name="output_aws_iam_keys_user_two"></a> [aws\_iam\_keys\_user\_two](#output\_aws\_iam\_keys\_user\_two) | UserTwo's AWS access and secret key. |
| <a name="output_ec2_irsa_role_arn"></a> [ec2\_irsa\_role\_arn](#output\_ec2\_irsa\_role\_arn) | The role ARN that needs to be added to Kubernetes Service Account annotations for IRSA. |
<!-- END_TF_DOCS -->
