

resource "aws_ec2_instance_connect_endpoint" "staging" {
  subnet_id = module.staging_vpc.private_subnets[0]
}
