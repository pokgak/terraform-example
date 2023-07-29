module "staging_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "staging-vpc"
  cidr = "10.64.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.64.1.0/24", "10.64.2.0/24", "10.64.3.0/24"]
  public_subnets  = ["10.64.101.0/24", "10.64.102.0/24", "10.64.103.0/24"]

  single_nat_gateway = true

  private_subnet_tags = {
    SubnetType = "Private"
  }
  public_subnet_tags = {
    SubnetType = "Public"
  }

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Owner       = "INFRA"
    Environment = "staging"
  }
}
