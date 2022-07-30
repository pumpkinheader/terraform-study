resource "aws_instance" "foo" {
  count = 2
  ami           = "ami-03d79d440297083e3"

  instance_type = "t3.micro"

  subnet_id = module.vpc.public_subnets[count.index]

  tags = {
    Name = "${var.service.name}-instance-${count.index}"
    Terraform = "true"
    Environment = var.service.env
  }
}