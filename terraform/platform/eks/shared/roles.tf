data "aws_iam_user" "acg_cloud_user" {
  user_name = "cloud_user"
}

module "eks_admin_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  role_name           = "eks-admin"
  create_role         = true
  attach_admin_policy = true
  role_requires_mfa   = false # to simplify usage with ACG created user
  trusted_role_arns   = [data.aws_iam_user.acg_cloud_user.arn]
}

output "eks_admin_role_arn" {
  value = module.eks_admin_role.iam_role_arn
}
