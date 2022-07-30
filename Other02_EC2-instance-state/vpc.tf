module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.service.name}-vpc"
  cidr = var.network.cidr

  azs             = var.network.azs
  private_subnets = var.network.private_subnets
  public_subnets  = var.network.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = var.service.env
  }
}
