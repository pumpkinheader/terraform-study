module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.service.name}-vpc"
  cidr = var.network.cidr

  azs             = var.network.azs
  private_subnets = var.network.private_subnets
  public_subnets  = var.network.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform = "true"
    Environment = var.service.env
  }
}

resource "aws_route_table" "privatelink_rt" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "inomaso-dev-privatelink-rtb"
  }
}

# resource "aws_route_table" "app_rt" {
#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Name = "inomaso-dev-app-rtb"
#   }
# }

# resource "aws_route_table_association" "sub_privatelink_1a_rt_assocication" {
#   subnet_id      = module.vpc.private_subnets[0]
#   route_table_id = aws_route_table.privatelink_rt.id
# }

# resource "aws_route_table_association" "sub_app_1a_rt_assocication" {
#   subnet_id      = module.vpc.private_subnets[0]
#   route_table_id = aws_route_table.app_rt.id
# }