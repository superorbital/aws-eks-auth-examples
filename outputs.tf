output "aws_iam_keys_user_one" {
  description = "UserOne's AWS access and secret key."
  value       = join(",", aws_iam_access_key.user_one[*].id, aws_iam_access_key.user_one[*].secret)
  sensitive   = true
}

output "aws_iam_keys_user_two" {
  description = "UserTwo's AWS access and secret key."
  value       = join(",", aws_iam_access_key.user_two[*].id, aws_iam_access_key.user_two[*].secret)
  sensitive   = true
}

output "aws_iam_keys_user_three" {
  description = "UserThree's AWS access and secret key."
  value       = join(",", aws_iam_access_key.user_three[*].id, aws_iam_access_key.user_three[*].secret)
  sensitive   = true
}

output "ec2_irsa_role_arn" {
  description = "The role ARN that needs to be added to Kubernetes Service Account annotations for IRSA."
  value       = aws_iam_role.ec2_list_instances[*].arn
}

# There are two additional outputs defined, but commented out by default, in `second-account.tf`.
