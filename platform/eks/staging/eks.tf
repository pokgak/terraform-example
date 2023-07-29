data "aws_caller_identity" "current" {}

# workaround issue: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2327#issuecomment-1355581682
data "aws_iam_session_context" "current" {
  # "This data source provides information on the IAM source role of an STS assumed role. For non-role ARNs, this data source simply passes the ARN through in issuer_arn."
  arn = data.aws_caller_identity.current.arn
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["staging-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:SubnetType"
    values = ["Private"]
  }
}

data "aws_iam_role" "eks_admin" {
  name = "eks-admin"
}

data "aws_iam_user" "acg_cloud_user" {
  user_name = "cloud_user"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "staging-eks"
  cluster_version = "1.27"
  
  # ideally we have private only but we use public terraform cloud runner
  # no way to specify private ip to grant access to private cluster endpoint
  # without this we will get timeout error
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = data.aws_vpc.this.id
  subnet_ids = data.aws_subnets.private.ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 3

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  # need manual import (see below)
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = data.aws_iam_role.eks_admin.arn
      username = "eks-admin"
      groups   = ["system:masters"]
    },
  ]

  kms_key_administrators = [data.aws_iam_session_context.current.issuer_arn]
}

import {
    id = "kube-system/aws-auth"
    to = module.eks.kubernetes_config_map.aws_auth[0]
}
