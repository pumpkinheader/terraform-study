resource "aws_instance" "foo" {
  ami           = "ami-03d79d440297083e3"
  instance_type = "t3.micro"
  associate_public_ip_address          = false 
  iam_instance_profile = "EC2RoleforSSM"
  vpc_security_group_ids      = [aws_security_group.ec2.id]

  subnet_id = module.vpc.public_subnets[0]

    root_block_device {
      volume_size = 50
      volume_type = "gp3"
      delete_on_termination = true
    }

  tags = {
    Name = "${var.service.name}-instance"
    Changed = "true"
    Terraform = "true"
    Environment = var.service.env
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.foo.id
  allocation_id = aws_eip.minecraft.id
}

resource "aws_eip" "minecraft" {
  vpc = true
}


data "aws_iam_policy_document" "ssm_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "ssm_role" {
  name = "EC2RoleforSSM"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role" "ssm_role" {
  name               = "EC2RoleforSSM"
  assume_role_policy = data.aws_iam_policy_document.ssm_role.json
}

resource "aws_iam_role_policy_attachment" "ssm_role" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_security_group" "ec2" {
  name        = "inomaso-dev-ec2-sg"
  description = "inomaso-dev-ec2-sg"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "inomaso-dev-ec2-sg"
  }
}
