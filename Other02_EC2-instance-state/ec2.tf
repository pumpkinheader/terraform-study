resource "aws_instance" "foo" {
  count = 2
  ami           = "ami-03d79d440297083e3"
  instance_type = "t2.micro"
  associate_public_ip_address          = false 

  subnet_id = module.vpc.public_subnets[count.index]

  tags = {
    Name = "${var.service.name}-instance-${count.index}"
    Changed = "true"
    Terraform = "true"
    Environment = var.service.env
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.foo[1].id
  allocation_id = aws_eip.example.id
}

resource "aws_eip" "example" {
  vpc = true
}