####################
# VPC Endpoint
####################
data "aws_iam_policy_document" "vpc_endpoint" {
  statement {
    effect    = "Allow"
    actions   = [ "*" ]
    resources = [ "*" ]
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_endpoint_type = "Interface"
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids =  module.vpc.public_subnets
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id
  ]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_endpoint_type = "Interface"
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids =  module.vpc.private_subnets
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id
  ]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_endpoint_type = "Interface"
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.ec2messages"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids =  module.vpc.private_subnets
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id
  ]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_endpoint_type = "Gateway"
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  route_table_ids = [
    module.vpc.private_route_table_ids[0]
  ]
}

####################
# VPC Endpoint Security Group
####################
resource "aws_security_group" "ssm" {
  name        = "inomaso-dev-ssm-sg"
  description = "inomaso-dev-ssm-sg"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol  = "tcp"
    cidr_blocks = [
      var.network.cidr
    ]
  }

  tags = {
    Name = "inomaso-dev-ssm-sg"
  }
}