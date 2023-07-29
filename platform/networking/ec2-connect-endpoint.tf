

resource "aws_ec2_instance_connect_endpoint" "staging" {
  subnet_id = module.staging_vpc.private_subnets[0]

  tags = {
    Terraform   = "true"
    Owner       = "INFRA"
    Environment = "staging"
  }
}

# resource "aws_ec2_instance_connect_endpoint" "production" {
#   subnet_id = module.production_vpc.private_subnets[0]
# }
